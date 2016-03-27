local param = require "param"
local exit = require "exit"



local function process ()
	local repository = require(param.repository)

	local username = param.username
	local password = param.password
	local fromRevision = param.fromRevision
	local toRevision = param.toRevision
	local path = param.path

	return repository.merge(username, password, fromRevision, toRevision, path)
end


local status, res = pcall(process)
if status then
	if res then ngx.say(res) end
else
	exit(res)
end