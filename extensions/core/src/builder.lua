local function hasExtension (extensionName)
	if extensions then
		for i=1,#extensions do
			if extensions[i] == extensionName then return true end
		end
	end

	return false
end


local function evalConfig (extensionDir, propertyModule)
	local eval = require "eval"

	local env = {}
	if propertyModule then env.property = propertyModule else env.property = properties end
	setmetatable(env, { __index = _G })

	local config = eval.file(extensionDir .. "/config.lua", env)
	return config
end


local function generateOverrideTypesTable ()
	if not hasExtension("orm") then return end


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
	modules["_"] = databaseConnection


	-- aggregates all types --
	for i=1, #extensions do
		local extensionName = extensions[i]
		local extensionDir = extensionsDir .. "/" .. extensionName

		local config = evalConfig(extensionDir)

		if config.types then
			for j=1, #config.types do
				local module = config.types[j]

				local scriptFileName = extensionsDir .. "/" .. extensionName .. "/src/" .. module
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
	local tableConfig = require("db.api." .. databaseConnection.rdbms)
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
	persistence.store(extensionsDir .. "/core/src/types.lua", modules);

	return modules

end -- end generateOverrideTypesTable


local function generateDatabaseListeners ()

	local param = require "param"
	local persistence = require "persistence"


	local modules = {}

	-- aggregates all databaseListeners --
	for i=1, #extensions do
		local extensionName = extensions[i]
		local extensionDir = extensionsDir .. "/" .. extensionName

		local config = evalConfig(extensionDir)


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
	persistence.store(extensionsDir .. "/core/src/databaseListeners.lua", modules);

	return modules

end -- end generateDatabaseListeners


local function generatePropertyTable (type, last)

	local json = require "dkjson"
	local persistence = require "persistence"

	local modules = {}
	setmetatable(modules, { __index = function (t, k) return "" end }) -- workaround "Attempt to concatenate a nil value"

	for i=1, #extensions do
		local extensionName = extensions[i]
		local extensionDir = extensionsDir .. "/" .. extensionName

		local config
		if type == "property" then
			config = evalConfig(extensionDir, modules)
		else
			config = evalConfig(extensionDir)
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

	persistence.store(extensionsDir .. "/core/src/" .. type .. ".lua", modules);

	return modules

end -- end generatePropertyTable


local function generateOverrideTable (type, extras)

	local persistence = require "persistence"

	local modules = {}

	for i=1, #extensions do
		local extensionName = extensions[i]
		local extensionDir = extensionsDir .. "/" .. extensionName

		local config = evalConfig(extensionDir)

		if config[type] then
			for j=1, #config[type] do
				local module = config[type][j]

				local scriptFileName = extensionsDir .. "/" .. extensionName .. "/src/" .. module.script

				if modules[module.name] then
					local allScriptFileNames = modules[module.name]
					table.insert(allScriptFileNames, scriptFileName)
				else
					local meta = {extension = i}

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

	persistence.store(extensionsDir .. "/core/src/" .. type .. ".lua", modules);

	return modules

end -- end generateOverrideTable


local function aggregateOverrideTable (modules, fileName, operation)

	local parse = require "parse"
	local json = require "dkjson"

	local file = assert(io.open(fileName, "w"))

	if operation == "json" then
		file:write("/* property */ \n\n")
		file:write("var property = " .. json.encode(properties) .. "\n\n\n")

		file:write("/* localization */ \n\n")
		file:write("var localization = " .. json.encode(localizations) .. "\n\n\n")
	end

	for i=1, #extensions do
		for name, scripts in pairs(modules) do
			if scripts[1].extension == i then -- first script is the number of the extension
				for j=2, #scripts do -- first script is the number of the extension
					local script = scripts[j]

					local f = assert(io.open(script, "r"))
					local content = f:read("*all")
					f:close()

					file:write(string.format("/* [%s] %s */ \n\n", name, script))

					if operation == "parse" then 
						file:write(parse(content, properties) .. "\n\n\n")
					else
						file:write(content .. "\n\n\n")
					end
				end
			end
		end
	end

	file:close()

end -- end of aggregateOverrideTable


