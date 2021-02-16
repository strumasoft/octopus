local exception = require "exception"
local eval = require "eval"
local parse = require "parse"


package.loaded.TEMPLATES = {}
local function configuration (templateName)
	local octopusHostDir = ngx.var.octopusHostDir
	local TEMPLATES = package.loaded.TEMPLATES

	if TEMPLATES[octopusHostDir] then
		return TEMPLATES[octopusHostDir][templateName]
	else
		local templatesConfig = dofile(octopusHostDir .. "/build/src/html.lua")
		TEMPLATES[octopusHostDir] = templatesConfig
		return templatesConfig[templateName]
	end
end

local cache = {}
local template = {}

setmetatable(template, {
	__index = function (t, templateName)
		local octopusHostDir = ngx.var.octopusHostDir
		if cache[octopusHostDir .. ":" .. templateName] then
			local view = cache[octopusHostDir .. ":" .. templateName]
			return function (context) return parse(view, context) end
		end
		
		local scripts = configuration(templateName)
		if scripts then
			local view = eval.file(scripts[#scripts], {})
			cache[octopusHostDir .. ":" .. templateName] = view
			return function (context) return parse(view, context) end
		end
		
		exception("html template " .. templateName .. " does not exists")
	end
})

return template