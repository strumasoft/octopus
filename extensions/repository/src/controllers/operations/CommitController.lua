local param = require "param"
local exit = require "exit"



local function process ()
    local repository = require(param.repository)
    
    local username = param.username
    local password = param.password
    local message = param.message
    local directoryName = param.directoryName
    
    local list = {}
    
    local file = param["f" .. #list] -- from 0 to N-1
    while file do
        list[#list + 1] = file
        file = param["f" .. #list]
    end
    
    return repository.commit(username, password, message, list, directoryName)
end

    
local status, res = pcall(process)
if status then
    if res then ngx.say(res) end
else
    exit(res)
end