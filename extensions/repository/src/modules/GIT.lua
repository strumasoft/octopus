local m = {} -- module


local param = require "param"
local util = require "util"


local property = require "property"
local sourceCtxPath = property.sourceCtxPath or ""



--
-- fileHistory
--

local function fileHistory (fileName, directoryName)
    fileName = util.quoteCommandlineArgument(fileName)
    directoryName = util.quoteCommandlineArgument(directoryName)
    
    return string.format([[cd %s && git log --follow -p %s]] .. property.redirectErrorToOutputStream, directoryName, fileName)
end

function m.fileHistory (username, password, fileName, directoryName)
    util.noBackDirectory(fileName)
    util.noBackDirectory(directoryName)
    
    local x,y = fileName:find(directoryName, 1, true)
    fileName = fileName:sub(y+2, #fileName)
    
    
    local command = fileHistory(fileName, sourceCtxPath .. directoryName)
    
    local revisions = {}
    
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
    
    table.insert(revisions, 1, {
        info = "rLOCAL | working copy",
        revision = "LOCAL",
        a = fileName,
        b = fileName
    })

    return revisions
end


--
-- status
--

local function status (directoryName)
    directoryName = util.quoteCommandlineArgument(directoryName)
    
    return string.format([[cd %s && git status -s .]] .. property.redirectErrorToOutputStream, directoryName)
end

function m.status (username, password, directoryName)
    util.noBackDirectory(directoryName)
    
    local command = status(sourceCtxPath .. directoryName)
    
    local statuses = {}
    
    local f = assert(io.popen(command, "r"))
    for line in f:lines() do
        local fileName
        
        local oldFileName, newFileName = line:match('^.* (.*) %-%> (.*)')
        if not oldFileName or not newFileName then
            fileName = line:match('^.* (.*)')
        end
        
        if not fileName then fileName = oldFileName end

        if fileName then
            statuses[#statuses + 1] = {
                info = line,
                oldRevision = "HEAD",
                newRevision = "LOCAL",
                fileName = fileName,
                newFileName = newFileName,
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
    directoryName = util.quoteCommandlineArgument(directoryName)
    
    util.noCommandlineSpecialCharacters(limit)
    
    if limit then
        return string.format([[cd %s && git log --name-status --decorate --graph --all -n %s]] .. property.redirectErrorToOutputStream, directoryName, limit)
    else
        return string.format([[cd %s && git log --name-status --decorate --graph --all]] .. property.redirectErrorToOutputStream, directoryName)
    end
end

function m.logHistory (username, password, directoryName, limit)
    util.noBackDirectory(directoryName)
    
    local command = logHistory(sourceCtxPath .. directoryName, limit)
    
    local f = assert(io.popen(command, "r"))
    local content = f:read("*all")
    f:close()
    
    return content
end


--
-- commitHistory
--

local function commitHistory (directoryName, commit)
    directoryName = util.quoteCommandlineArgument(directoryName)
    
    util.noCommandlineSpecialCharacters(commit)
    
    return string.format([[cd %s && git show %s]] .. property.redirectErrorToOutputStream, directoryName, commit)
end

function m.commitHistory (username, password, directoryName, newRevision, oldRevision)
    util.noBackDirectory(directoryName)
    
    local command = commitHistory(sourceCtxPath .. directoryName, newRevision)

    local f = assert(io.popen(command, "r"))
    local content = f:read("*all")
    f:close()
    
    return content, "diff --git"
end


--
-- fileRevisionContent
--

local function fileRevisionContent (revision, fileName, directoryName)
    fileName = util.quoteCommandlineArgument(fileName)
    directoryName = util.quoteCommandlineArgument(directoryName)
    
    util.noCommandlineSpecialCharacters(revision)
    
    return string.format([[cd %s && git show %s:%s]] .. property.redirectErrorToOutputStream, directoryName, revision, fileName)
end

function m.fileRevisionContent (username, password, revision, fileName, directoryName)
    util.noBackDirectory(fileName)
    
    local command = fileRevisionContent(revision, fileName, sourceCtxPath .. directoryName)
    
    local f = assert(io.popen(command, "r"))
    local content = f:read("*all")
    f:close()
    
    return content
end


--
-- fileDiff
--

local function fileDiff (oldRevision, newRevision, fileName, newFileName, directoryName)
    fileName = util.quoteCommandlineArgument(fileName)
    newFileName = util.quoteCommandlineArgument(newFileName)
    directoryName = util.quoteCommandlineArgument(directoryName)
    
    util.noCommandlineSpecialCharacters(oldRevision)
    util.noCommandlineSpecialCharacters(newRevision)
    
    local command
    if newRevision == "LOCAL" then
        command = string.format([[cd %s && git diff %s:%s %s]] .. property.redirectErrorToOutputStream, directoryName, oldRevision, fileName, newFileName)
    else
        command = string.format([[cd %s && git diff %s:%s %s:%s]] .. property.redirectErrorToOutputStream, directoryName, oldRevision, fileName, newRevision, newFileName)
    end
    return command
end

function m.fileDiff (username, password, oldRevision, newRevision, fileName, newFileName, directoryName)
    util.noBackDirectory(fileName)
    util.noBackDirectory(newFileName)
    util.noBackDirectory(directoryName)
    
    local command
    if newRevision == "LOCAL" then
        command = fileDiff(oldRevision, newRevision, fileName, sourceCtxPath .. directoryName .. "/" .. newFileName, sourceCtxPath .. directoryName)
    else
        command = fileDiff(oldRevision, newRevision, fileName, newFileName, sourceCtxPath .. directoryName)
    end
    
    local f = assert(io.popen(command, "r"))
    local content = f:read("*all")
    f:close()
    
    return content
end


--
-- add
--

local function add (path, directoryName)
    path = util.quoteCommandlineArgument(path)
    directoryName = util.quoteCommandlineArgument(directoryName)
    
    return string.format([[cd %s && git add -v %s]] .. property.redirectErrorToOutputStream, directoryName, path)
end

function m.add (username, password, path, directoryName)
    if param.isNotEmpty(directoryName) then
        util.noBackDirectory(path)
        util.noBackDirectory(directoryName)
    else
        local paths = param.split(path, "/")
    
        path = paths[#paths]
        
        paths[#paths] = nil
        directoryName = table.concat(paths, "/")
        
        util.noBackDirectory(path)
        util.noBackDirectory(directoryName)
    end
    
    local command = add(path, sourceCtxPath .. directoryName)
    
    local f = assert(io.popen(command, "r"))
    local content = f:read("*all")
    f:close()
    
    return content
end


--
-- delete
--

local function delete (path, directoryName)
    path = util.quoteCommandlineArgument(path)
    directoryName = util.quoteCommandlineArgument(directoryName)
    
    return string.format([[cd %s && git rm --force %s]] .. property.redirectErrorToOutputStream, directoryName, path)
end

function m.delete (username, password, path, directoryName)
    if param.isNotEmpty(directoryName) then
        util.noBackDirectory(path)
        util.noBackDirectory(directoryName)
    else
        local paths = param.split(path, "/")
    
        path = paths[#paths]
        
        paths[#paths] = nil
        directoryName = table.concat(paths, "/")
        
        util.noBackDirectory(path)
        util.noBackDirectory(directoryName)
    end
    
    local command = delete(path, sourceCtxPath .. directoryName)
    
    local f = assert(io.popen(command, "r"))
    local content = f:read("*all")
    f:close()
    
    return content
end


--
-- move
--

local function move (oldName, newName, directoryName)
    oldName = util.quoteCommandlineArgument(oldName)
    newName = util.quoteCommandlineArgument(newName)
    directoryName = util.quoteCommandlineArgument(directoryName)
    
    return string.format([[cd %s && git mv -v --force %s %s]] .. property.redirectErrorToOutputStream, directoryName, oldName, newName)
end

function m.move (username, password, oldName, newName, directoryName)
    util.noBackDirectory(oldName)
    util.countBackDirectories(newName) -- only here is allowed to have back directory
    util.noBackDirectory(directoryName)
    
    local command = move(sourceCtxPath .. oldName, sourceCtxPath .. newName, sourceCtxPath .. directoryName)
    
    local f = assert(io.popen(command, "r"))
    local content = f:read("*all")
    f:close()
    
    return content
end


--
-- commit
--

local function commit (message, list, directoryName)
    message = util.quoteCommandlineArgument(message)
    directoryName = util.quoteCommandlineArgument(directoryName)
    
    local paths = ""
    for i=1, #list do
        util.noBackDirectory(list[i])
        
        local path = util.quoteCommandlineArgument(list[i])
        paths = paths .. " " .. path
    end

    return string.format([[cd %s && git commit -m %s %s]] .. property.redirectErrorToOutputStream, directoryName, message, paths)
end

function m.commit (username, password, message, list, directoryName)
    util.noBackDirectory(directoryName)
    
    local command = commit(message, list, sourceCtxPath .. directoryName)
    
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
    path = util.quoteCommandlineArgument(path)
    directoryName = util.quoteCommandlineArgument(directoryName)
    
    util.noCommandlineSpecialCharacters(recursively)
    
    if recursively then
        return string.format([[cd %s && git reset --hard HEAD]] .. property.redirectErrorToOutputStream, directoryName)
    else
        return string.format([[cd %s && git checkout HEAD -- %s]] .. property.redirectErrorToOutputStream, directoryName, path)
    end
end

function m.revert (username, password, path, recursively, directoryName)
    util.noBackDirectory(path)
    util.noBackDirectory(directoryName)
    
    local command = revert(path, recursively, sourceCtxPath .. directoryName)
    
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
    directoryName = util.quoteCommandlineArgument(directoryName)
    
    return string.format([[cd %s && git clean -df]] .. property.redirectErrorToOutputStream, directoryName)
end

local function refreshPath (path, directoryName)
    path = util.quoteCommandlineArgument(path)
    directoryName = util.quoteCommandlineArgument(directoryName)
    
    return string.format([[cd %s && git clean -df %s]] .. property.redirectErrorToOutputStream, directoryName, path)
end

function m.refresh (username, password, path, directoryName)
    util.noBackDirectory(path)
    util.noBackDirectory(directoryName)
    
    local command
    if path == directoryName then
        command = refreshDir(sourceCtxPath .. directoryName)
    else
        command = refreshPath(path, sourceCtxPath .. directoryName)
    end
    
    local f = assert(io.popen(command, "r"))
    local content = f:read("*all")
    f:close()
    
    return content
end



return m -- return module