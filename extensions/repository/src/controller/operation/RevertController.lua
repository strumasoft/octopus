local param = require "param"
local exit = require "exit"
local exception = require "exception"
local util = require "util"



local function process ()
  if util.isEmpty(param.repository) then exception("repository name like GIT/SVN is required") end
  local repository = require(param.repository)

  local username = param.username
  local password = param.password
  local path = param.path
  local recursively = param.recursively
  local directoryName = param.directoryName

  return repository.revert(username, password, path, recursively, directoryName)
end


local ok, res = pcall(process)
if ok then
  if res then ngx.say(res) end
else
  exit(res)
end