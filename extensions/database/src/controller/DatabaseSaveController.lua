local json = require "json"
local param = require "param"
local exit = require "exit"
local database = require "database"


local description = json.decode(ngx.req.get_body_data())


local db = database.connect()
local op = db:operators()

local function f ()
	if description.spec.id then
		description.properties.id = description.spec.id
		return db:update({[description.spec.type] = description.properties})
	else
		return db:add({[description.spec.type] = description.properties})
	end
end

local status, res = pcall(db.transaction, db, f)
db:close()


if status then
	ngx.say(json.encode({info = "Save done!", id = res}))
else
	exit(res)
end