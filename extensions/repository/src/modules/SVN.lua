local m = {} -- module


local util = require "util"


local property = require "property"
local sourceCtxPath = property.sourceCtxPath or ""


local SVN = "svn "
local svn = SVN .. "--username %s --password %s --no-auth-cache --non-interactive "


--
-- fileHistory
--

local function fileHistory (username, password, fileName)
    username = util.quoteCommandlineArgument(username)
    password = util.quoteCommandlineArgument(password)
    fileName = util.quoteCommandlineArgument(fileName)
    
    return string.format(svn .. [[log -v %s]] .. property.redirectErrorToOutputStream, username, password, fileName)
end

function m.fileHistory (username, password, fileName)
    util.noBackDirectory(fileName)
    
    local command = fileHistory(username, password, sourceCtxPath .. fileName)
    
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
    username = util.quoteCommandlineArgument(username)
    password = util.quoteCommandlineArgument(password)
    directoryName = util.quoteCommandlineArgument(directoryName)
    
    return string.format(svn .. [[status -u %s]] .. property.redirectErrorToOutputStream, username, password, directoryName)
end

function m.status (username, password, directoryName)
    util.noBackDirectory(directoryName)
    
    local command = status(username, password, sourceCtxPath .. directoryName)
    
    local statuses = {}
    
    local f = assert(io.popen(command, "r"))
    for line in f:lines() do
        local fileName = line:match('(%a?:?[/\\].*)')
        if fileName then
            local newFileName
            local i, j = fileName:find(sourceCtxPath, 1, true)
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
    username = util.quoteCommandlineArgument(username)
    password = util.quoteCommandlineArgument(password)
    directoryName = util.quoteCommandlineArgument(directoryName)
    
    util.noCommandlineSpecialCharacters(limit)
    
    if limit then
        return string.format(svn .. [[log -v -l %s %s]] .. property.redirectErrorToOutputStream, 
            username, password, limit, directoryName)
    else
        return string.format(svn .. [[log -v %s]] .. property.redirectErrorToOutputStream, 
            username, password, directoryName)
    end
end

function m.logHistory (username, password, directoryName, limit)
    util.noBackDirectory(directoryName)
    
    local command = logHistory(username, password, sourceCtxPath .. directoryName, limit)

    local f = assert(io.popen(command, "r"))
    local content = f:read("*all")
    f:close()
    
    return content
end


--
-- commitHistory
--

local function commitHistory (username, password, directoryName, newRevision, oldRevision)
    username = util.quoteCommandlineArgument(username)
    password = util.quoteCommandlineArgument(password)
    directoryName = util.quoteCommandlineArgument(directoryName)
    
    util.noCommandlineSpecialCharacters(newRevision)
    util.noCommandlineSpecialCharacters(oldRevision)
    
    return string.format(svn .. [[diff -r %s:%s %s]] .. property.redirectErrorToOutputStream, 
        username, password, oldRevision, newRevision, directoryName)
end

function m.commitHistory (username, password, directoryName, newRevision, oldRevision)
    util.noBackDirectory(directoryName)
    
    local command = commitHistory(username, password, sourceCtxPath .. directoryName, newRevision, oldRevision)

    local f = assert(io.popen(command, "r"))
    local content = f:read("*all")
    f:close()
    
    return content, "Index: "
end


--
-- fileRevisionContent
--

local function fileRevisionContent (username, password, revision, fileName)
    username = util.quoteCommandlineArgument(username)
    password = util.quoteCommandlineArgument(password)
    fileName = util.quoteCommandlineArgument(fileName)
    
    util.noCommandlineSpecialCharacters(revision)
    
    return string.format(svn .. [[cat -r %s %s]] .. property.redirectErrorToOutputStream, username, password, revision, fileName)
end

function m.fileRevisionContent (username, password, revision, fileName)
    util.noBackDirectory(fileName)
    
    local command = fileRevisionContent(username, password, revision, sourceCtxPath .. fileName)
    
    local f = assert(io.popen(command, "r"))
    local content = f:read("*all")
    f:close()
    
    return content
end


--
-- fileDiff
--

local function fileDiff (username, password, oldRevision, newRevision, fileName)
    username = util.quoteCommandlineArgument(username)
    password = util.quoteCommandlineArgument(password)
    fileName = util.quoteCommandlineArgument(fileName)
    
    util.noCommandlineSpecialCharacters(oldRevision)
    util.noCommandlineSpecialCharacters(newRevision)
    
    local command = string.format(svn .. [[diff -r %s:%s %s]] .. property.redirectErrorToOutputStream, 
        username, password, oldRevision, newRevision, fileName)
    if newRevision == "LOCAL" then
        command = string.format(svn .. [[diff -r %s %s]] .. property.redirectErrorToOutputStream, 
            username, password, oldRevision, fileName)
    end
    return command
end

function m.fileDiff (username, password, oldRevision, newRevision, fileName)
    util.noBackDirectory(fileName)
    
    local command = fileDiff(username, password, oldRevision, newRevision, sourceCtxPath .. fileName)
    
    local f = assert(io.popen(command, "r"))
    local content = f:read("*all")
    f:close()
    
    return content
end


--
-- add
--

local function add (username, password, path)
    username = util.quoteCommandlineArgument(username)
    password = util.quoteCommandlineArgument(password)
    path = util.quoteCommandlineArgument(path)
    
    return string.format(SVN .. [[add --force %s]] .. property.redirectErrorToOutputStream, path)
