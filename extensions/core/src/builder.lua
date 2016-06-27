local buildExtensionConfig = [[
local config = {} -- extension configuration

config.modules = {
	{name = "access", script = "access.lua"},
	{name = "databaseListeners", script = "databaseListeners.lua"},
	--forbidStatic.lua
	--javascripts.lua
	{name = "localization", script = "localization.lua"},
	--locations.lua
	{name = "modules", script = "modules.lua"},
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


local nginxLocationTemplate = [[

	location {{url}} {
		{{rootPath}}
		
		# MIME type determined by default_type:
		default_type 'text/html';

		{{resolver}}

		{{requestBody}}

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
		
		{{forbidStaticLocations}}

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


	local param = require "param"


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
						local typeAndProperty = param.split(property.type, ".")
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


local function generateDatabaseListeners (siteConfig)

	local param = require "param"
	local persistence = require "persistence"


	local modules = {}

	-- aggregates all databaseListeners --
	for i=1, #siteConfig.extensions do
		local extensionName = siteConfig.extensions[i][2]
		local extensionDir = siteConfig.extensions[i][1] .. "/" .. extensionName

		local config = evalConfig(siteConfig, extensionDir)


		if config.databaseListeners then
			for k,v in pairs(config.databaseListeners) do
				if modules[k] then
					local allDatabaseListenersNames = modules[k]
					for i=1,#v do
						local listenerExists = false
						for j=1,#allDatabaseListenersNames do
							if allDatabaseListenersNames[j] == v[i] then
								listenerExists = true
							end
						end

						if not listenerExists then -- do not add duplicate listeners
							table.insert(allDatabaseListenersNames, v[i])
						end
					end
				else
					local allDatabaseListenersNames = {}
					for i=1,#v do
						local listenerExists = false
						for j=1,#allDatabaseListenersNames do
							if allDatabaseListenersNames[j] == v[i] then
								listenerExists = true
							end
						end

						if not listenerExists then -- do not add duplicate listeners
							table.insert(allDatabaseListenersNames, v[i])
						end
					end
					modules[k] = allDatabaseListenersNames
				end
			end
		end
	end

	-- persist databaseListeners --
	persistence.store(siteConfig.octopusHostDir .. "/build/src/databaseListeners.lua", modules);

	return modules

end -- end generateDatabaseListeners


local function generatePropertyTable (siteConfig, type, last)

	local json = require "dkjson"
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


local function generateOverrideTable (siteConfig, type, extras)

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

					if extras then
						for k=1, #extras do
							meta[extras[k]] = module[extras[k]]
						end
					end

					modules[module.name] = { meta, scriptFileName }
				end
			end
		end
	end

	persistence.store(siteConfig.octopusHostDir .. "/build/src/" .. type .. ".lua", modules);

	return modules

end -- end generateOverrideTable


local function aggregateOverrideTable (siteConfig, modules, fileName, operation)

	local parse = require "parse"
	local json = require "dkjson"

	local file = assert(io.open(fileName, "w"))

	if operation == "json" then
		file:write("/* property */ \n\n")
		file:write("var property = " .. json.encode(siteConfig.properties) .. "\n\n\n")

		file:write("/* localization */ \n\n")
		file:write("var localization = " .. json.encode(siteConfig.localizations) .. "\n\n\n")
	end

	for i=1, #siteConfig.extensions do
		for name, scripts in pairs(modules) do
			if scripts[1].extension == i then -- first script is the number of the extension
				for j=2, #scripts do -- first script is the number of the extension
					local script = scripts[j]

					local f = assert(io.open(script, "r"))
					local content = f:read("*all")
					f:close()

					file:write(string.format("/* [%s] %s */ \n\n", name, script))

					if operation == "parse" then 
						file:write(parse(content, siteConfig.properties) .. "\n\n\n")
					else
						file:write(content .. "\n\n\n")
					end
				end
			end
		end
	end

	file:close()

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

		if config.forbidStatic then
			for j=1, #config.forbidStatic do
				local staticDirName = config.static[j]

				local staticDirPath = "/" .. extensionName .. "/" .. staticDirName .. "/"

				staticDirs[#staticDirs + 1] = staticDirPath
			end
		end
	end

	persistence.store(siteConfig.octopusHostDir .. "/build/src/forbidStatic.lua", staticDirs);

	return staticDirs

end -- end generateForbidStaticConfig


local function generateNginxConfig (siteConfig)

	local parse = require "parse"

	local accessScripts = generateOverrideTable(siteConfig, "access")

	local locations = {}

	local locationScripts = generateOverrideTable(siteConfig, "locations", {"requestBody", "access", "resolver"})

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


	local forbidStaticLocations = {}

	local forbidStaticDirs = generateForbidStaticConfig(siteConfig)

	for i=1, #forbidStaticDirs do
		local forbidStaticDir = forbidStaticDirs[i]

		forbidStaticLocations[#forbidStaticLocations + 1] = parse(
			siteConfig.nginxForbidStaticLocationTemplate or nginxForbidStaticLocationTemplate, {url = forbidStaticDir})
	end


	local t = parse(siteConfig.nginxConfigTemplate or nginxConfigTemplate, {
		port = siteConfig.port,
		securePort = siteConfig.securePort,
		serverName = siteConfig.serverName,
		sslCertificate = parse(siteConfig.sslCertificate or sslCertificate, {securePort = siteConfig.securePort}),
		workerProcesses = siteConfig.workerProcesses,
		workerConnections = siteConfig.workerConnections,
		locations = table.concat(locations),
		externalPaths = siteConfig.externalPaths,
		externalCPaths = siteConfig.externalCPaths,
		errorLog = siteConfig.errorLog,
		accessLog = siteConfig.accessLog,
		luaCodeCache = siteConfig.luaCodeCache,
		staticLocations = table.concat(staticLocations),
		forbidStaticLocations = table.concat(forbidStaticLocations),
		includeDrop = siteConfig.includeDrop
	})


	local file = assert(io.open(siteConfig.nginxConfFileName or "nginx.conf", "w"))
	file:write(t .. "\n")
	file:close()
end -- end of generateNginxConfig


local function generateModulesConfig (siteConfig)

	generateOverrideTable(siteConfig, "modules")

end -- end of generateModulesConfig


local function generateJavaScriptConfig (siteConfig)
	local javaScriptFileName = siteConfig.octopusHostDir .. "/build/static/widgets.js" 
	if minifyJavaScript then javaScriptFileName = siteConfig.octopusHostDir .. "/build/static/widgets.original.js" end

	local javascripts = generateOverrideTable(siteConfig, "javascripts")
	aggregateOverrideTable(siteConfig, javascripts, javaScriptFileName, "json")

	if minifyJavaScript then
		javaScriptMinFileName = siteConfig.octopusHostDir .. "/build/static/widgets.js"
		os.execute(string.format(minifyCommand, javaScriptFileName, javaScriptMinFileName))
	end

end -- end generateJavaScriptConfig


local function generateStyleSheetConfig (siteConfig)

	styleSheetFileName = siteConfig.octopusHostDir .. "/build/static/widgets.css" 

	local stylesheets = generateOverrideTable(siteConfig, "stylesheets")
	aggregateOverrideTable(siteConfig, stylesheets, styleSheetFileName, "parse")

end -- end generateStyleSheetConfig


local function generateTestConfig (siteConfig)

	testFileName = siteConfig.octopusHostDir .. "/build/static/tests.js" 

	local tests = generateOverrideTable(siteConfig, "tests")
	aggregateOverrideTable(siteConfig, tests, testFileName)

end -- end generateTestConfig


local function build (siteConfig)
	local util = require "util"
	
	util.removeDirectory(siteConfig.octopusHostDir .. "/build")
	util.createDirectory(siteConfig.octopusHostDir .. "/build")
	local file = assert(io.open(siteConfig.octopusHostDir .. "/build/config.lua", "w"))
	file:write(buildExtensionConfig)
	file:close()
	util.createDirectory(siteConfig.octopusHostDir .. "/build/src")
	util.createDirectory(siteConfig.octopusHostDir .. "/build/static")
	
	siteConfig.properties = generatePropertyTable(siteConfig, "property", siteConfig.globalParameters)
	siteConfig.localizations = generatePropertyTable(siteConfig, "localization")

	generateJavaScriptConfig(siteConfig)
	generateStyleSheetConfig(siteConfig)
	generateTestConfig(siteConfig)
	generateNginxConfig(siteConfig)
	generateOverrideTypesTable(siteConfig)
	generateDatabaseListeners(siteConfig)
	generateModulesConfig(siteConfig)
end


local m = {}
m.generateOverrideTable = generateOverrideTable
m.aggregateOverrideTable = aggregateOverrideTable
m.generateOverrideTypesTable = generateOverrideTypesTable
m.generateDatabaseListeners = generateDatabaseListeners
m.generateStaticConfig = generateStaticConfig
m.generateForbidStaticConfig = generateForbidStaticConfig
m.generateNginxConfig = generateNginxConfig
m.generateModulesConfig = generateModulesConfig
m.generateJavaScriptConfig = generateJavaScriptConfig
m.generateStyleSheetConfig = generateStyleSheetConfig
m.generateTestConfig = generateTestConfig
m.build = build
return m