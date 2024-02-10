local buildExtensionConfig = [[
local config = {} -- extension configuration

config.module = {
  --access.lua
  --forbidstatic.lua
  --frontend.lua
  --html.lua
  --javascript.lua
  {name = "localization", script = "localization.lua"},
  --location.lua
  --module.lua
  --parse.lua
  {name = "property", script = "property.lua"},
  --static.lua
  --stylesheet.lua
  {name = "type", script = "type.lua"},
}

return config -- return extension configuration
]]


local sslCertificate = [[
  
  listen {{securePort}} ssl;

  ssl_certificate     ./ssl_certificate/server.crt;
  ssl_certificate_key ./ssl_certificate/server.key;
  ssl_protocols       TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers         HIGH:!aNULL:!MD5;

]]


local requestBody = [[

  # force reading request body (default off)
  lua_need_request_body on;
  client_max_body_size {{maxBodySize}};
  client_body_buffer_size {{maxBodySize}};

]]


local uploadBody = [[

  client_max_body_size {{maxBodySize}};
  client_body_buffer_size {{maxBodySize}};

]]


local nginxLocationTemplate = [[

  location {{url}} {
    {{rootPath}}
    
    # MIME type determined by default_type:
    default_type 'text/html';

    {{resolver}}

    {{requestBody}}
    
    {{uploadBody}}

    # ngx.var.octopusExtensionsDir
    set $octopusExtensionsDir '{{octopusExtensionsDir}}';
    # ngx.var.octopusHostDir
    set $octopusHostDir '{{octopusHostDir}}';

    {{access}}

    {{script}}
  }

]]


local nginxStaticLocationTemplate = [[

  location ^~ {{url}} {
    {{rootPath}}
    
    # Some basic cache-control for static files to be sent to the browser
    expires max;
    add_header Pragma public;
    add_header Cache-Control "public, must-revalidate, proxy-revalidate";
  }

]]


local nginxForbidStaticLocationTemplate = [[

  location ~* {{url}} {access_log off; log_not_found off; deny all;}

]]


local nginxConfigTemplate = [[

  server {
    lua_code_cache {{luaCodeCache}};
    
    {{errorLog}}

    {{accessLog}}

    listen {{port}};

    server_name {{serverName}};

    {{sslCertificate}}

    # remove the robots line if you want to use wordpress' virtual robots.txt
    location = /robots.txt  { access_log off; log_not_found off; }
    location = /favicon.ico { access_log off; log_not_found off; }

    # this prevents hidden files (beginning with a period) from being served
    location ~ /\.          { access_log off; log_not_found off; deny all; }
    
    {{forbidstaticLocations}}

    {{staticLocations}}

    {{locations}}

    {{includeDrop}}

  } # end of server

]]


local function hasExtension (siteConfig, extensionName)
  if siteConfig.extensions then
    for i=1,#siteConfig.extensions do
      if siteConfig.extensions[i][2] == extensionName then return true end
    end
  end

  return false
end


local function evalConfig (siteConfig, extensionDir)
  local eval = require "eval"

  local env = {}
  if siteConfig.data.properties then 
    env.property = siteConfig.data.properties
  else
    env.property = {}
    setmetatable(env.property, { __index = function (t, k) return "" end }) -- workaround "Attempt to concatenate a nil value"
  end
  setmetatable(env, { __index = _G })

  local config = eval.file(extensionDir .. "/config.lua", env)
  return config
end


local function generateOverrideTypesTable (siteConfig)
  local persistence = require "persistence"
  local eval = require "eval"
  local util = require "util"
  local luaorm = require "rocky.luaorm"
  local typedef = require "rocky.typedef"

  local modules = {}

  -- aggregates all types --
  for i=1, #siteConfig.extensions do
    local extensionName = siteConfig.extensions[i][2]
    local extensionDir = siteConfig.extensions[i][1] .. "/" .. extensionName

    local config = evalConfig(siteConfig, extensionDir)

    if config.type then
      for j=1, #config.type do
        local module = config.type[j]

        local scriptFileName = extensionDir .. "/src/" .. module
        local types = eval.file(scriptFileName, typedef)

        for typeKey, typeValue in pairs(types) do 
          if modules[typeKey] then
            for typePropertyKey, typePropertyValue in pairs(typeValue) do 
              modules[typeKey][typePropertyKey] = typePropertyValue
            end
          else
            modules[typeKey] = typeValue
          end
        end
      end
    end
  end

  assert(siteConfig.databaseConnection.rdbms, "no databaseConnection.rdbms set, check site's config.lua")
  local modules = luaorm.build(modules, siteConfig.databaseConnection.rdbms)

  -- persist types --
  persistence.store(siteConfig.octopusHostDir .. "/build/src/type.lua", modules)

  return modules

