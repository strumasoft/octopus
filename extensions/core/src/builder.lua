local buildExtensionConfig = [[
local config = {} -- extension configuration

config.modules = {
	{name = "access", script = "access.lua"},
	--forbidstatic.lua
	{name = "htmltemplates", script = "htmltemplates.lua"},
	--javascripts.lua
	{name = "localization", script = "localization.lua"},
	--locations.lua
	{name = "modules", script = "modules.lua"},
	--parse.lua
	{name = "property", script = "property.lua"},
	--static.lua
	--stylesheets.lua
	{name = "tests", script = "tests.lua"},
	{name = "types", script = "types.lua"},
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


local function evalConfig (siteConfig, extensionDir, propertyModule)
	local eval = require "eval"

	local env = {}
	if propertyModule then env.property = propertyModule else env.property = siteConfig.properties end
	setmetatable(env, { __index = _G })

	local config = eval.file(extensionDir .. "/config.lua", env)
	return config
end


local function generateOverrideTypesTable (siteConfig)
	if not hasExtension(siteConfig, "orm") then return end
	

	local function hasMany (type, property)
		if property then
			return {type = type .. "." .. property, has = "many"}
		else
			return {type = type, has = "many"}
		end
	end

	local function hasOne (type, property)
		if property then
			return {type = type .. "." .. property, has = "one"}
		else
			return {type = type, has = "one"}
		end
	end


	local persistence = require "persistence"
	local eval = require "eval"
	local util = require "util"

	local modules = {}
	modules["_"] = siteConfig.databaseConnection


	-- aggregates all types --
	for i=1, #siteConfig.extensions do
		local extensionName = siteConfig.extensions[i][2]
		local extensionDir = siteConfig.extensions[i][1] .. "/" .. extensionName

		local config = evalConfig(siteConfig, extensionDir)

		if config.types then
			for j=1, #config.types do
				local module = config.types[j]

				local scriptFileName = extensionDir .. "/src/" .. module
				local types = eval.file(scriptFileName, {hasMany = hasMany, hasOne = hasOne})

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


	-- put types in the standart format & add length to string --
	local tableConfig = require("db.api." .. siteConfig.databaseConnection.rdbms)
	for name,t in pairs(modules) do
		if name ~= "_" then
			for k,v in pairs(t) do
				if type(v) ~= "table" then
					if v == "string" then
						t[k] = {type = "string", length = tableConfig.stringLength}
					else
						if v ~= "id" and v ~= "integer" and v ~= "float" and v ~= "boolean" and v ~= "string" then
							t[k] = {type = v, has = "one"}
						else
							t[k] = {type = v}
						end
					end
				elseif v.type == "string" and not v.length then
					v.length = tableConfig.stringLength
				end
			end

			-- add unique ID
			t.id = {type = "id"}
		end
	end


	-- create relations --
	local relations = {}
	for name,t in pairs(modules) do
		if name ~= "_" then
			for k,v in pairs(t) do
				local property = t[k]
				if property.type ~= "id" and property.type ~= "integer" and property.type ~= "float" and property.type ~= "boolean" and property.type ~= "string" then
					local from = name .. "." .. k
					local to = property.type

					-- check relation declaration
					if property.type:find(".", 1, true) then
						local typeAndProperty = util.split(property.type, ".")
						if modules[typeAndProperty[1]] then
							local reference = modules[typeAndProperty[1]][typeAndProperty[2]]
							if not reference or reference.type ~= from then 
								error("properties " .. from .. " and " .. to .. " are not linked!")
							end
						else
							error("type " .. typeAndProperty[1] .. " does not exists!")
						end
					else
						if not modules[property.type] then
							error("type " .. property.type .. " does not exists!")
						end
					end

					-- create relation
					if from < to then
						relations[from .. "-" .. to] = {id = {type = "id"}, key = {type = "string", length = 36}, value = {type = "string", length = 36}}
					else
						relations[to .. "-" .. from] = {id = {type = "id"}, key = {type = "string", length = 36}, value = {type = "string", length = 36}}
					end
				end
			end
		end
	end


	-- copy relations to types
	for k,v in pairs(relations) do
		modules[k] = v
	end


	-- persist types --
	persistence.store(siteConfig.octopusHostDir .. "/build/src/types.lua", modules);

	return modules

end -- end generateOverrideTypesTable


local function generatePropertyTable (siteConfig, type, last)

	local json = require "json"
	local persistence = require "persistence"

	local modules = {}
	setmetatable(modules, { __index = function (t, k) return "" end }) -- workaround "Attempt to concatenate a nil value"

	for i=1, #siteConfig.extensions do
		local extensionName = siteConfig.extensions[i][2]
		local extensionDir = siteConfig.extensions[i][1] .. "/" .. extensionName

		local config
		if type == "property" then
			config = evalConfig(siteConfig, extensionDir, modules)
		else
			config = evalConfig(siteConfig, extensionDir)
		end

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

	setmetatable(modules, nil) -- remove the workaround

	persistence.store(siteConfig.octopusHostDir .. "/build/src/" .. type .. ".lua", modules);

	return modules

end -- end generatePropertyTable


local function generateOverrideTable (siteConfig, type, extras, method)

	local persistence = require "persistence"

	local modules = {}
	
	if type == "modules" then
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

	persistence.store(siteConfig.octopusHostDir .. "/build/src/" .. type .. ".lua", modules, method);

	return modules

end -- end generateOverrideTable


local function getAggregateFile (siteConfig, files, folder, meta, customFile)
	
	local json = require "json"
	
	local targetFile = customFile or meta.file
	
	if not files[targetFile] then
		local file = assert(io.open(folder .. "/" .. targetFile, "w"))
		files[targetFile] = file
		
		if meta.json then
			file:write("/* property */ \n\n")
			file:write("var property = " .. json.encode(siteConfig.properties) .. "\n\n\n")
	
			file:write("/* localization */ \n\n")
			file:write("var localization = " .. json.encode(siteConfig.localizations) .. "\n\n\n")
		end
		
		if meta.css then
			file:write('@charset "UTF-8"; \n\n\n')
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

					file:write(string.format("/* [%s] %s */ \n\n", name, script))

					if meta.parse then 
						file:write(parse(content, siteConfig.properties) .. "\n\n\n")
					else
						file:write(content .. "\n\n\n")
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

	persistence.store(siteConfig.octopusHostDir .. "/build/src/static.lua", staticDirs);

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

	persistence.store(siteConfig.octopusHostDir .. "/build/src/forbidstatic.lua", staticDirs);

	return staticDirs

end -- end generateForbidStaticConfig


local function generateNginxConfig (siteConfig)

	local parse = require "parse"

	local accessScripts = generateOverrideTable(siteConfig, "access", {})

	local locations = {}

	local locationScripts = generateOverrideTable(siteConfig, "locations", {"requestBody", "uploadBody", "access", "resolver"})

	for name, scripts in pairs(locationScripts) do
		local scriptFileName = scripts[#scripts] -- use only last script

		local data = {
			url = name, 
			rootPath = "root " .. scripts[1].extensionDir .. ";",
			script = parse([[content_by_lua_file '{{script}}';]], {script = scriptFileName}),
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

	generateOverrideTable(siteConfig, "modules", {})

end -- end of generateModulesConfig


local function generateJavaScriptConfig (siteConfig)
	local javaScriptFileName = siteConfig.octopusHostDir .. "/build/static"

	local javascripts = generateOverrideTable(siteConfig, "javascripts", {"into"})
	aggregateOverrideTable(siteConfig, javascripts, javaScriptFileName, {file = "widgets.js", json = true})

end -- end generateJavaScriptConfig


local function generateStyleSheetConfig (siteConfig)

	styleSheetFileName = siteConfig.octopusHostDir .. "/build/static" 

	local stylesheets = generateOverrideTable(siteConfig, "stylesheets", {"into"})
	aggregateOverrideTable(siteConfig, stylesheets, styleSheetFileName, {file = "widgets.css", css = true, parse = true})

end -- end generateStyleSheetConfig


local function generateHtmlTemplateConfig (siteConfig)
	
	local parse = require "parse"
	
	local htmltemplates = generateOverrideTable(siteConfig, "htmltemplates", {})
	
	local modules = {}
	for name, scripts in pairs(htmltemplates) do
		local scriptFileName = scripts[#scripts] -- use only last script
		
		local f = assert(io.open(scriptFileName, "r"))
		local content = f:read("*all")
		f:close()
		
		modules[name] = content
	end
	
	local method = [=[
	
--local parse = require "parse"
local template = require "template"
local htmltemplates = obj1
local htmltemplates_metatable = getmetatable(htmltemplates) or {}
setmetatable(htmltemplates, htmltemplates_metatable)
htmltemplates_metatable.__call = function (t, key, context)
	assert(htmltemplates[key], "unknown html template " .. key)
	local view = htmltemplates[key]
	
	if not context then
		return view
	else
		--return parse(view, context)
		if {{luaCodeCache}} then
			return template.parsetemplate(view, context, key)
		else
			return template.parsetemplate(view, context, "no-cache")
		end
	end
end

	]=]

	local cache_templates
	if siteConfig.luaCodeCache == "on" then cache_templates = "true" else cache_templates = "false" end
	
	persistence.store(siteConfig.octopusHostDir .. "/build/src/htmltemplates.lua", modules, parse(method, {
		luaCodeCache = cache_templates,
	}))

end -- end generateHtmlTemplateConfig


local function generateTestConfig (siteConfig)

	testFileName = siteConfig.octopusHostDir .. "/build/static" 

	local tests = generateOverrideTable(siteConfig, "tests", {"into"})
	aggregateOverrideTable(siteConfig, tests, testFileName, {file = "tests.js"})

end -- end generateTestConfig


local function generateParseConfig (siteConfig)
	
	local parse = require "parse"
	
	local parseScripts = generateOverrideTable(siteConfig, "parse", {})
	
	for name, scripts in pairs(parseScripts) do
		local scriptFileName = scripts[#scripts] -- use only last script
		
		local f = assert(io.open(scriptFileName, "r"))
		local content = f:read("*all")
		f:close()
					
		local parsedContent = parse(content, siteConfig.properties)
		
		local file = assert(io.open(siteConfig.octopusHostDir .. name, "w"))
		file:write(parsedContent)
		file:close()
	end
end -- end generateParseConfig


local function build (siteConfig)
	local fileutil = require "fileutil"
	
	fileutil.removeDirectory(siteConfig.octopusHostDir .. "/build")
	fileutil.createDirectory(siteConfig.octopusHostDir .. "/build")
	local file = assert(io.open(siteConfig.octopusHostDir .. "/build/config.lua", "w"))
	file:write(buildExtensionConfig)
	file:close()
	fileutil.createDirectory(siteConfig.octopusHostDir .. "/build/src")
	fileutil.createDirectory(siteConfig.octopusHostDir .. "/build/static")
	
	siteConfig.properties = generatePropertyTable(siteConfig, "property", siteConfig.globalParameters)
	siteConfig.localizations = generatePropertyTable(siteConfig, "localization")

	generateParseConfig(siteConfig)
	generateJavaScriptConfig(siteConfig)
	generateStyleSheetConfig(siteConfig)
	generateHtmlTemplateConfig(siteConfig)
	generateTestConfig(siteConfig)
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
m.generateJavaScriptConfig = generateJavaScriptConfig
m.generateStyleSheetConfig = generateStyleSheetConfig
m.generateHtmlTemplateConfig = generateHtmlTemplateConfig
m.generateTestConfig = generateTestConfig
m.generateParseConfig = generateParseConfig
m.build = build
return m