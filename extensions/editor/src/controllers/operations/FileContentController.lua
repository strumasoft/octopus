local param = require "param"
local exit = require "exit"
local editor = require "Editor"



local function process ()
    local fileName = param.f

    return editor.fileContent(fileName)
end


local status, res = pcall(process)
if status then
    if res then ngx.say(res) end
else
    exit(res)
end