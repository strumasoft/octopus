local param = require "param"
local exit = require "exit"
local util = require "util"
local editor = require "Editor"



local function process ()
  local directoryName = param.directoryName

  editor.createDirectory(directoryName)

  if util.isNotEmpty(param.repository) and util.isNotEmpty(param.username) and util.isNotEmpty(param.password) then
    local repository = require(param.repository)

    local username = param.username
    local password = param.password

    if param.repository == "SVN" then
      return repository.add(username, password, directoryName)
    end
  end
end


local ok, res = pcall(process)
if ok then
  if res then ngx.say(res) end
else
  exit(res)
end