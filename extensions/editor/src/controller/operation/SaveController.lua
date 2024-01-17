local param = require "param"
local exit = require "exit"
local editor = require "Editor"



local function process ()
  local fileName = param.f

  editor.save(fileName, ngx.req.get_body_data())
end


local status, res = pcall(process)
if status then
  if res then ngx.say(res) end
else
  exit(res)
end