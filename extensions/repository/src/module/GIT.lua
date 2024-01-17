local m = {} -- module


local util = require "util"
local fileutil = require "fileutil"
local date = require "date"



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

local function fileHistory (fileName, directoryName)
  fileName = fileutil.quoteCommandlineArgument(fileName)
  directoryName = fileutil.quoteCommandlineArgument(directoryName)

  return string.format([[cd %s && git log --follow -p %s]] .. redirectErrorToOutputStream(), directoryName, fileName)
end

local function fileMergeHistory (fileName, directoryName)
  fileName = fileutil.quoteCommandlineArgument(fileName)
  directoryName = fileutil.quoteCommandlineArgument(directoryName)

  return string.format([[cd %s && git log --merges %s]] .. redirectErrorToOutputStream(), directoryName, fileName)
end

local function addFileHistoryRevisions (command, revisions, fileName)
  local append = true

  local f = assert(io.popen(command, "r"))
  for line in f:lines() do
    local revision = line:match('^commit (.*)')
    if revision then
      revisions[#revisions + 1] = {
        info = line,
        revision = revision
      }

      append = true
      
      -- used when searching for merge commits
      if fileName then
        revisions[#revisions].a = fileName
        revisions[#revisions].b = fileName
      end
    elseif line:match('Date%:   (.*)') then
      revisions[#revisions].date = date(line:match('Date%:   (.*)'))
      revisions[#revisions].info = revisions[#revisions].info .. [[<br>]] .. line
    elseif line:match('^diff %-%-git (.*)') then
      local a, b = line:match('^diff %-%-git a/(.*) b/(.*)')
      revisions[#revisions].a = a
      revisions[#revisions].b = b

      append = false
    elseif append and #revisions > 0 and line ~= "" then
      revisions[#revisions].info = revisions[#revisions].info .. [[<br>]] .. line
    end
  end
  f:close()
end

function m.fileHistory (username, password, fileName, directoryName)
  fileutil.noBackDirectory(fileName)
  fileutil.noBackDirectory(directoryName)

  local x,y = fileName:find(directoryName, 1, true)
  fileName = fileName:sub(y+2, #fileName)


  local fileMergeHistoryCommand = fileMergeHistory(fileName, sourceCtxPath() .. directoryName)
  logCommand(fileMergeHistoryCommand)
  
  local fileHistoryCommand = fileHistory(fileName, sourceCtxPath() .. directoryName)
  logCommand(fileHistoryCommand)

  local revisions = {}

  addFileHistoryRevisions(fileMergeHistoryCommand, revisions, fileName)
  addFileHistoryRevisions(fileHistoryCommand, revisions)

  table.insert(revisions, 1, {
    info = "rLOCAL | working copy",
    revision = "LOCAL",
    a = fileName,
    b = fileName,
    date = date()
  })
  
  table.sort(revisions, function(x,y) return x.date > y.date end)
  
  for i=1,#revisions do
    revisions[i].date = tostring(revisions[i].date)
  end
  
  return revisions
end


--
-- status
--

local function status (directoryName)
  directoryName = fileutil.quoteCommandlineArgument(directoryName)

  return string.format([[cd %s && git status -s .]] .. redirectErrorToOutputStream(), directoryName)
end

local function normalizeFileName (fileName)
  if fileName then
    fileName = string.trim(fileName)
    if fileName and 1 < #fileName and fileName:sub(1, 1) == '"' and fileName:sub(#fileName, #fileName) == '"' then
      fileName = fileName:sub(2, #fileName-1)
    end
  end
  return fileName
end

function m.status (username, password, directoryName)
  fileutil.noBackDirectory(directoryName)

  local command = status(sourceCtxPath() .. directoryName)
  logCommand(command)

  local statuses = {}

  local f = assert(io.popen(command, "r"))
  for line in f:lines() do
    local fileName

    local oldFileName, newFileName = line:match('^%s*%?*%!*%a* (.*) %-%> (.*)')
    if not oldFileName or not newFileName then
      fileName = line:match('^%s*%?*%!*%a* (.*)')
    end

    if not fileName then fileName = oldFileName end

    if fileName then
      statuses[#statuses + 1] = {
        info = line,
        oldRevision = "HEAD",
        newRevision = "LOCAL",
        fileName = normalizeFileName(fileName),
        newFileName = normalizeFileName(newFileName),
      }
    end
  end
  f:close()

  return statuses
end


--
-- logHistory
--

local function logHistory (directoryName, limit)
  directoryName = fileutil.quoteCommandlineArgument(directoryName)

  fileutil.noCommandlineSpecialCharacters(limit)
  
  local pretty = [[--pretty=format:'------------------------------------------------------------------------%n%H %d | %an <%ce> | %cd (%cr)%n%n  %s%n']]

  if limit then
    return string.format([[cd %s && git log --name-status %s -n %s]] .. redirectErrorToOutputStream(), directoryName, pretty, limit)
  else
    return string.format([[cd %s && git log --name-status %s]] .. redirectErrorToOutputStream(), directoryName, pretty)
  end
end

function m.logHistory (username, password, directoryName, limit)
  fileutil.noBackDirectory(directoryName)

  local command = logHistory(sourceCtxPath() .. directoryName, limit)
  logCommand(command)

  local f = assert(io.popen(command, "r"))
  local content = f:read("*all")
  f:close()

  return content
end


--
-- commitHistory
--

local function commitHistory (directoryName, newRevision, oldRevision)
  directoryName = fileutil.quoteCommandlineArgument(directoryName)

  fileutil.noCommandlineSpecialCharacters(newRevision)
  fileutil.noCommandlineSpecialCharacters(oldRevision)

  if util.isNotEmpty(oldRevision) then
    return string.format([[cd %s && git diff %s..%s]] .. redirectErrorToOutputStream(), directoryName, oldRevision, newRevision)
  else
    return string.format([[cd %s && git show %s]] .. redirectErrorToOutputStream(), directoryName, newRevision)
  end
end

function m.commitHistory (username, password, directoryName, newRevision, oldRevision)
  fileutil.noBackDirectory(directoryName)

  local command = commitHistory(sourceCtxPath() .. directoryName, newRevision, oldRevision)
  logCommand(command)

  local f = assert(io.popen(command, "r"))
  local content = f:read("*all")
  f:close()

  return content, "diff --git"
end


--
-- fileRevisionContent
--

local function fileRevisionContent (revision, fileName, directoryName)
  fileName = fileutil.quoteCommandlineArgument(fileName)
  directoryName = fileutil.quoteCommandlineArgument(directoryName)

  fileutil.noCommandlineSpecialCharacters(revision)

  return string.format([[cd %s && git show %s:%s]] .. redirectErrorToOutputStream(), directoryName, revision, fileName)
end

function m.fileRevisionContent (username, password, revision, fileName, directoryName)
  fileutil.noBackDirectory(fileName)

  local command = fileRevisionContent(revision, fileName, sourceCtxPath() .. directoryName)
  logCommand(command)

  local f = assert(io.popen(command, "r"))
  local content = f:read("*all")
  f:close()

  return content
end


--
-- fileDiff
--

local function fileDiff (oldRevision, newRevision, fileName, newFileName, directoryName)
  fileName = fileutil.quoteCommandlineArgument(fileName)
  newFileName = fileutil.quoteCommandlineArgument(newFileName)
  directoryName = fileutil.quoteCommandlineArgument(directoryName)

  fileutil.noCommandlineSpecialCharacters(oldRevision)
  fileutil.noCommandlineSpecialCharacters(newRevision)

  local command
  if newRevision == "LOCAL" then
    command = string.format([[cd %s && git diff %s:%s %s]] .. redirectErrorToOutputStream(), directoryName, oldRevision, fileName, newFileName)
  else
    command = string.format([[cd %s && git diff %s:%s %s:%s]] .. redirectErrorToOutputStream(), directoryName, oldRevision, fileName, newRevision, newFileName)
  end
  return command
end

function m.fileDiff (username, password, oldRevision, newRevision, fileName, newFileName, directoryName)
  fileutil.noBackDirectory(fileName)
  fileutil.noBackDirectory(newFileName)
  fileutil.noBackDirectory(directoryName)

  local command
  if newRevision == "LOCAL" then
    command = fileDiff(oldRevision, newRevision, fileName, sourceCtxPath() .. directoryName .. "/" .. newFileName, sourceCtxPath() .. directoryName)
  else
    command = fileDiff(oldRevision, newRevision, fileName, newFileName, sourceCtxPath() .. directoryName)
  end
  logCommand(command)

  local f = assert(io.popen(command, "r"))
  local content = f:read("*all")
  f:close()

  return content
end


--
-- add
--

local function add (path, directoryName)
  path = fileutil.quoteCommandlineArgument(path)
  directoryName = fileutil.quoteCommandlineArgument(directoryName)

  return string.format([[cd %s && git add -v %s]] .. redirectErrorToOutputStream(), directoryName, path)
end

function m.add (username, password, path, directoryName)
  if util.isNotEmpty(directoryName) then
    fileutil.noBackDirectory(path)
    fileutil.noBackDirectory(directoryName)
  else
    local paths = util.split(path, "/")

    path = paths[#paths]

    paths[#paths] = nil
    directoryName = "/" .. table.concat(paths, "/")

    fileutil.noBackDirectory(path)
    fileutil.noBackDirectory(directoryName)
  end

  local command = add(path, sourceCtxPath() .. directoryName)
  logCommand(command)

  local f = assert(io.popen(command, "r"))
  local content = f:read("*all")
  f:close()

  return content
end


--
-- delete
--

local function delete (path, directoryName)
  path = fileutil.quoteCommandlineArgument(path)
  directoryName = fileutil.quoteCommandlineArgument(directoryName)

  return string.format([[cd %s && git rm --force %s]] .. redirectErrorToOutputStream(), directoryName, path)
end

function m.delete (username, password, path, directoryName)
  if util.isNotEmpty(directoryName) then
    fileutil.noBackDirectory(path)
    fileutil.noBackDirectory(directoryName)
  else
    local paths = util.split(path, "/")

    path = paths[#paths]

    paths[#paths] = nil
    directoryName = "/" .. table.concat(paths, "/")

    fileutil.noBackDirectory(path)
    fileutil.noBackDirectory(directoryName)
  end

  local command = delete(path, sourceCtxPath() .. directoryName)
  logCommand(command)

  local f = assert(io.popen(command, "r"))
  local content = f:read("*all")
  f:close()

  return content
end


--
-- move
--

local function move (oldName, newName, directoryName)
  oldName = fileutil.quoteCommandlineArgument(oldName)
  newName = fileutil.quoteCommandlineArgument(newName)
  directoryName = fileutil.quoteCommandlineArgument(directoryName)

  return string.format([[cd %s && git mv -v --force %s %s]] .. redirectErrorToOutputStream(), directoryName, oldName, newName)
end

function m.move (username, password, oldName, newName, directoryName)
  fileutil.noBackDirectory(oldName)
  fileutil.countBackDirectories(newName) -- only here is allowed to have back directory
  fileutil.noBackDirectory(directoryName)

  local command = move(sourceCtxPath() .. oldName, sourceCtxPath() .. newName, sourceCtxPath() .. directoryName)
  logCommand(command)

  local f = assert(io.popen(command, "r"))
  local content = f:read("*all")
  f:close()

  return content
end


--
-- commit
--

local function commit (message, list, directoryName)
  message = fileutil.quoteCommandlineArgument(message)
  directoryName = fileutil.quoteCommandlineArgument(directoryName)

  local paths = ""
  for i=1, #list do
    fileutil.noBackDirectory(list[i])

    local path = fileutil.quoteCommandlineArgument(list[i])
    paths = paths .. " " .. path
  end

  return string.format([[cd %s && git commit -m %s %s]] .. redirectErrorToOutputStream(), directoryName, message, paths)
end

function m.commit (username, password, message, list, directoryName)
  fileutil.noBackDirectory(directoryName)

  local command = commit(message, list, sourceCtxPath() .. directoryName)
  logCommand(command)

  local f = assert(io.popen(command, "r"))
  local content = f:read("*all")
  f:close()

  return content
end


--
-- update
--




--
-- revert / reset -- 
--

local function revert (path, recursively, directoryName)
  path = fileutil.quoteCommandlineArgument(path)
  directoryName = fileutil.quoteCommandlineArgument(directoryName)

  fileutil.noCommandlineSpecialCharacters(recursively)

  if recursively then
    return string.format([[cd %s && git reset --hard HEAD]] .. redirectErrorToOutputStream(), directoryName)
  else
    return string.format([[cd %s && git checkout HEAD -- %s]] .. redirectErrorToOutputStream(), directoryName, path)
  end
end

function m.revert (username, password, path, recursively, directoryName)
  fileutil.noBackDirectory(path)
  fileutil.noBackDirectory(directoryName)

  local command = revert(path, recursively, sourceCtxPath() .. directoryName)
  logCommand(command)

  local f = assert(io.popen(command, "r"))
  local content = f:read("*all")
  f:close()

  return content
end


--
-- merge
--




--
-- refresh / clean
--

local function refreshDir (directoryName)
  directoryName = fileutil.quoteCommandlineArgument(directoryName)

  return string.format([[cd %s && git clean -df]] .. redirectErrorToOutputStream(), directoryName)
end

local function refreshPath (path, directoryName)
  path = fileutil.quoteCommandlineArgument(path)
  directoryName = fileutil.quoteCommandlineArgument(directoryName)

  return string.format([[cd %s && git clean -df %s]] .. redirectErrorToOutputStream(), directoryName, path)
end

function m.refresh (username, password, path, directoryName)
  fileutil.noBackDirectory(path)
  fileutil.noBackDirectory(directoryName)

  local command
  if path == directoryName then
    command = refreshDir(sourceCtxPath() .. directoryName)
  else
    command = refreshPath(path, sourceCtxPath() .. directoryName)
  end
  logCommand(command)

  local f = assert(io.popen(command, "r"))
  local content = f:read("*all")
  f:close()

  return content
end



return m -- return module