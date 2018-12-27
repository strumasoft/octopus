local json = require "json"
local param = require "param"
local util = require "util"
local database = require "database"
local types = require "type"


local id = param.id
local typeName = param.type

if util.isNotEmpty(typeName) then
	if types[typeName] then
		local db = database.connect()
		local op = db:operators()

		local status, res = pcall(db.find, db, {[typeName] = {id = op.equal(id)}})

		if status then
			if #res == 1 then
				local type = types[typeName]

				-- sort property names --
				local propertyNames = {}
				for k,v in pairs(type) do propertyNames[#propertyNames + 1] = k end
				table.sort(propertyNames)

				-- wrap everything up --
				local arr = {}
				for i=1,#propertyNames do
					local k = propertyNames[i]
					local v = type[k]
					arr[#arr + 1] = {name = k, value = res[1][k], type = v}
				end
				arr[#arr + 1] = typeName -- last element is type name

				ngx.say(json.encode(arr))
			else
				ngx.say("Can't edit 0 or more then 1 results!") 
			end
		else
			ngx.say(json.encode(res))
		end

		db:close()
	else
		ngx.say(typeName .. " does not exist!")
	end
else
	ngx.say("Select type!")
end