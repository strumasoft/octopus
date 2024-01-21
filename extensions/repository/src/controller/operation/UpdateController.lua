local param = require "param"
local exit = require "exit"



local function process ()
  local repository = require(param.repository)

  local username = param.username
  local password = param.password
  local revision = param.revision
  local path = param.path

  return repository.update(username, password, revision, path)
end


local ok, res = pcall(process)
if ok then
  if res then ngx.say(res) end
else
  exit(res)
end