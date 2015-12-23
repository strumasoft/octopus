local json = require "dkjson"
local param = require "param"
local exit = require "exit"
local database = require "database"


local instancesToDelete = json.decode(ngx.req.get_body_data())


local db = database.connect()
local op = db:operators()

local function f ()
    for i=1,#instancesToDelete do
        db:delete({[instancesToDelete[i].type] = {id = instancesToDelete[i].id}})
    end
end

local status, res = pcall(db.transaction, db, f)
db:close()


if status then
    ngx.say("Delete done!")
else
    exit(res)
end