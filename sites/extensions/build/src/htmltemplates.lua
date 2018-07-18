-- Persistent Data
local multiRefObjects = {

} -- multiRefObjects
local obj1 = {
}
	
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
		if false then
			return template.parsetemplate(view, context, key)
		else
			return template.parsetemplate(view, context, "no-cache")
		end
	end
end

	
return obj1