end

function m.add (username, password, path)
    util.noBackDirectory(path)
    
    local command = add(username, password, sourceCtxPath .. path)
    
    local f = assert(io.popen(command, "r"))
    local content = f:read("*all")
    f:close()
    
    return content
end


--
-- delete
--

local function delete (username, password, path)
    username = util.quoteCommandlineArgument(username)
    password = util.quoteCommandlineArgument(password)
    path = util.quoteCommandlineArgument(path)
    
    return string.format(svn .. [[delete --force %s]] .. property.redirectErrorToOutputStream, username, password, path)
end

function m.delete (username, password, path)
    util.noBackDirectory(path)
    
    local command = delete(username, password, sourceCtxPath .. path)
    
    local f = assert(io.popen(command, "r"))
    local content = f:read("*all")
    f:close()
    
    return content
end


--
-- move
--

local function move (username, password, oldName, newName)
    username = util.quoteCommandlineArgument(username)
    password = util.quoteCommandlineArgument(password)
    oldName = util.quoteCommandlineArgument(oldName)
    newName = util.quoteCommandlineArgument(newName)
    
    return string.format(svn .. [[move --force %s %s]] .. property.redirectErrorToOutputStream, username, password, oldName, newName)
end

function m.move (username, password, oldName, newName)
    util.noBackDirectory(oldName)
    util.countBackDirectories(newName) -- only here is allowed to have back directory
    
    local command = move(username, password, sourceCtxPath .. oldName, sourceCtxPath .. newName)
    
    local f = assert(io.popen(command, "r"))
    local content = f:read("*all")
    f:close()
    
    return content
end


--
-- commit
--

local function commit (username, password, message, list)
    username = util.quoteCommandlineArgument(username)
    password = util.quoteCommandlineArgument(password)
    message = util.quoteCommandlineArgument(message)
    
    local paths = ""
    for i=1, #list do
        util.noBackDirectory(list[i])
        
        local path = util.quoteCommandlineArgument(sourceCtxPath .. list[i])
        paths = paths .. " " .. path
    end

    return string.format(svn .. [[commit -m %s %s]] .. property.redirectErrorToOutputStream, 
        username, password, message, paths)
end

function m.commit (username, password, message, list)
    local command = commit(username, password, message, list)

    local f = assert(io.popen(command, "r"))
    local content = f:read("*all")
    f:close()
    
    return content
end


--
-- update
--

local function update (username, password, revision, path)
    username = util.quoteCommandlineArgument(username)
    password = util.quoteCommandlineArgument(password)
    path = util.quoteCommandlineArgument(path)
    
    util.noCommandlineSpecialCharacters(revision)
    
    if revision then
        return string.format(svn .. [[update -r%s %s]] .. property.redirectErrorToOutputStream, 
            username, password, revision, path)
    else
        return string.format(svn .. [[update %s]] .. property.redirectErrorToOutputStream, 
            username, password, path)
    end
end

function m.update (username, password, revision, path)
    util.noBackDirectory(path)
    
    local command = update(username, password, revision, sourceCtxPath .. path)
    
    local f = assert(io.popen(command, "r"))
    local content = f:read("*all")
    f:close()
    
    return content
end


--
-- revert
--

local function revert (username, password, path, recursively)
    username = util.quoteCommandlineArgument(username)
    password = util.quoteCommandlineArgument(password)
    path = util.quoteCommandlineArgument(path)
    
    util.noCommandlineSpecialCharacters(recursively)
    
    if recursively then
        return string.format(SVN .. [[revert -R %s]] .. property.redirectErrorToOutputStream, path)
    else
        return string.format(SVN .. [[revert %s]] .. property.redirectErrorToOutputStream, path)
    end
end

function m.revert (username, password, path, recursively)
    util.noBackDirectory(path)
    
    local command = revert(username, password, sourceCtxPath .. path, recursively)
    
    local f = assert(io.popen(command, "r"))
    local content = f:read("*all")
    f:close()
    
    return content
end


--
-- merge
--

local function merge (username, password, fromRevision, toRevision, path)
    username = util.quoteCommandlineArgument(username)
    password = util.quoteCommandlineArgument(password)
    path = util.quoteCommandlineArgument(path)
    
    util.noCommandlineSpecialCharacters(fromRevision)
    util.noCommandlineSpecialCharacters(toRevision)
    
    return string.format([[cd %s && ]] .. svn .. [[merge -r %s:%s .]] .. property.redirectErrorToOutputStream, 
        path, username, password, fromRevision, toRevision)
end

function m.merge (username, password, fromRevision, toRevision, path)
    util.noBackDirectory(path)
    
    local command = merge(username, password, fromRevision, toRevision, sourceCtxPath .. path)
    
    local f = assert(io.popen(command, "r"))
    local content = f:read("*all")
    f:close()
    
    return content
end


--
-- refresh
--

local function refresh (username, password, path)
    username = util.quoteCommandlineArgument(username)
    password = util.quoteCommandlineArgument(password)
    path = util.quoteCommandlineArgument(path)
    
    return string.format(SVN .. [[cleanup %s]] .. property.redirectErrorToOutputStream, path)
end

function m.refresh (username, password, path)
    util.noBackDirectory(path)
    
    local command = refresh(username, password, sourceCtxPath .. path)
    
    local f = assert(io.popen(command, "r"))
    local content = f:read("*all")
    f:close()
    
    return content
end



return m -- return module