-- save old require
local oldRequire = require


local function name (moduleName)
	if moduleName:find("resty.", 1, true) or moduleName:find("ngx.", 1, true) then 
		return moduleName
	end

	local octopusHostDir = ngx.var.octopusHostDir
	return octopusHostDir .. ":" .. moduleName
end


package.loaded.MODULES = {}
local function loadModules ()
	local octopusHostDir = ngx.var.octopusHostDir
	local MODULES = package.loaded.MODULES

	if MODULES[octopusHostDir] then
		return MODULES[octopusHostDir]
	else
		local modules = dofile(octopusHostDir .. "/build/src/module.lua")
		MODULES[octopusHostDir] = modules
		return modules
	end
end


local function newRequire (moduleName, newModuleValue)
	if not moduleName then return nil end

	if newModuleValue then
		package.loaded[name(moduleName)] = newModuleValue
		return newModuleValue
	end
	
	if package.loaded[name(moduleName)] then
		return package.loaded[name(moduleName)] 
	end

	local modules = loadModules()
	if modules[moduleName] then
		local lastModule, tempModule
		local scripts = modules[moduleName]
		for i=#scripts, 2, -1 do -- first script holds metadata
			local scriptModule = dofile(scripts[i])

			if i == #scripts then
				lastModule = scriptModule
				tempModule = lastModule
			else
				local nonLastModule = scriptModule
				local mt = getmetatable(tempModule) or {}
				mt.__index = nonLastModule
				setmetatable(tempModule, mt)
				tempModule = nonLastModule
			end
		end
		package.loaded[name(moduleName)] = lastModule
		return lastModule
	else
		return oldRequire(moduleName)
	end
end


-- return new require
return newRequire