local function generateStaticConfig ()

	local persistence = require "persistence"

	local staticDirs = {staticLocation}

	for i=1, #extensions do
		local extensionName = extensions[i]
		local extensionDir = extensionsDir .. "/" .. extensionName

		local config = evalConfig(extensionDir)

		if config.static then
			for j=1, #config.static do
				local staticDirName = config.static[j]

				local staticDirPath = "/" .. extensionName .. "/" .. staticDirName .. "/"

				staticDirs[#staticDirs + 1] = staticDirPath
			end
		end
	end

	persistence.store(extensionsDir .. "/core/src/static.lua", staticDirs);

	return staticDirs

end -- end generateStaticConfig


local function generateForbidStaticConfig ()

	local persistence = require "persistence"

	local staticDirs = {}

	staticDirs[#staticDirs + 1] = "\\.lua$"

	for i=1, #extensions do
		local extensionName = extensions[i]
		local extensionDir = extensionsDir .. "/" .. extensionName

		staticDirs[#staticDirs + 1] = "/" .. extensionName .. "/src/"

		local config = evalConfig(extensionDir)

		if config.forbidStatic then
			for j=1, #config.forbidStatic do
				local staticDirName = config.static[j]

				local staticDirPath = "/" .. extensionName .. "/" .. staticDirName .. "/"

				staticDirs[#staticDirs + 1] = staticDirPath
			end
		end
	end

	persistence.store(extensionsDir .. "/core/src/forbidStatic.lua", staticDirs);

	return staticDirs

end -- end generateForbidStaticConfig


local function generateNginxConfig ()

	local parse = require "parse"

	local accessScripts = generateOverrideTable("access")

	local locations = {}

	local locationScripts = generateOverrideTable("locations", {"requestBody", "access", "resolver"})

	for name, scripts in pairs(locationScripts) do
		local scriptFileName = scripts[#scripts] -- use only last script

		local data = {
			url = name, 
			rootPath = rootPath,
			script = parse([[content_by_lua_file '{{script}}';]], {script = scriptFileName}),
			extensionsDir = extensionsDir,
		}
		if scripts[1].requestBody then
			if type(scripts[1].requestBody) == "boolean" then
				data.requestBody = parse(requestBody, {maxBodySize = maxBodySize})
			else
				data.requestBody = parse(requestBody, {maxBodySize = scripts[1].requestBody})
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

		locations[#locations + 1] = parse(nginxLocationTemplate, data)
	end


	local staticLocations = {}

	local staticDirs = generateStaticConfig()

	for i=1, #staticDirs do
		local staticDir = staticDirs[i]

		staticLocations[#staticLocations + 1] = parse(nginxStaticLocationTemplate, {url = staticDir, rootPath = rootPath})
	end


	local forbidStaticLocations = {}

	local forbidStaticDirs = generateForbidStaticConfig()

	for i=1, #forbidStaticDirs do
		local forbidStaticDir = forbidStaticDirs[i]

		forbidStaticLocations[#forbidStaticLocations + 1] = parse(nginxForbidStaticLocationTemplate, {url = forbidStaticDir})
	end


	local t = parse(nginxConfigTemplate, {
		port = port,
		securePort = securePort,
		server_name = server_name,
		ssl_certificate = ssl_certificate,
		workerProcesses = workerProcesses,
		workerConnections = workerConnections,
		locations = table.concat(locations),
		externalPaths = externalPaths,
		externalCPaths = externalCPaths,
		errorLog = errorLog,
		accessLog = accessLog,
		staticLocations = table.concat(staticLocations),
		forbidStaticLocations = table.concat(forbidStaticLocations),
		includeDrop = includeDrop
	})


	local file = assert(io.open(nginxConfFileName or "nginx.conf", "w"))
	file:write(t .. "\n")
	file:close()
end -- end of generateNginxConfig


local function generateModulesConfig ()

	generateOverrideTable("modules")

end -- end of generateModulesConfig


local function generateJavaScriptConfig ()
	local javaScriptFileName = extensionsDir .. "/static/widgets.js" 
	if minifyJavaScript then javaScriptFileName = extensionsDir .. "/static/widgets.original.js" end

	local javascripts = generateOverrideTable("javascripts")
	aggregateOverrideTable(javascripts, javaScriptFileName, "json")

	if minifyJavaScript then
		javaScriptMinFileName = extensionsDir .. "/static/widgets.js"
		os.execute(string.format(minifyCommand, javaScriptFileName, javaScriptMinFileName))
	end

end -- end generateJavaScriptConfig


local function generateStyleSheetConfig ()

	styleSheetFileName = extensionsDir .. "/static/widgets.css" 

	local stylesheets = generateOverrideTable("stylesheets")
	aggregateOverrideTable(stylesheets, styleSheetFileName, "parse")

end -- end generateStyleSheetConfig


local function generateTestConfig ()

	testFileName = extensionsDir .. "/static/tests.js" 

	local tests = generateOverrideTable("tests")
	aggregateOverrideTable(tests, testFileName)

end -- end generateTestConfig


local function build ()
	properties = generatePropertyTable("property", globalParameters)
	localizations = generatePropertyTable("localization")

	local util = require "util"
	util.removeDirectory(extensionsDir .. "/static")
	util.createDirectory(extensionsDir .. "/static")

	generateJavaScriptConfig()
	generateStyleSheetConfig()
	generateTestConfig()
	generateNginxConfig()
	generateOverrideTypesTable()
	generateDatabaseListeners()
	generateModulesConfig()
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