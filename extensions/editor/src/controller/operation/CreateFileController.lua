local param = require "param"
local exit = require "exit"
local util = require "util"
local editor = require "Editor"



local function process ()
  local fileName = param.fileName

  editor.createFile(fileName)

  if util.isNotEmpty(param.repository) then
    local repository = require(param.repository)

    local username = param.username
    local password = param.password

    return repository.add(username, password, fileName)
  end
end


local ok, res = pcall(process)
if ok then
  if res then ngx.say(res) end
else
  exit(res)
end