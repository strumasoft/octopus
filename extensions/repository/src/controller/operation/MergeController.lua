local param = require "param"
local exit = require "exit"
local exception = require "exception"
local util = require "util"



local function process ()
  if util.isEmpty(param.repository) then exception("repository name like GIT/SVN is required") end
  local repository = require(param.repository)

  local username = param.username
  local password = param.password
  local fromRevision = param.fromRevision
  local toRevision = param.toRevision
  local path = param.path

  return repository.merge(username, password, fromRevision, toRevision, path)
end


local ok, res = pcall(process)
if ok then
  if res then ngx.say(res) end
else
  exit(res)
end