local exception = require "exception"
local eval = require "eval"
local parse = require "parse"
local html = require "html"


local cache = {}
local template = {}

setmetatable(template, {
	__index = function (t, key)
		if cache[key] then
			local view = cache[key]
			return function (context) return parse(view, context) end
		end
		
		if html[key] then
			local fileNames = html[key]
			local view = eval.file(fileNames[#fileNames], {})
			cache[key] = view
			return function (context) return parse(view, context) end
		end
		
		exception("html template " .. key .. " does not exists")
	end
})

return template