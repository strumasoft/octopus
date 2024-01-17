local param = require "param"
local exit = require "exit"



local function process ()
  local repository = require(param.repository)

  local username = param.username
  local password = param.password
  local path = param.path
  local recursively = param.recursively
  local directoryName = param.directoryName

  return repository.revert(username, password, path, recursively, directoryName)
end


local status, res = pcall(process)
if status then
  if res then ngx.say(res) end
else
  exit(res)
end