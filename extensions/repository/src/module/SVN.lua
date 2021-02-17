local m = {} -- module


local fileutil = require "fileutil"


local SVN = "svn "
local svn = SVN .. "--username %s --password %s --no-auth-cache --non-interactive "



--
-- sourceCtxPath
--

local function sourceCtxPath ()
	local property = require "property"
	return property.sourceCtxPath or ""
end


--
-- redirectErrorToOutputStream
--

local function redirectErrorToOutputStream ()
	local property = require "property"
	return property.redirectErrorToOutputStream or ""
end


--
-- logCommand
--

local function logCommand (command)
	local property = require "property"
	if property.debugRepo then
		ngx.log(ngx.ERR, command) -- DEBUG
	end
end


--
-- fileHistory
--

local function fileHistory (username, password, fileName)
	username = fileutil.quoteCommandlineArgument(username)
	password = fileutil.quoteCommandlineArgument(password)
	fileName = fileutil.quoteCommandlineArgument(fileName)

	return string.format(svn .. [[log -v %s]] .. redirectErrorToOutputStream(), username, password, fileName)
end

function m.fileHistory (username, password, fileName)
	fileutil.noBackDirectory(fileName)

	local command = fileHistory(username, password, sourceCtxPath() .. fileName)
	logCommand(command)

	local revisions = {}

	local f = assert(io.popen(command, "r"))
	for line in f:lines() do
		local revision = line:match('^r(%d+)%s+')
		if revision then
			revisions[#revisions + 1] = {
				info = line,
				revision = revision
			}
		elseif #revisions > 0 and not line:find("----------", 1, true) and line ~= "" then
			revisions[#revisions].info = revisions[#revisions].info .. [[<br>]] .. line
		end
	end
	f:close()

	table.insert(revisions, 1, {
		info = "rHEAD | base copy",
		revision = "HEAD"
	})
	table.insert(revisions, 1, {
		info = "rLOCAL | working copy",
		revision = "LOCAL"
	})

	return revisions
end


--
-- status
--

local function status (username, password, directoryName)
	username = fileutil.quoteCommandlineArgument(username)
	password = fileutil.quoteCommandlineArgument(password)
	directoryName = fileutil.quoteCommandlineArgument(directoryName)

	return string.format(svn .. [[status -u %s]] .. redirectErrorToOutputStream(), username, password, directoryName)
end

function m.status (username, password, directoryName)
	fileutil.noBackDirectory(directoryName)

	local command = status(username, password, sourceCtxPath() .. directoryName)
	logCommand(command)

	local statuses = {}

	local f = assert(io.popen(command, "r"))
	for line in f:lines() do
		local fileName = line:match('(%a?:?[/\\].*)')
		if fileName then
			local newFileName
			local i, j = fileName:find(sourceCtxPath(), 1, true)
			if i and (i <= j) then
				newFileName = fileName:sub(j + 1, #fileName)
			else
				newFileName = fileName
			end

			local revertRevisions = false
			local newLine
			local i = line:find(fileName, 1, true)
			if i then
				local fileStatus = line:sub(1, i - 1)
				newLine = fileStatus .. newFileName

				if fileStatus:find("*", 1, true) then revertRevisions = true end
			else
				newLine = line
			end

			statuses[#statuses + 1] = {
				info = newLine,
				oldRevision = "HEAD",
				newRevision = "LOCAL",
				fileName = newFileName,
				revertRevisions = revertRevisions
			}
		end
	end
	f:close()

	return statuses
end


--
-- logHistory
--

local function logHistory (username, password, directoryName, limit)
	username = fileutil.quoteCommandlineArgument(username)
	password = fileutil.quoteCommandlineArgument(password)
	directoryName = fileutil.quoteCommandlineArgument(directoryName)

	fileutil.noCommandlineSpecialCharacters(limit)

	if limit then
		return string.format(svn .. [[log -v -l %s %s]] .. redirectErrorToOutputStream(), 
			username, password, limit, directoryName)
	else
		return string.format(svn .. [[log -v %s]] .. redirectErrorToOutputStream(), 
			username, password, directoryName)
	end
end

function m.logHistory (username, password, directoryName, limit)
	fileutil.noBackDirectory(directoryName)

	local command = logHistory(username, password, sourceCtxPath() .. directoryName, limit)
	logCommand(command)

	local f = assert(io.popen(command, "r"))
	local content = f:read("*all")
	f:close()

	return content
end


--
-- commitHistory
--

local function commitHistory (username, password, directoryName, newRevision, oldRevision)
	username = fileutil.quoteCommandlineArgument(username)
	password = fileutil.quoteCommandlineArgument(password)
	directoryName = fileutil.quoteCommandlineArgument(directoryName)

	fileutil.noCommandlineSpecialCharacters(newRevision)
	fileutil.noCommandlineSpecialCharacters(oldRevision)

	return string.format(svn .. [[diff -r %s:%s %s]] .. redirectErrorToOutputStream(), 
		username, password, oldRevision, newRevision, directoryName)
end

function m.commitHistory (username, password, directoryName, newRevision, oldRevision)
	fileutil.noBackDirectory(directoryName)

	local command = commitHistory(username, password, sourceCtxPath() .. directoryName, newRevision, oldRevision)
	logCommand(command)

	local f = assert(io.popen(command, "r"))
	local content = f:read("*all")
	f:close()

	return content, "Index: "
end


--
-- fileRevisionContent
--

local function fileRevisionContent (username, password, revision, fileName)
	username = fileutil.quoteCommandlineArgument(username)
	password = fileutil.quoteCommandlineArgument(password)
	fileName = fileutil.quoteCommandlineArgument(fileName)

	fileutil.noCommandlineSpecialCharacters(revision)

	return string.format(svn .. [[cat -r %s %s]] .. redirectErrorToOutputStream(), username, password, revision, fileName)
end

function m.fileRevisionContent (username, password, revision, fileName)
	fileutil.noBackDirectory(fileName)

	local command = fileRevisionContent(username, password, revision, sourceCtxPath() .. fileName)
	logCommand(command)

	local f = assert(io.popen(command, "r"))
	local content = f:read("*all")
	f:close()

	return content
end


--
-- fileDiff
--

local function fileDiff (username, password, oldRevision, newRevision, fileName)
	username = fileutil.quoteCommandlineArgument(username)
	password = fileutil.quoteCommandlineArgument(password)
	fileName = fileutil.quoteCommandlineArgument(fileName)

	fileutil.noCommandlineSpecialCharacters(oldRevision)
	fileutil.noCommandlineSpecialCharacters(newRevision)

	local command = string.format(svn .. [[diff -r %s:%s %s]] .. redirectErrorToOutputStream(), 
		username, password, oldRevision, newRevision, fileName)
	if newRevision == "LOCAL" then
		command = string.format(svn .. [[diff -r %s %s]] .. redirectErrorToOutputStream(), 
			username, password, oldRevision, fileName)
	end
	return command
end

function m.fileDiff (username, password, oldRevision, newRevision, fileName)
	fileutil.noBackDirectory(fileName)

	local command = fileDiff(username, password, oldRevision, newRevision, sourceCtxPath() .. fileName)
	logCommand(command)

	local f = assert(io.popen(command, "r"))
	local content = f:read("*all")
	f:close()

	return content
end


--
-- add
--

local function add (username, password, path)
	username = fileutil.quoteCommandlineArgument(username)
	password = fileutil.quoteCommandlineArgument(password)
	path = fileutil.quoteCommandlineArgument(path)

	return string.format(SVN .. [[add --force %s]] .. redirectErrorToOutputStream(), path)
end

function m.add (username, password, path)
	fileutil.noBackDirectory(path)

	local command = add(username, password, sourceCtxPath() .. path)
	logCommand(command)

	local f = assert(io.popen(command, "r"))
	local content = f:read("*all")
	f:close()

	return content
end


--
-- delete
--

local function delete (username, password, path)
	username = fileutil.quoteCommandlineArgument(username)
	password = fileutil.quoteCommandlineArgument(password)
	path = fileutil.quoteCommandlineArgument(path)

	return string.format(svn .. [[delete --force %s]] .. redirectErrorToOutputStream(), username, password, path)
end

function m.delete (username, password, path)
	fileutil.noBackDirectory(path)

	local command = delete(username, password, sourceCtxPath() .. path)
	logCommand(command)

	local f = assert(io.popen(command, "r"))
	local content = f:read("*all")
	f:close()

	return content
end


--
-- move
--

local function move (username, password, oldName, newName)
	username = fileutil.quoteCommandlineArgument(username)
	password = fileutil.quoteCommandlineArgument(password)
	oldName = fileutil.quoteCommandlineArgument(oldName)
	newName = fileutil.quoteCommandlineArgument(newName)

	return string.format(svn .. [[move --force %s %s]] .. redirectErrorToOutputStream(), username, password, oldName, newName)
end

function m.move (username, password, oldName, newName)
	fileutil.noBackDirectory(oldName)
	fileutil.countBackDirectories(newName) -- only here is allowed to have back directory

	local command = move(username, password, sourceCtxPath() .. oldName, sourceCtxPath() .. newName)
	logCommand(command)

	local f = assert(io.popen(command, "r"))
	local content = f:read("*all")
	f:close()

	return content
end


--
-- commit
--

local function commit (username, password, message, list)
	username = fileutil.quoteCommandlineArgument(username)
	password = fileutil.quoteCommandlineArgument(password)
	message = fileutil.quoteCommandlineArgument(message)

	local paths = ""
	for i=1, #list do
		fileutil.noBackDirectory(list[i])

		local path = fileutil.quoteCommandlineArgument(sourceCtxPath() .. list[i])
		paths = paths .. " " .. path
	end

	return string.format(svn .. [[commit -m %s %s]] .. redirectErrorToOutputStream(), 
		username, password, message, paths)
end

function m.commit (username, password, message, list)
	local command = commit(username, password, message, list)
	logCommand(command)

	local f = assert(io.popen(command, "r"))
	local content = f:read("*all")
	f:close()

	return content
end


--
-- update
--

local function update (username, password, revision, path)
	username = fileutil.quoteCommandlineArgument(username)
	password = fileutil.quoteCommandlineArgument(password)
	path = fileutil.quoteCommandlineArgument(path)

	fileutil.noCommandlineSpecialCharacters(revision)

	if revision then
		return string.format(svn .. [[update -r%s %s]] .. redirectErrorToOutputStream(), 
			username, password, revision, path)
	else
		return string.format(svn .. [[update %s]] .. redirectErrorToOutputStream(), 
			username, password, path)
	end
end

function m.update (username, password, revision, path)
	fileutil.noBackDirectory(path)

	local command = update(username, password, revision, sourceCtxPath() .. path)
	logCommand(command)

	local f = assert(io.popen(command, "r"))
	local content = f:read("*all")
	f:close()

	return content
end


--
-- revert
--

local function revert (username, password, path, recursively)
	username = fileutil.quoteCommandlineArgument(username)
	password = fileutil.quoteCommandlineArgument(password)
	path = fileutil.quoteCommandlineArgument(path)

	fileutil.noCommandlineSpecialCharacters(recursively)

	if recursively then
		return string.format(SVN .. [[revert -R %s]] .. redirectErrorToOutputStream(), path)
	else
		return string.format(SVN .. [[revert %s]] .. redirectErrorToOutputStream(), path)
	end
end

function m.revert (username, password, path, recursively)
	fileutil.noBackDirectory(path)

	local command = revert(username, password, sourceCtxPath() .. path, recursively)
	logCommand(command)

	local f = assert(io.popen(command, "r"))
	local content = f:read("*all")
	f:close()

	return content
end


--
-- merge
--

local function merge (username, password, fromRevision, toRevision, path)
	username = fileutil.quoteCommandlineArgument(username)
	password = fileutil.quoteCommandlineArgument(password)
	path = fileutil.quoteCommandlineArgument(path)

	fileutil.noCommandlineSpecialCharacters(fromRevision)
	fileutil.noCommandlineSpecialCharacters(toRevision)

	return string.format([[cd %s && ]] .. svn .. [[merge -r %s:%s .]] .. redirectErrorToOutputStream(), 
		path, username, password, fromRevision, toRevision)
end

function m.merge (username, password, fromRevision, toRevision, path)
	fileutil.noBackDirectory(path)

	local command = merge(username, password, fromRevision, toRevision, sourceCtxPath() .. path)
	logCommand(command)

	local f = assert(io.popen(command, "r"))
	local content = f:read("*all")
	f:close()

	return content
end


--
-- refresh
--

local function refresh (username, password, path)
	username = fileutil.quoteCommandlineArgument(username)
	password = fileutil.quoteCommandlineArgument(password)
	path = fileutil.quoteCommandlineArgument(path)

	return string.format(SVN .. [[cleanup %s]] .. redirectErrorToOutputStream(), path)
end

function m.refresh (username, password, path)
	fileutil.noBackDirectory(path)

	local command = refresh(username, password, sourceCtxPath() .. path)
	logCommand(command)

	local f = assert(io.popen(command, "r"))
	local content = f:read("*all")
	f:close()

	return content
end



return m -- return module