end -- end generateOverrideTypesTable


local function generatePropertyTable (siteConfig, type, last)

  local json = require "json"
  local persistence = require "persistence"

  local modules = {}

  -- init property with frontend data 
  if type == "property" then
    for k,v in pairs(siteConfig.data.frontend) do modules[k] = v end
  end

  for i=1, #siteConfig.extensions do
    local extensionName = siteConfig.extensions[i][2]
    local extensionDir = siteConfig.extensions[i][1] .. "/" .. extensionName

    local config = evalConfig(siteConfig, extensionDir)

    if config[type] then
      for k,v in pairs(config[type]) do
        modules[k] = v
      end
    end
  end

  -- override with global parameters --
  if last then
    for k,v in pairs(last) do
      modules[k] = v
    end
  end

  persistence.store(siteConfig.octopusHostDir .. "/build/src/" .. type .. ".lua", modules)

  return modules

end -- end generatePropertyTable


local function generateOverrideTable (siteConfig, type, extras)

  local persistence = require "persistence"

  local modules = {}
  
  if type == "module" then
    local config = loadstring(buildExtensionConfig)()
    for j=1, #config[type] do
      local module = config[type][j]
      local extensionDir = siteConfig.octopusHostDir .. "/build"
      local scriptFileName = extensionDir .. "/src/" .. module.script
      local meta = {extensionDir = extensionDir, octopusHostDir = siteConfig.octopusHostDir, extension = 0}
      modules[module.name] = { meta, scriptFileName }
    end
  end

  for i=1, #siteConfig.extensions do
    local extensionName = siteConfig.extensions[i][2]
    local extensionDir = siteConfig.extensions[i][1] .. "/" .. extensionName

    local config = evalConfig(siteConfig, extensionDir)

    if config[type] then
      for j=1, #config[type] do
        local module = config[type][j]

        local scriptFileName = extensionDir .. "/src/" .. module.script

        if modules[module.name] then
          local allScriptFileNames = modules[module.name]
          table.insert(allScriptFileNames, scriptFileName)
        else
          local meta = {extensionDir = extensionDir, octopusHostDir = siteConfig.octopusHostDir, extension = i}

          if extras and #extras > 0 then
            for k=1, #extras do
              meta[extras[k]] = module[extras[k]]
            end
          end

          modules[module.name] = { meta, scriptFileName }
        end
      end
    end
  end

  persistence.store(siteConfig.octopusHostDir .. "/build/src/" .. type .. ".lua", modules)

  return modules

end -- end generateOverrideTable


local function getAggregateFile (siteConfig, files, folder, meta, customFile)
  
  local json = require "json"
  
  local targetFile = customFile or meta.file
  
  if not files[targetFile] then
    local file = assert(io.open(folder .. "/" .. targetFile, "w"))
    files[targetFile] = file
    
    if meta.json then
      file:write("/* property */ \n")
      file:write("var property = " .. json.encode(siteConfig.data.frontend) .. "\n")
  
      file:write("/* localization */ \n")
      file:write("var localization = " .. json.encode(siteConfig.data.localizations) .. "\n")
    end
    
    if meta.css then
      file:write('@charset "UTF-8"; \n')
    end
  end

  return files[targetFile]
  
end -- end getAggregateFile


local function closeAggregateFiles (files)
  for _,file in pairs(files) do
    file:close()
  end
end -- end closeAggregateFiles


local function aggregateOverrideTable (siteConfig, modules, folder, meta)

  local parse = require "parse"
  
  local files = {}
  
  for i=1, #siteConfig.extensions do
    for name, scripts in pairs(modules) do
      if scripts[1].extension == i then -- first script holds metadata
        for j=2, #scripts do -- first script holds metadata
          local script = scripts[j]

          local f = assert(io.open(script, "r"))
          local content = f:read("*all")
          f:close()
          
          local file = getAggregateFile(siteConfig, files, folder, meta, scripts[1].into)

          file:write(string.format("/* [%s] */ \n", name))

          if meta.parse then 
            file:write(parse(content, siteConfig.data.properties) .. "\n")
          else
            file:write(content .. "\n")
          end
        end
      end
    end
  end

  closeAggregateFiles(files)

end -- end of aggregateOverrideTable


