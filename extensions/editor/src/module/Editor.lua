local m = {} -- module


local lfs = require "lfs"
local exception = require "exception"
local fileutil = require "fileutil"


--
-- sourceCtxPath
--

local function sourceCtxPath ()
	local property = require "property"
	return property.sourceCtxPath or ""
end


--
-- createFile
--

function m.createFile (fileName)
	if fileName then
		fileutil.noBackDirectory(fileName)

		local file, err = io.open(sourceCtxPath() .. fileName, "w")

		if file == nil then
			exception(err)
		end

		file:write("")
		file:close()
	else
		exception("fileName is empty")
	end
end


--
-- createDirectory
--

function m.createDirectory (directoryName)
	if directoryName then
		fileutil.noBackDirectory(directoryName)

		local ok, err = lfs.mkdir(sourceCtxPath() .. directoryName)

		if not ok then
			exception(err)
		end
	else
		exception("directoryName is empty")
	end
end


--
-- rename
--

function m.rename (oldName, newName)
	if oldName and newName then
		fileutil.noBackDirectory(oldName)
		fileutil.countBackDirectories(newName)

		local ok, err = os.rename(sourceCtxPath() .. oldName, sourceCtxPath() .. newName)

		if not ok then
			exception(err)
		end
	else
		exception("oldName/newName is empty")
	end
end


--
-- remove
--

function m.remove (path)
	if path then
		fileutil.noBackDirectory(path)

		fileutil.remove(sourceCtxPath() .. path)
	else
		exception("path is empty")
	end
end


--
-- save
--

function m.save (fileName, content)
	if fileName then
		fileutil.noBackDirectory(fileName)

		local file, err = io.open(sourceCtxPath() .. fileName, "w")

		if file == nil then
			exception(err)
		end

		if content then
			file:write(content)
		else
			file:write("")
		end

		file:close()
	else
		exception("fileName is empty")
	end
end


--
-- fileContent
--

function m.fileContent (fileName)
	if fileName then
		fileutil.noBackDirectory(fileName)

		local file, err = io.open(sourceCtxPath() .. fileName, "r")

		if file == nil then
			exception(err)
		end

		local content = file:read("*all")
		file:close()

		return content
	else
		exception("fileName is empty")
	end
end


return m -- return module