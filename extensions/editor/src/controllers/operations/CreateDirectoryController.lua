local param = require "param"
local exit = require "exit"
local editor = require "Editor"



local function process ()
    local directoryName = param.directoryName
    
    editor.createDirectory(directoryName)
    
    if param.isNotEmpty(param.repository) and param.isNotEmpty(param.username) and param.isNotEmpty(param.password) then
        local repository = require(param.repository)
        
        local username = param.username
        local password = param.password
        
        if param.repository == "SVN" then
            return repository.add(username, password, directoryName)
        end
    end
end


local status, res = pcall(process)
if status then
    if res then ngx.say(res) end
else
    exit(res)
end