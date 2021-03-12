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
		
		local key
		if templateName:find("global.", 1, true) then
			key = templateName
		else
			key = ngx.var.octopusHostDir .. ":" .. templateName
		end
		
		local cached = CACHE[key]
		if cached then
			local view = cached
			return function (context, arguments) return parse(view, context, arguments) end
		end
		
		local scripts = configuration(templateName)
		if scripts then
			local view = eval.file(scripts[#scripts], {})
			CACHE[key] = view
			return function (context, arguments) return parse(view, context, arguments) end
		end
		
		exception("html template " .. templateName .. " does not exists")
	end
})

return template