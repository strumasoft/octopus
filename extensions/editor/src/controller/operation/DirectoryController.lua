local json = require "json"
local param = require "param"
local exit = require "exit"
local directory = require "Directory"



local function process ()
  local dir = param.d
  if dir == nil then dir = "/" end

  return json.encode(directory.sortedEntries(dir))
end


local ok, res = pcall(process)
if ok then
  if res then ngx.say(res) end
else
  exit(res)
end