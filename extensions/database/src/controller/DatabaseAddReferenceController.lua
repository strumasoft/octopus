local json = require "json"
local param = require "param"
local exception = require "exception"
local exit = require "exit"
local util = require "util"
local database = require "database"


local from = param.from
local to = param.to
local parentId = param.parentId
local id = param.id


local db = database.connect()
local op = db:operators()


local function add (typeTo, typeFrom)
  if util.isNotEmpty(id) and util.isNotEmpty(parentId) then
    if typeTo == typeFrom then -- self referencing
      if from < to then
        db:add({[from .. "-" .. to] = {key = id, value = parentId}})
      else
        db:add({[to .. "-" .. from] = {key = parentId, value = id}})
      end
    else
      if from < to then
        db:add({[from .. "-" .. to] = {key = parentId, value = id}})
      else
        db:add({[to .. "-" .. from] = {key = id, value = parentId}})
      end
    end
  else
    exception("id or parantId is empty")
  end
end


local function f ()
  -- find if reference(to) object exist
  local typeAndPropertyTo = util.split(to, ".")
  local typeTo = typeAndPropertyTo[1]
  local propertyTo = typeAndPropertyTo[2]

  local toObject = db:findOne({[typeTo] = {id = op.equal(id)}})

  -- add reference
  local typeAndPropertyFrom = util.split(from, ".")
  local typeFrom = typeAndPropertyFrom[1]
  local propertyFrom = typeAndPropertyFrom[2]

  local t = db.types[typeFrom]
  local property = t[propertyFrom]
  if property then
    if property.has then
      if property.has == "one" then
        local res
        if from < to then
          res = db:find({[from .. "-" .. to] = {key = op.equal(parentId)}})
        else
          res = db:find({[to .. "-" .. from] = {value = op.equal(parentId)}}) 
        end
        if #res >= 1 then
          exception(from .. " must be one not many")
        else
          add(typeTo, typeFrom)
        end
      else
        add(typeTo, typeFrom)
      end
    else
      exception(from .. " is not reference")
    end
  else
    exception(from .. " does not exists")
  end
end


local ok, res = pcall(db.transaction, db, f)
db:close()


if ok then
  ngx.say("Add done!")
else
  exit(res)
end