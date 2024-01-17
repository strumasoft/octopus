local param = require "param"
local exit = require "exit"
local util = require "util"
local editor = require "Editor"



ngx.header.content_type = 'application/octet-stream'


local function process ()
  local fileName = param.f
  
  local paths = util.split(fileName, "/")
  local name = paths[#paths]
  ngx.header["Content-Disposition"] = 'attachment; filename="' .. name .. '"'

  return editor.fileContent(fileName)
end


local status, res = pcall(process)
if status then
  if res then ngx.say(res) end
else
  exit(res)
end