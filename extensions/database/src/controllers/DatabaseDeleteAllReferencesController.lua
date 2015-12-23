local json = require "dkjson"
local param = require "param"
local exception = require "exception"
local exit = require "exit"
local database = require "database"


local data = param.parseForm(ngx.req.get_body_data())
local from = data.from
local to = data.to
local parentId = data.parentId


local db = database.connect()
local op = db:operators()


local function f ()
    local typeTo = param.split(to, ".")[1]
    local typeFrom = param.split(from, ".")[1]
    
    if param.isNotEmpty(from) and param.isNotEmpty(to) and param.isNotEmpty(parentId) then
        if typeTo == typeFrom then -- self referencing
            if from < to then
                db:delete({[from .. "-" .. to] = {value = parentId}})
            else
                db:delete({[to .. "-" .. from] = {key = parentId}}) 
            end
        else
            if from < to then
                db:delete({[from .. "-" .. to] = {key = parentId}})
            else
                db:delete({[to .. "-" .. from] = {value = parentId}}) 
            end
        end
    else
        exception("from, to or parentId is empty")
    end
end


local status, res = pcall(db.transaction, db, f)
db:close()


if status then
    ngx.say("Delete done!")
else
    exit(res)
end