local function generateStaticConfig (siteConfig)

  local persistence = require "persistence"

  local staticDirs = {{siteConfig.octopusHostDir, "/build/static/"}}

  for i=1, #siteConfig.extensions do
    local extensionName = siteConfig.extensions[i][2]
    local extensionDir = siteConfig.extensions[i][1] .. "/" .. extensionName

    local config = evalConfig(siteConfig, extensionDir)

    if config.static then
      for j=1, #config.static do
        local staticDirName = config.static[j]

        local staticDirPath = "/" .. extensionName .. "/" .. staticDirName .. "/"

        staticDirs[#staticDirs + 1] = {siteConfig.extensions[i][1], staticDirPath}
      end
    end
  end

  persistence.store(siteConfig.octopusHostDir .. "/build/src/static.lua", staticDirs)

  return staticDirs

end -- end generateStaticConfig


local function generateForbidStaticConfig (siteConfig)

  local persistence = require "persistence"

  local staticDirs = {}

  staticDirs[#staticDirs + 1] = "\\.lua$"

  for i=1, #siteConfig.extensions do
    local extensionName = siteConfig.extensions[i][2]
    local extensionDir = siteConfig.extensions[i][1] .. "/" .. extensionName

    staticDirs[#staticDirs + 1] = "/" .. extensionName .. "/src/"

    local config = evalConfig(siteConfig, extensionDir)

    if config.forbidstatic then
      for j=1, #config.forbidstatic do
        local staticDirName = config.forbidstatic[j]

        local staticDirPath = "/" .. extensionName .. "/" .. staticDirName .. "/"

        staticDirs[#staticDirs + 1] = staticDirPath
      end
    end
  end

  persistence.store(siteConfig.octopusHostDir .. "/build/src/forbidstatic.lua", staticDirs)

  return staticDirs

end -- end generateForbidStaticConfig


local function generateNginxConfig (siteConfig)

  local parse = require "parse"

  local accessScripts = generateOverrideTable(siteConfig, "access", {})

  local locations = {}

  local locationScripts = generateOverrideTable(siteConfig, "location", {"requestBody", "uploadBody", "access", "resolver"})

  for name, scripts in pairs(locationScripts) do
    local scriptFileName = scripts[#scripts] -- use only last script

    local data = {
      url = name, 
      rootPath = "root " .. scripts[1].extensionDir .. ";",
      script = parse([[content_by_lua_file '{{script}}';]], {script = scriptFileName}),
      octopusExtensionsDir = siteConfig.octopusExtensionsDir,
      octopusHostDir = siteConfig.octopusHostDir,
    }
    if scripts[1].requestBody then
      if type(scripts[1].requestBody) == "boolean" then
        data.requestBody = parse(siteConfig.requestBody or requestBody, {maxBodySize = siteConfig.maxBodySize})
      else
        data.requestBody = parse(siteConfig.requestBody or requestBody, {maxBodySize = scripts[1].requestBody})
      end
    end
    if scripts[1].uploadBody then
      if type(scripts[1].uploadBody) == "boolean" then
        data.uploadBody = parse(siteConfig.uploadBody or uploadBody, {maxBodySize = siteConfig.maxBodySize})
      else
        data.uploadBody = parse(siteConfig.uploadBody or uploadBody, {maxBodySize = scripts[1].uploadBody})
      end
    end
    if scripts[1].access then
      local accessScriptFileNames = accessScripts[scripts[1].access]
      if accessScriptFileNames then -- if access script is allowed
        data.access = parse([[access_by_lua_file '{{script}}';]], {script = accessScriptFileNames[#accessScriptFileNames]}) 
      end
    end
    if scripts[1].resolver then
      data.resolver = parse([[resolver {{resolver}};]], {resolver = scripts[1].resolver}) 
    end

    locations[#locations + 1] = parse(siteConfig.nginxLocationTemplate or nginxLocationTemplate, data)
  end


  local staticLocations = {}

  local staticDirs = generateStaticConfig(siteConfig)

  for i=1, #staticDirs do
    local staticDir = staticDirs[i][2]

    staticLocations[#staticLocations + 1] = parse(
      siteConfig.nginxStaticLocationTemplate or nginxStaticLocationTemplate, 
      {url = staticDir, rootPath = "root " .. staticDirs[i][1] .. ";"})
  end


  local forbidstaticLocations = {}

  local forbidstaticDirs = generateForbidStaticConfig(siteConfig)

  for i=1, #forbidstaticDirs do
    local forbidstaticDir = forbidstaticDirs[i]

    forbidstaticLocations[#forbidstaticLocations + 1] = parse(
      siteConfig.nginxForbidStaticLocationTemplate or nginxForbidStaticLocationTemplate, {url = forbidstaticDir})
  end


  local t = parse(siteConfig.nginxConfigTemplate or nginxConfigTemplate, {
    port = siteConfig.port,
    securePort = siteConfig.securePort,
    serverName = siteConfig.serverName,
    sslCertificate = parse(siteConfig.sslCertificate or sslCertificate, {securePort = siteConfig.securePort}),
    locations = table.concat(locations),
    externalPaths = siteConfig.externalPaths,
    externalCPaths = siteConfig.externalCPaths,
    errorLog = siteConfig.errorLog,
    accessLog = siteConfig.accessLog,
    luaCodeCache = siteConfig.luaCodeCache,
    staticLocations = table.concat(staticLocations),
    forbidstaticLocations = table.concat(forbidstaticLocations),
    includeDrop = siteConfig.includeDrop
  })


  local file = assert(io.open(siteConfig.nginxConfFileName or "nginx.conf", "w"))
  file:write(t .. "\n")
  file:close()
end -- end of generateNginxConfig


local function generateModulesConfig (siteConfig)

  generateOverrideTable(siteConfig, "module", {})

end -- end of generateModulesConfig


local function generateHtmlConfig (siteConfig)

  generateOverrideTable(siteConfig, "html", {})

end -- end of generateHtmlConfig


local function generateJavaScriptConfig (siteConfig)
  local folder = siteConfig.octopusHostDir .. "/build/static"

  local javascripts = generateOverrideTable(siteConfig, "javascript", {"into"})
  aggregateOverrideTable(siteConfig, javascripts, folder, {file = "widgets.js", json = true})

end -- end generateJavaScriptConfig


local function generateStyleSheetConfig (siteConfig)

  folder = siteConfig.octopusHostDir .. "/build/static" 

  local stylesheets = generateOverrideTable(siteConfig, "stylesheet", {"into"})
  aggregateOverrideTable(siteConfig, stylesheets, folder, {file = "widgets.css", css = true, parse = true})

end -- end generateStyleSheetConfig


local function generateParseConfig (siteConfig)
  
  local parse = require "parse"
  
  local parseScripts = generateOverrideTable(siteConfig, "parse", {})
  
  for name, scripts in pairs(parseScripts) do
    local scriptFileName = scripts[#scripts] -- use only last script
    
    local f = assert(io.open(scriptFileName, "r"))
    local content = f:read("*all")
    f:close()
          
    local parsedContent = parse(content, siteConfig.data.properties)
    
    local file = assert(io.open(siteConfig.octopusHostDir .. name, "w"))
    file:write(parsedContent)
    file:close()
  end
end -- end generateParseConfig


local function clear (siteConfig)
  local fileutil = require "fileutil"
  
  fileutil.removeDirectory(siteConfig.octopusHostDir .. "/build")
end


local function build (siteConfig)
  local fileutil = require "fileutil"
  
  fileutil.removeDirectory(siteConfig.octopusHostDir .. "/build")
  fileutil.createDirectory(siteConfig.octopusHostDir .. "/build")
  local file = assert(io.open(siteConfig.octopusHostDir .. "/build/config.lua", "w"))
  file:write(buildExtensionConfig)
  file:close()
  fileutil.createDirectory(siteConfig.octopusHostDir .. "/build/src")
  fileutil.createDirectory(siteConfig.octopusHostDir .. "/build/static")

  siteConfig.data = {}
  siteConfig.data.frontend = generatePropertyTable(siteConfig, "frontend")
  siteConfig.globalParameters.databaseConnection = siteConfig.databaseConnection
  siteConfig.data.properties = generatePropertyTable(siteConfig, "property", siteConfig.globalParameters)
  siteConfig.data.localizations = generatePropertyTable(siteConfig, "localization")

  generateParseConfig(siteConfig)
  generateHtmlConfig(siteConfig)
  generateJavaScriptConfig(siteConfig)
  generateStyleSheetConfig(siteConfig)
  generateNginxConfig(siteConfig)
  generateOverrideTypesTable(siteConfig)
  generateModulesConfig(siteConfig)
end


local m = {}
m.generateOverrideTable = generateOverrideTable
m.aggregateOverrideTable = aggregateOverrideTable
m.generateOverrideTypesTable = generateOverrideTypesTable
m.generateStaticConfig = generateStaticConfig
m.generateForbidStaticConfig = generateForbidStaticConfig
m.generateNginxConfig = generateNginxConfig
m.generateModulesConfig = generateModulesConfig
m.generateHtmlConfig = generateHtmlConfig
m.generateJavaScriptConfig = generateJavaScriptConfig
m.generateStyleSheetConfig = generateStyleSheetConfig
m.generateParseConfig = generateParseConfig
m.clear = clear
m.build = build
return m