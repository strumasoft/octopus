local m = {} -- module


local lfs = require "lfs"
local util = require "util"


local property = require "property"
local sourceCtxPath = property.sourceCtxPath or ""


function m.entries(dir)
	assert(dir and dir ~= "", "directory parameter is missing or empty")
	
	-- remove slash at the end of directory unless root is specified
	if dir ~= "/" then
		if string.sub(dir, -1) == "/" then
			dir = string.sub(dir, 1, -2) 
		end
	end
	
	util.noBackDirectory(dir)
	
	-- collect all entries in map with attributes
	local map = {}
	for entry in lfs.dir(sourceCtxPath .. dir) do
		if entry ~= "." and entry ~= ".." then
			local path
			if dir ~= "/" then 
				path = dir .. "/" .. entry
			else
				path = "/" .. entry
			end
			
			local attr = lfs.attributes(sourceCtxPath .. path)
			if attr then
			    attr.path = path
			    map[entry] = attr
			else
			    map[entry] = {path = path, mode = "unknown"}
			end
		end
	end

	return map
end


return m -- return module