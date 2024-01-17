local param = require "param"
local exit = require "exit"
local util = require "util"
local editor = require "Editor"



local function process ()
  local oldName = param.oldName
  local newName = param.newName

  if util.isNotEmpty(param.repository) and util.isNotEmpty(param.username) and util.isNotEmpty(param.password) then
    local repository = require(param.repository)

    local username = param.username
    local password = param.password
    local directoryName = param.directoryName

    return repository.move(username, password, oldName, newName, directoryName)
  else
    editor.rename(oldName, newName)
  end
end


local status, res = pcall(process)
if status then
  if res then ngx.say(res) end
else
  exit(res)
end