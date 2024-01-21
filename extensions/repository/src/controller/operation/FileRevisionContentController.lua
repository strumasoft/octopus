local param = require "param"
local exit = require "exit"



ngx.header.content_type = 'text/plain'


local function process ()
  local repository = require(param.repository)

  local username = param.username
  local password = param.password
  local revision = param.revision
  local fileName = param.fileName
  local directoryName = param.directoryName

  return repository.fileRevisionContent(username, password, revision, fileName, directoryName)
end


local ok, res = pcall(process)
if ok then
  if res then ngx.say(res) end
else
  exit(res)
end