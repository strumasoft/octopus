local json = require "dkjson"
local param = require "param"
local exit = require "exit"
local directory = require "Directory"



local function process ()
	local dir = param.d
	if dir == nil then dir = "/" end

	-- get map of dir entries and their attributes --
	local map = directory.entries(dir)

	-- sort dir entries --
	local dirEntries = {}
	for entry, attr in pairs(map) do dirEntries[#dirEntries + 1] = entry end
	table.sort(dirEntries)

	-- wrap evrything up --
	local dirs = {}
	for i=1,#dirEntries do
		local entry = dirEntries[i]
		local attr = map[entry]
		dirs[#dirs + 1] = {path = attr.path, name = entry, mode = attr.mode}
	end

	return json.encode(dirs)
end


local status, res = pcall(process)
if status then
	if res then ngx.say(res) end
else
	exit(res)
end