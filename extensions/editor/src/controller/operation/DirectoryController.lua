local json = require "json"
local param = require "param"
local exit = require "exit"
local directory = require "Directory"



local function process ()
	local dir = param.d
	if dir == nil then dir = "/" end

	return json.encode(directory.sortedEntries(dir))
end


local status, res = pcall(process)
if status then
	if res then ngx.say(res) end
else
	exit(res)
end