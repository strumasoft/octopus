local json = require "dkjson"
local param = require "param"
local types = require "types"


local typeName = param.type

if param.isNotEmpty(typeName) then
    if types[typeName] then
        local arr = {}
        for k,v in pairs(types[typeName]) do
            arr[#arr + 1] = {name = k, value = nil, type = v}
        end
        arr[#arr + 1] = typeName -- last element is type name
        
        ngx.say(json.encode(arr))
    else
        ngx.say(typeName .. " does not exist!")
    end
else
    ngx.say("Select type!")
end