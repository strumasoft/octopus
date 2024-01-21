local json = require "json"
local exit = require "exit"
local util = require "util"
local database = require "database"


local instancesToDelete = json.decode(ngx.req.get_body_data())


local db = database.connect()
local op = db:operators()

local function f ()
  for i=1,#instancesToDelete do
    local typeTo = util.split(instancesToDelete[i].to, ".")[1]
    local typeFrom = util.split(instancesToDelete[i].from, ".")[1]

    if typeTo == typeFrom then -- self referencing
      if instancesToDelete[i].from < instancesToDelete[i].to then
        db:delete({[instancesToDelete[i].from .. "-" .. instancesToDelete[i].to] = 
          {key = instancesToDelete[i].id, value = instancesToDelete[i].parentId}})
      else
        db:delete({[instancesToDelete[i].to .. "-" .. instancesToDelete[i].from] = 
          {key = instancesToDelete[i].parentId, value = instancesToDelete[i].id}}) 
      end
    else
      if instancesToDelete[i].from < instancesToDelete[i].to then
        db:delete({[instancesToDelete[i].from .. "-" .. instancesToDelete[i].to] = 
          {key = instancesToDelete[i].parentId, value = instancesToDelete[i].id}})
      else
        db:delete({[instancesToDelete[i].to .. "-" .. instancesToDelete[i].from] = 
          {key = instancesToDelete[i].id, value = instancesToDelete[i].parentId}}) 
      end
    end
  end
end

local ok, res = pcall(db.transaction, db, f)
db:close()


if ok then
  ngx.say("Delete done!")
else
  exit(res)
end