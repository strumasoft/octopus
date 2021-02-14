-- save old require
local oldRequire = require


package.loaded.MODULES = {}
local function configuration (moduleName)
	local octopusHostDir = ngx.var.octopusHostDir
	local MODULES = package.loaded.MODULES

	if MODULES[octopusHostDir] then
		return MODULES[octopusHostDir][moduleName]
	else
		local modulesConfig = dofile(octopusHostDir .. "/build/src/module.lua")
		MODULES[octopusHostDir] = modulesConfig
		return modulesConfig[moduleName]
	end
end


local function newRequire (moduleName)
	if not moduleName then return nil end
	
	local scripts = configuration(moduleName)
	if scripts then
		local newModuleName = "octopus." .. moduleName
		local cached = package.loaded[newModuleName]
		if cached then return cached end
		
		local lastModule, tempModule
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
		
		package.loaded[newModuleName] = lastModule
		return lastModule
	end
	
	return oldRequire(moduleName)
end


-- return new require
return newRequire