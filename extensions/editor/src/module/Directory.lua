local m = {} -- module


local lfs = require "lfs"
local fileutil = require "fileutil"
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

	fileutil.noBackDirectory(dir)

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


function m.sortedEntries(dir)
	-- get map of dir entries and their attributes --
	local map = m.entries(dir)

	-- sort dir and file entries --
	local sortedEntries, dirEntries, fileEntries = {}, {}, {}
	for entry, attr in pairs(map) do 
		if attr.mode == "directory" then
			dirEntries[#dirEntries + 1] = entry
		else
			fileEntries[#fileEntries + 1] = entry
		end
	end
	table.sort(dirEntries)
	for i=1,#dirEntries do sortedEntries[#sortedEntries + 1] = dirEntries[i] end
	table.sort(fileEntries)
	for i=1,#fileEntries do sortedEntries[#sortedEntries + 1] = fileEntries[i] end

	-- wrap evrything up --
	local dirs = {}
	for i=1,#sortedEntries do
		local entry = sortedEntries[i]
		local attr = map[entry]
		dirs[#dirs + 1] = {path = attr.path, name = entry, mode = attr.mode}
	end
	
	return dirs
end


return m -- return module