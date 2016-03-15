-- save old require
local oldRequire = require


local function newModuleName (moduleName, moduleType)
	local extensionsDir = ngx.var.extensionsDir

	if moduleType then
		return extensionsDir .. ":" .. moduleType .. ":" .. moduleName
	else
		return extensionsDir .. ":" .. "modules" .. ":" .. moduleName
	end
end


-- cache modules, locations and access
package.loaded.MODULES = {}
local function loadModules (moduleType)
	local extensionsDir = ngx.var.extensionsDir
	local MODULES = package.loaded.MODULES

	if not MODULES[extensionsDir] then
		MODULES[extensionsDir] = {}
	end

	if MODULES[extensionsDir][moduleType] then
		return MODULES[extensionsDir][moduleType]
	else
		local modules = dofile(extensionsDir .. "/core/src/" .. moduleType ..".lua")
		MODULES[extensionsDir][moduleType] = modules
		return modules
	end
end


local function newRequire (moduleName, moduleType)
	if package.loaded[newModuleName(moduleName, moduleType)] then
		return package.loaded[newModuleName(moduleName, moduleType)] 
	end

	if moduleType then
		local modules = loadModules(moduleType)

		if modules[moduleName] then
			local scripts = modules[moduleName]
			local lastModule = dofile(scripts[#scripts]) -- use only last script

			package.loaded[newModuleName(moduleName, moduleType)] = lastModule

				return lastModule
		end
	else
		local modules = loadModules("modules")

		if modules[moduleName] then
			local lastModule, tempModule

			local scripts = modules[moduleName]
			for i=#scripts, 2, -1 do -- first script is the number of the extension
				local scriptModule = dofile(scripts[i])

				if i == #scripts then
					lastModule = scriptModule
					tempModule = lastModule
				else
					local nonLastModule = scriptModule
					setmetatable(tempModule, { __index = nonLastModule })
					tempModule = nonLastModule
				end
			end

			package.loaded[newModuleName(moduleName, moduleType)] = lastModule

				return lastModule
		else
			return oldRequire(moduleName)
			end
		end
end


-- return new require
return newRequire