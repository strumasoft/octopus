local exception = require "exception"
local eval = require "eval"
local parse = require "parse"


package.loaded.TEMPLATES = {}
local function configuration (templateName)
	local TEMPLATES = package.loaded.TEMPLATES
	local octopusHostDir = ngx.var.octopusHostDir

	if TEMPLATES[octopusHostDir] then
		return TEMPLATES[octopusHostDir][templateName]
	else
		local templatesConfig = dofile(octopusHostDir .. "/build/src/html.lua")
		TEMPLATES[octopusHostDir] = templatesConfig
		return templatesConfig[templateName]
	end
end


package.loaded.TEMPLATES_CACHE = {}
local template = {}
setmetatable(template, {
	__index = function (t, templateName)
		local CACHE = package.loaded.TEMPLATES_CACHE
		local key = ngx.var.octopusHostDir .. ":" .. templateName
		
		local cached = CACHE[key]
		if cached then
			local view = cached
			return function (context) return parse(view, context) end
		end
		
		local scripts = configuration(templateName)
		if scripts then
			local view = eval.file(scripts[#scripts], {})
			CACHE[key] = view
			return function (context) return parse(view, context) end
		end
		
		exception("html template " .. templateName .. " does not exists")
	end
})

return template