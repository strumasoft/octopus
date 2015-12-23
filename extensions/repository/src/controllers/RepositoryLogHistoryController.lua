local param = require "param"
local exit = require "exit"



local function process ()
    local repository = require(param.repository)
    
    local username = param.username
    local password = param.password
    local directoryName = param.directoryName
    
    local limit
    if param.isNotEmpty(param.limit) then limit = param.limit end
    
    return repository.logHistory(username, password, directoryName, limit)
end


local status, res = pcall(process)
if status then
    if res then ngx.say(res) end
else
    exit(res)
end