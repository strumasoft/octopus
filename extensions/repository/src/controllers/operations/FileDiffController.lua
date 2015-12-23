local param = require "param"
local exit = require "exit"



local function process ()
    local repository = require(param.repository)
    
    local username = param.username
    local password = param.password
    local oldRevision = param.oldRevision
    local newRevision = param.newRevision
    local fileName = param.fileName
    local newFileName = param.newFileName
    local directoryName = param.directoryName
    
    return repository.fileDiff(username, password, oldRevision, newRevision, fileName, newFileName, directoryName)
end


local status, res = pcall(process)
if status then
    if res then ngx.say(res) end
else
    exit(res)
end