-- Copyright (C) 2024, StrumaSoft
--
-- Requires: 
--   OpenSSL
--   Rocky Crypto


local crypto = require "rocky.crypto"
local uuid = crypto.uuid
local dump = crypto.dump


--
-- log
--
local function log (msg)
  if ngx and not ngx.fake then
    ngx.log(ngx.ERR, msg)
  else
    print(msg)
  end
end


--
-- exception
--
local function exception (err)
  if type(err) == "table" then 
    error(err.error)
  else
    if ngx and not ngx.fake then
      ngx.log(ngx.ERR, debug.traceback())
    else
      print(debug.traceback())
    end
    error(err)
  end
end


--
-- number of properties of object 
--
local function length (obj)
  local i = 0
  if type(obj) == "table" then
    for k,v in pairs(obj) do
      i = i + 1
    end
  end
  return i
end


--
-- convert value to string 
--
local function tovalue (value, config)
  if type(value) == "table" and value.operator then
    local operation = value
    if operation.operator == "IN" then
      if #operation.values < 1 then exception("operation values must be 1 or more") end
      local res = {}
      for _,v in pairs(operation.values) do
        res[#res + 1] = tovalue(v)
      end
      return "(" .. table.concat(res, ",") .. ")"
    elseif operation.operator == "BETWEEN" then
      if #operation.values ~= 2 then exception("operation values must be 2") end
      return tovalue(operation.values[1]) .. " AND " .. tovalue(operation.values[2])
    else
      if not operation.values or #operation.values ~= 1 then exception("operation values must be 1 " .. dump(operation)) end
      return tovalue(operation.values[1])
    end
  elseif type(value) == "boolean" then
    local TRUE, FALSE = "1", "0"
    if config and config.booleanTrue then TRUE = config.booleanTrue end
    if config and config.booleanFalse then FALSE = config.booleanFalse end
    if value then return "'" .. TRUE .. "'" else return "'" .. FALSE .. "'" end
  elseif type(value) == "string" then
    return "'" .. value:gsub("'", "''") .. "'"
  else
    return "'" .. (value or "") .. "'"
  end
end


--
-- split
--
local function split (s, separator, isRegex)
  local isPlainText = not isRegex

  local index = 1
  local array = {}

  local firstIndex, lastIndex = s:find(separator, index, isPlainText)
  while firstIndex do
    if firstIndex ~= 1 then
      array[#array + 1] = s:sub(index, firstIndex - 1)
    end
    index = lastIndex + 1
    firstIndex, lastIndex = s:find(separator, index, isPlainText)
  end

  if index <= #s then
    array[#array + 1] = s:sub(index, #s)
  end

  if #array == 1 then 
    return array, false
  else 
    return array, true
  end
end


--
-- is (Not) Empty
--
local function isNotEmpty (s)
  return s ~= nil and s ~= ''
end
local function isEmpty (s)
  return s == nil or s == ''
end


--
-- isArray
--
local function isArray (t)
  if type(t) ~= "table" then return false end
  for i, v in ipairs(t) do
    return true
  end
  return false
end


--
-- dialect
--
local dialect = {
  mysql = {
    id = "varchar(36) primary key",
    integer = "bigint",
    float = "double",
    boolean = "boolean",
    booleanTrue = "1",
    booleanFalse = "0",
    string = "varchar(%d)",
    stringLength = 255, 
    escape = [[`]],
    timestamp = {
      sql = "SELECT unix_timestamp()",
      field = "unix_timestamp()"
    },
    allTablesSQL = function (schema)
      return string.format([[SELECT table_name FROM information_schema.tables WHERE table_schema = '%s']], schema)
    end,
    operators = {
      equal = "=",
      notEqual = "<>",
      greaterThan = ">",
      lessThan = "<",
      greaterThanOrEqual = ">=",
      lessThanOrEqual = "<=",
      like = "LIKE",
      between = "BETWEEN",
      inside = "IN",
      asc = "ASC",
      desc = "DESC",
      },
    unique = " UNIQUE ",
    notNull = " NOT NULL ",
    prepare = function (...)
      return "PREPARE p FROM '"
    end,
    placeholders = function (...)
      local varargs = {...}
  
      local placeholders = {}
  
      for i=1,#varargs do
        for k,v in pairs(varargs[i]) do
          local index = #placeholders + 1
          placeholders[index] = "?" -- all the same
        end
      end
  
      return placeholders
    end,
    wherePlaceholders = function (where)
      local placeholders = {}
 
      for i=1,#where do 
        for j=1,#where[i].operation.values do
          local index = #placeholders + 1
          placeholders[index] = "?" -- all the same
        end
      end

      return placeholders
    end,
    executeAndDelete = function (...)
      local varargs = {...}
  
      local sql = {}
      sql[#sql + 1] = "'"
  
      local n, index = 0, 0
      for i=1,#varargs do
        n = n + length(varargs[i])
        for k,v in pairs(varargs[i]) do
          index = index + 1
          sql[#sql + 1] = ";SET @a" .. index .. " = " .. tovalue(v)
        end
      end
  
      sql[#sql + 1] = ";EXECUTE p USING "
  
      for i=1,n do
        sql[#sql + 1] = "@a" .. i
        if i < n then sql[#sql + 1] = ", " end
      end
  
      -- MySQL automtically deallocates prepared statement when new one with the same name is created.
      -- The last is automtically deallocatd when session ends
      --sql[#sql + 1] = ";DEALLOCATE PREPARE p;"
      sql[#sql + 1] = ";"
  
      return table.concat(sql)
    end,
    pagination = function (pageNumber, pageSize)
      return " LIMIT " .. pageSize .. " OFFSET " .. (pageNumber-1)*pageSize
    end,
  },

  postgresql = {
    id = "varchar(36) primary key",
    integer = "bigint",
    float = "double precision",
    boolean = "boolean",
    booleanTrue = "1",
    booleanFalse = "0",
    string = "varchar(%d)",
    stringLength = 255,
    escape = [["]],
    timestamp = {
      sql = "SELECT extract(epoch from clock_timestamp())",
      field = "date_part"
    },
    allTablesSQL = function (schema)
      return [[SELECT table_name FROM information_schema.tables WHERE table_schema = 'public']]
    end,
    operators = {
      equal = "=",
      notEqual = "<>",
      greaterThan = ">",
      lessThan = "<",
      greaterThanOrEqual = ">=",
      lessThanOrEqual = "<=",
      like = "LIKE",
      between = "BETWEEN",
      inside = "IN",
      asc = "ASC",
      desc = "DESC",
      },
    unique = " UNIQUE ",
    notNull = " NOT NULL ",
    prepare = function (...)
      return "PREPARE p(int) AS "
    end,
    placeholders = function (...)
      local varargs = {...}
  
      local placeholders = {}
  
      for i=1,#varargs do
        for k,v in pairs(varargs[i]) do
          local index = #placeholders + 1
          placeholders[index] = "$" .. (index + 1) -- start from $2
        end
      end
  
      return placeholders
    end,
    wherePlaceholders = function (where)
      local placeholders = {}
 
      for i=1,#where do 
        for j=1,#where[i].operation.values do
          local index = #placeholders + 1
          placeholders[index] = "$" .. (index + 1) -- start from $2
        end
      end

      return placeholders
    end,
    executeAndDelete = function (...)
      local varargs = {...}
  
      local sql = {}
      sql[#sql + 1] = ";EXECUTE p(0, "
  
      local n, index = 0, 0
      for i=1,#varargs do
        n = n + length(varargs[i])
        for k,v in pairs(varargs[i]) do
          index = index + 1
          sql[#sql + 1] = tovalue(v)
          if i == #varargs and index == n then
            sql[#sql + 1] = ")"
          else
            sql[#sql + 1] = ", "
          end
        end
      end
  
      sql[#sql + 1] = ";DEALLOCATE p;"
  
      return table.concat(sql)
    end,
    pagination = function (pageNumber, pageSize)
      return " LIMIT " .. pageSize .. " OFFSET " .. (pageNumber-1)*pageSize
    end,
  }
}


--
-- common
--
local common = {
  
  --
  -- create table
  --
  createTable = function (config, types, typeName)
    local t = types[typeName] -- type
    if t then
      local r = {} -- rows
  
      for k,v in pairs(t) do
        if v.type == "id" or v.type == "integer" or v.type == "float" or v.type == "boolean" then
          local columnType = config[v.type]
  
          if v.unique then columnType = columnType .. config.unique end
          if v.notNull then columnType = columnType .. config.notNull end
  
          r[k] = {type = columnType}
        elseif v.type == "string" then
          local columnType
          if v.length then
            columnType = string.format(config.string, v.length)
          else
            columnType = string.format(config.string, config.stringLength)
          end
  
          if v.unique then columnType = columnType .. config.unique end
          if v.notNull then columnType = columnType .. config.notNull end
  
          r[k] = {type = columnType}
        end
      end
  
      -- construct sql --
      local sql = {}
  
      sql[#sql + 1] = "CREATE TABLE "
      sql[#sql + 1] = config.escape .. typeName .. config.escape
      sql[#sql + 1] = " ("
  
      local i = 1
      for k,v in pairs(r) do
        sql[#sql + 1] = config.escape .. k .. config.escape
        sql[#sql + 1] = " "
        sql[#sql + 1] = v.type
  
        if i < length(r) then
          sql[#sql + 1] = ", "
        else
          sql[#sql + 1] = ")"
        end
  
        i = i + 1
      end
  
      return table.concat(sql)
    else
      exception("type " .. typeName .. " does not exist!")
    end
  end,
  
  
  --
  -- drop table
  --
  dropTable = function (config, types, typeName)
    return "DROP TABLE " .. config.escape .. typeName .. config.escape
  end,
  
  
  --
  -- operators
  --
  operators = function (ops)
    local op = {}
  
    for k,name in pairs(ops) do
      op[k] = function (...)
        return {operator = name, values = {...}}
      end
    end
  
    return op
  end,
  
  
  --
  -- select
  --
  select = function (config, typeName, what, join, where, justCount, page, orderBy)
    -- construct sql --
    local sql = {}
  
    if config.usePreparedStatement and #where > 0 then
      sql[#sql + 1] = config.prepare(where)
    end
  
    sql[#sql + 1] = "SELECT "
    if justCount then
      sql[#sql + 1] = "COUNT(DISTINCT " .. config.escape .. typeName .. config.escape .. "." .. config.escape .. "id" .. config.escape .. ")"
    else
      for i=1,#what do
        sql[#sql + 1] = config.escape .. typeName .. config.escape .. "." .. config.escape .. what[i] .. config.escape
    
        if i < #what then
          sql[#sql + 1] = ", "
        end
      end
    end
  
    sql[#sql + 1] = " FROM "
    sql[#sql + 1] = config.escape .. typeName .. config.escape .. " " .. config.escape .. typeName .. config.escape
  
    for i=1,#join do
      sql[#sql + 1] = " INNER JOIN "
      sql[#sql + 1] = config.escape .. join[i].type .. config.escape
      if join[i].alias then sql[#sql + 1] = " " .. config.escape .. join[i].alias .. config.escape end
      sql[#sql + 1] = " ON "
      sql[#sql + 1] = config.escape .. join[i].from.type .. config.escape .. "." .. config.escape .. join[i].from.property .. config.escape
      sql[#sql + 1] = " = "
      sql[#sql + 1] = config.escape .. join[i].to.type .. config.escape .. "." .. config.escape .. join[i].to.property .. config.escape
    end
  
    if #where > 0 then
      local placeholders = config.wherePlaceholders(where)
  
      sql[#sql + 1] = " WHERE "
      for i=1,#where do
        sql[#sql + 1] = config.escape .. where[i].type .. config.escape .. "." .. config.escape .. where[i].property .. config.escape
        sql[#sql + 1] = " " .. where[i].operation.operator .. " "
  
        if config.usePreparedStatement and #where > 0 then
          if where[i].operation.operator == "IN" then
            sql[#sql + 1] = " ("
            local res = {}
            for j=1,#where[i].operation.values do res[#res + 1] = placeholders[i+j-1] end
            sql[#sql + 1] = table.concat(res, ",")
            sql[#sql + 1] = ") "
          elseif where[i].operation.operator == "BETWEEN" then
            sql[#sql + 1] = placeholders[i]
            sql[#sql + 1] = " AND "
            sql[#sql + 1] = placeholders[i+1]
          else
            sql[#sql + 1] = placeholders[i]
          end
        else
          sql[#sql + 1] = tovalue(where[i].operation, config)
        end
  
        if i < #where then
          sql[#sql + 1] = " AND "
        end
      end
    end
  
    if not justCount then
      sql[#sql + 1] = " GROUP BY "
      sql[#sql + 1] =  config.escape .. typeName .. config.escape .. "." .. config.escape .. "id" .. config.escape
    end
    
    if orderBy then
      sql[#sql + 1] = " ORDER BY "
      for i=1,#orderBy do
        sql[#sql + 1] = config.escape .. typeName .. config.escape .. "." .. config.escape .. orderBy[i].values[1] .. config.escape .. " " .. orderBy[i].operator
        
        if i < #orderBy then
          sql[#sql + 1] = " ,"
        end
      end
    end
    
    if page then
      sql[#sql + 1] = config.pagination(page.number, page.size)
    end
  
    if config.usePreparedStatement and #where > 0 then
      local values = {}
      for i=1,#where do 
        for j=1,#where[i].operation.values do
          values[#values + 1] = where[i].operation.values[j]
        end
      end
      sql[#sql + 1] = config.executeAndDelete(values)
    end
  
    return table.concat(sql)
  end,
  
  
  --
  -- add
  --
  add = function (config, typeName, value)
    -- check if value is empty
    if length(value) == 0 then exception("can't add nothing to " .. typeName) end
  
    -- construct sql --
    local sql = {}
  
    if config.usePreparedStatement then
      sql[#sql + 1] = config.prepare(value)
    end
  
    sql[#sql + 1] = "INSERT INTO "
    sql[#sql + 1] = config.escape .. typeName .. config.escape
    sql[#sql + 1] = " ("
  
    local i = 1
    for k,v in pairs(value) do
      sql[#sql + 1] = config.escape .. k .. config.escape
  
      if i < length(value) then
        sql[#sql + 1] = ", "
      else
        sql[#sql + 1] = ")"
      end
  
      i = i + 1
    end
  
    local placeholders = config.placeholders(value)
  
    i = 1
    sql[#sql + 1] = " VALUES ("
    for k,v in pairs(value) do
      if config.usePreparedStatement then
        sql[#sql + 1] = placeholders[i]
      else
        sql[#sql + 1] = tovalue(v, config)
      end
  
      if i < length(value) then
        sql[#sql + 1] = ", "
      else
        sql[#sql + 1] = ")"
      end
  
      i = i + 1
    end
  
    if config.usePreparedStatement then
      sql[#sql + 1] = config.executeAndDelete(value)
    end
  
    return table.concat(sql)
  end,
  
  
  --
  -- add bulk
  --
  addBulk = function (config, typeName, rowNames, values)
    -- check if value is empty
    if length(values) == 0 then exception("can't add nothing to " .. typeName) end
  
    -- construct sql --
    local sql = {}
  
    sql[#sql + 1] = "INSERT INTO "
    sql[#sql + 1] = config.escape .. typeName .. config.escape
    sql[#sql + 1] = " ("
  
    for i=1,#rowNames do
      sql[#sql + 1] = config.escape .. rowNames[i] .. config.escape
  
      if i < #rowNames then
        sql[#sql + 1] = ", "
      else
        sql[#sql + 1] = ")"
      end
    end
  
    sql[#sql + 1] = " VALUES "
    for i=1,#values do
      for j=1,#values[i] do
        if j == 1 then sql[#sql + 1] = "(" end
  
        sql[#sql + 1] = tovalue(values[i][j], config)
  
        if j < #values[i] then
          sql[#sql + 1] = ", "
        else
          sql[#sql + 1] = ")"
        end
      end
  
      if i < #values then sql[#sql + 1] = ", " end
    end
  
    return table.concat(sql)
  end,
  
  
  --
  -- delete
  --
  delete = function (config, typeName, value)
    -- check if value is empty
    if length(value) == 0 then exception("can't delete without where clause from " .. typeName) end
  
    -- construct sql --
    local sql = {}
  
    if config.usePreparedStatement then
      sql[#sql + 1] = config.prepare(value)
    end
  
    sql[#sql + 1] = "DELETE FROM "
    sql[#sql + 1] = config.escape .. typeName .. config.escape
    sql[#sql + 1] = " WHERE "
  
    local placeholders = config.placeholders(value)
  
    local i = 1
    for k,v in pairs(value) do
      sql[#sql + 1] = config.escape .. k .. config.escape
      sql[#sql + 1] = "="
  
      if config.usePreparedStatement then
        sql[#sql + 1] = placeholders[i]
      else
        sql[#sql + 1] = tovalue(v, config)
      end
  
      if i < length(value) then
        sql[#sql + 1] = " AND "
      end
  
      i = i + 1
    end
  
    if config.usePreparedStatement then
      sql[#sql + 1] = config.executeAndDelete(value)
    end
  
    return table.concat(sql)
  end,
  
  
  --
  -- update
  --
  update = function (config, typeName, value, set)
    -- check if value is empty
    if length(value) == 0 then exception("can't update without where clause to " .. typeName) end
  
    -- construct sql --
    local sql = {}
  
    if config.usePreparedStatement then
      sql[#sql + 1] = config.prepare(value, set)
    end
  
    sql[#sql + 1] = "UPDATE "
    sql[#sql + 1] = config.escape .. typeName .. config.escape
    sql[#sql + 1] = " SET "
  
    local placeholders = config.placeholders(value, set)
  
    local i = 1
    for k,v in pairs(set) do
      sql[#sql + 1] = config.escape .. k .. config.escape
      sql[#sql + 1] = "="
  
      if config.usePreparedStatement then
        sql[#sql + 1] = placeholders[i]
      else
        sql[#sql + 1] = tovalue(v, config)
      end
  
      if i < length(set) then
        sql[#sql + 1] = ", "
      end
  
      i = i + 1
    end
  
    i = 1
    sql[#sql + 1] = " WHERE "
    for k,v in pairs(value) do
      sql[#sql + 1] = config.escape .. k .. config.escape
      sql[#sql + 1] = "="
  
      if config.usePreparedStatement then
        sql[#sql + 1] = placeholders[length(set) + i]
      else
        sql[#sql + 1] = tovalue(v, config)
      end
  
      if i < length(value) then
        sql[#sql + 1] = " AND "
      end
  
      i = i + 1
    end
  
    if config.usePreparedStatement then
      sql[#sql + 1] = config.executeAndDelete(set, value)
    end
  
    return table.concat(sql)
  end,
}


--
-- forward declaration of functions
--
local getReferences
local prePopulate
local query


--
-- UTILS
--

local function createRelation (from, to)
  local typeTo = split(to, ".")[1]
  local typeFrom = split(from, ".")[1]

  if from < to then
    return {type = from .. "-" .. to}, true, typeTo == typeFrom
  else
    return {type = to .. "-" .. from}, false, typeTo == typeFrom
  end
end


local function createRelations (o, id, v, from, to)
  if type(v) == "table" then -- v is object or array
    if length(v) == 0 then return end -- do nothing if v={}

    if #v == 0 then -- v is object
      if not v.id then exception(from .. " does not have id or it is not persisted") end

      local relation, straight, selfReferencing = createRelation(from, to)
      if straight then
        if selfReferencing then
          relation.key = v.id
          relation.value = id
        else
          relation.key = id
          relation.value = v.id
        end
      else
        if selfReferencing then
          relation.key = id
          relation.value = v.id
        else
          relation.key = v.id
          relation.value = id
        end
      end

      -- do not add if key/value is empty/null --> set list to empty
      if isNotEmpty(relation.key) and isNotEmpty(relation.value) then
        local relationName = relation.type
        if o[relationName] then
          o[relationName][#o[relationName] + 1] = {uuid(), relation.key, relation.value}
        else
          o[relationName] = {{uuid(), relation.key, relation.value}}
        end
      end
    else -- v is array
      for i=1,#v do 
        createRelations(o, id, v[i], from, to)
      end
    end
  else -- v is id
    local relation, straight, selfReferencing = createRelation(from, to)
    if straight then
      if selfReferencing then
        relation.key = v
        relation.value = id
      else
        relation.key = id
        relation.value = v
      end
    else
      if selfReferencing then
        relation.key = id
        relation.value = v
      else
        relation.key = v
        relation.value = id
      end
    end

    -- do not add if key/value is empty/null --> set list to empty
    if isNotEmpty(relation.key) and isNotEmpty(relation.value) then
      local relationName = relation.type
      if o[relationName] then
        o[relationName][#o[relationName] + 1] = {uuid(), relation.key, relation.value}
      else
        o[relationName] = {{uuid(), relation.key, relation.value}}
      end
    end
  end
end


local function createDelete (d, id, from, to)
  local relation, straight, selfReferencing = createRelation(from, to)
  if straight then
    if selfReferencing then
      relation.value = id
    else
      relation.key = id
    end
  else
    if selfReferencing then
      relation.key = id
    else
      relation.value = id
    end
  end
  d[#d + 1] = relation
end


local function splitValueToPropertiesReferencesAndDeletes (config, types, update, typeName, value, id)
  local t = types[typeName] -- type
  if t then
    local r = {} -- rows/properties
    local o = {} -- objects/references/relations
    local d = {} -- delete

    for k,v in pairs(value) do
      local property = t[k]
      if not property then exception("property " .. typeName .. "." .. k .. " does not exist!") end

      if property.type == "id" or property.type == "integer" or property.type == "float" or property.type == "boolean" or property.type == "string" then
        r[k] = v
      else
        local from = typeName .. "." .. k
        local to = property.type

        if update then createDelete(d, id, from, to) end
        createRelations(o, id, v, from, to)

        -- check if property has one reference or many
        local relation, straight, selfReferencing = createRelation(from, to)
        if #o > 0 and property.has == "one" and #o[relation.type] > 1 then
          exception(from .. " must be one not many")
        end
      end
    end

    return r, o, d
  else
    exception("type " .. typeName .. " does not exist!")
  end
end


local function addRelations (self, o)
  for k,v in pairs(o) do
    local sql = common.addBulk(self.config, k, {"id", "key", "value"}, v)
    query(self, sql)
  end
end


local function deleteRelations (self, d, o)
  for i=1,#d do
    local relationType = d[i].type
    d[i].type = nil

    local sql = common.delete(self.config, relationType, d[i])
    query(self, sql)
  end
end


local function createAlias (aliases, typeName)
  local alias = aliases[typeName]
  if alias then
    alias = "_" .. alias
  else
    alias = typeName
  end
  aliases[typeName] = alias

  return alias
end


local function splitValueToJoinAndWhere (types, typeName, value, join, where, aliases)
  local t = types[typeName] -- type
  if t then
    for k,v in pairs(value) do
      local property = t[k]
      if not property then exception("property " .. typeName .. "." .. k .. " does not exist!") end

      if property.type == "id" or property.type == "integer" or property.type == "float" or property.type == "boolean" or property.type == "string" then
        if aliases[typeName] then -- self referencing
          where[#where + 1] = {type = aliases[typeName], property = k, operation = v}
        else
          where[#where + 1] = {type = typeName, property = k, operation = v}
        end
      else
        local from = typeName .. "." .. k
        local to = property.type

        local referenceType
        if property.type:find(".", 1, true) then
          local typeAndProperty = split(property.type, ".")
          referenceType = typeAndProperty[1]
        else
          referenceType = property.type
        end

        local typeNameAlias = aliases[typeName]

        if referenceType == typeName then -- self referencing
          if from < to then
            local relationType = from .. "-" .. to

            local relationTypeAlias = createAlias(aliases, relationType)

            join[#join + 1] = {
              type = relationType,
              alias = relationTypeAlias,
              from = {type = typeNameAlias, property = "id"}, 
              to = {type = relationTypeAlias, property = "value"}
            }

            local referenceTypeAlias = createAlias(aliases, referenceType)

            join[#join + 1] = {
              type = referenceType,
              alias = referenceTypeAlias,
              from = {type = relationTypeAlias, property = "key"}, 
              to = {type = referenceTypeAlias, property = "id"}
            }
          else
            local relationType = to .. "-" .. from

            local relationTypeAlias = createAlias(aliases, relationType)

            join[#join + 1] = {
              type = relationType,
              alias = relationTypeAlias,
              from = {type = typeNameAlias, property = "id"}, 
              to = {type = relationTypeAlias, property = "key"}
            }

            local referenceTypeAlias = createAlias(aliases, referenceType)

            join[#join + 1] = {
              type = referenceType,
              alias = referenceTypeAlias,
              from = {type = relationTypeAlias, property = "value"}, 
              to = {type = referenceTypeAlias, property = "id"}
            }
          end
        else
          if from < to then
            local relationType = from .. "-" .. to

            local relationTypeAlias = createAlias(aliases, relationType)

            join[#join + 1] = {
              type = relationType,
              alias = relationTypeAlias,
              from = {type = typeNameAlias, property = "id"}, 
              to = {type = relationTypeAlias, property = "key"}
            }

            local referenceTypeAlias = createAlias(aliases, referenceType)

            join[#join + 1] = {
              type = referenceType,
              alias = referenceTypeAlias,
              from = {type = relationTypeAlias, property = "value"}, 
              to = {type = referenceTypeAlias, property = "id"}
            }
          else
            local relationType = to .. "-" .. from

            local relationTypeAlias = createAlias(aliases, relationType)

            join[#join + 1] = {
              type = relationType,
              alias = relationTypeAlias,
              from = {type = typeNameAlias, property = "id"}, 
              to = {type = relationTypeAlias, property = "value"}
            }

            local referenceTypeAlias = createAlias(aliases, referenceType)

            join[#join + 1] = {
              type = referenceType,
              alias = referenceTypeAlias,
              from = {type = relationTypeAlias, property = "key"}, 
              to = {type = referenceTypeAlias, property = "id"}
            }
          end
        end

        splitValueToJoinAndWhere(types, referenceType, v, join, where, aliases)
      end
    end
  else
    exception("type " .. typeName .. " does not exist!")
  end
end


local function getProperties (types, typeName)
  local what = {}

  local t = types[typeName] -- type
  for key,property in pairs(t) do
    if property.type == "id" or property.type == "integer" or property.type == "float" or property.type == "boolean" or property.type == "string" then
      what[#what + 1] = key
    end
  end

  return what
end


local function callMetamethod (collection, argument) -- t == collection
  if argument then
    if #argument > 0 then -- argument is array, so it is references
      local references = argument
      prePopulate(collection, references)
      return collection
    else -- argument is object, so it is filter
      local filter = argument

      if #collection > 0 then
        local res = {}
        for i=1,#collection do
          local success = true
          for k,v in pairs(filter) do
            if success and collection[i][k] ~= v then success = false end
          end
          if success then res[#res + 1] = collection[i] end
        end
        return res
      else
        local object = collection

        local success = true
        for k,v in pairs(filter) do
          if success and object[k] ~= v then success = false end
        end
        if success then return object end
      end
    end
  end
end


local function getMetatableWithReferences (self, referenceType)
  local mt = {
    __index = function (obj, propertyName)
      -- collection (non empty), object or null
      local collection = getReferences(self, referenceType, propertyName, obj.id)

      if collection and #collection > 0 then -- collection is collection (non empty), not object or null
        setmetatable(collection, {__call = callMetamethod})
      end

      obj[propertyName] = collection
      return collection
    end,

    __call = callMetamethod,
  }

  return mt
end


--
-- return result as collection (non empty), object or null
-- if 'from' is nil then db:find was executed and __call is added to each res[i]
--
local function setUpReferences (self, referenceType, res, one, from)
  if res and #res > 0 then
    if one then
      if #res > 1 then
        log(from .. " must be one not many ==> " .. dump(res))
      end

      local obj = res[1]
      local mt = getMetatableWithReferences(self, referenceType)
      setmetatable(obj, mt)
      return obj
    else
      for i=1,#res do
        local mt = getMetatableWithReferences(self, referenceType)
        setmetatable(res[i], mt)
      end
      return res
    end
  end
end


--
-- return result as collection (non empty), object or null
--
getReferences = function (self, typeName, k, id)
  local t = self.types[typeName] -- type
  if t then
    local property = t[k]

    if not property then exception("property " .. typeName .. "." .. k .. " does not exist!") end

    if property.type == "id" or property.type == "integer" or property.type == "float" or property.type == "boolean" or property.type == "string" then
      return nil -- empty value
    else
      local from = typeName .. "." .. k
      local to = property.type

      local referenceType
      if property.type:find(".", 1, true) then
        local typeAndProperty = split(property.type, ".")
        referenceType = typeAndProperty[1]
      else
        referenceType = property.type
      end

      local join = {}
      local alias = "_" .. typeName
      if referenceType == typeName then -- self referencing
        if from < to then
          local relationType = from .. "-" .. to
          join[#join + 1] = {
            type = relationType, 
            from = {type = referenceType, property = "id"}, 
            to = {type = relationType, property = "key"}
          }
          join[#join + 1] = {
            type = typeName,
            alias = alias,
            from = {type = relationType, property = "value"}, 
            to = {type = alias, property = "id"}
          }
        else
          local relationType = to .. "-" .. from
          join[#join + 1] = {
            type = relationType,
            from = {type = referenceType, property = "id"}, 
            to = {type = relationType, property = "value"}
          }
          join[#join + 1] = {
            type = typeName,
            alias = alias,
            from = {type = relationType, property = "key"}, 
            to = {type = alias, property = "id"}
          }
        end
      else
        if from < to then
          local relationType = from .. "-" .. to
          join[#join + 1] = {
            type = relationType, 
            from = {type = referenceType, property = "id"}, 
            to = {type = relationType, property = "value"}
          }
          join[#join + 1] = {
            type = typeName,
            from = {type = relationType, property = "key"}, 
            to = {type = typeName, property = "id"}
          }
        else
          local relationType = to .. "-" .. from
          join[#join + 1] = {
            type = relationType,
            from = {type = referenceType, property = "id"}, 
            to = {type = relationType, property = "key"}
          }
          join[#join + 1] = {
            type = typeName,
            from = {type = relationType, property = "value"}, 
            to = {type = typeName, property = "id"}
          }
        end
      end

      -- find references --

      local what = getProperties(self.types, referenceType)

      local where = {}
      if referenceType == typeName then -- self referencing
        where[#where + 1] = {type = alias, property = "id", operation = {operator = self.config.operators.equal, values = {id}}}
      else
        where[#where + 1] = {type = typeName, property = "id", operation = {operator = self.config.operators.equal, values = {id}}}
      end

      local sql = common.select(self.config, referenceType, what, join, where)
      local res = query(self, sql)

      return setUpReferences(self, referenceType, res, property.has == "one", from)
    end
  else
    exception("type " .. typeName .. " does not exist!")
  end
end


prePopulate = function (res, references)
  -- res is collection (may be empty but may be not), object or null

  if not res then return end
  if length(res) == 0 then return end

  for i=1,#references do
    if type(references[i]) == "table" then
      if length(references[i]) ~= 1 then
        exception("filter only one field") 
      end

      for k,v in pairs(references[i]) do
        if #v == 0 then -- filter
          if #res > 0 then
            for j=1,#res do
              if res[j][k] then
                local x = res[j][k](v)
                res[j][k] = x
              end
            end
          else
            if res[k] then
              local x = res[k](v)
              res[k] = x
            end
          end
        else -- populate references of references
          if #res > 0 then
            for j=1,#res do
              local x = res[j][k]
              prePopulate(x, v)
            end
          else
            local x = res[k]
            prePopulate(x, v)
          end
        end
      end
    else -- populate references
      if #res > 0 then
        for j=1,#res do
          local x = res[j][references[i]]
        end
      else
        local x = res[references[i]]
      end
    end
  end
end


local function createRelationDelete (d, id, relation, typeName)
  local from, to
  local fromToRelation = split(relation, "-")
  if fromToRelation[1]:find("^" .. typeName) then 
    from = fromToRelation[1]
    to = fromToRelation[2]
  else
    from = fromToRelation[2]
    to = fromToRelation[1]
  end
  createDelete(d, id, from, to)
end


local function getRelationDeletes (self, id, typeName)
  local d = {} -- delete
  for k,_ in pairs(self.types) do
    if k:find("^" .. typeName .. "%.") then
      createRelationDelete(d, id, k, typeName)
    elseif k:find("^" .. typeName .. "%-") then
      createRelationDelete(d, id, k, typeName)
    elseif k:find("%-" .. typeName .. "%.") then
      createRelationDelete(d, id, k, typeName)
    elseif k:find("%-" .. typeName .. "$") then
      createRelationDelete(d, id, k, typeName)
    end
  end
  return d
end


--
-- END OF UTILS
--



--
-- TRANSACTIONS
--


--
-- begin transaction
--
local function beginTransaction (self)
  query(self, "BEGIN")
end


--
-- commit transaction
--
local function commitTransaction (self)
  query(self, "COMMIT")
end


--
-- rollback transaction
--
local function rollbackTransaction (self)
  query(self, "ROLLBACK", true)
end


--
-- transaction
--
local function transaction (self, f, ...)
  beginTransaction(self)
  local ok, res = pcall(f, self, ...)
  if not ok then
    rollbackTransaction(self)
    exception({error = res})
  else
    commitTransaction(self) 
    return res
  end
end


--
-- END OF TRANSACTIONS
--



--
-- API
--


--
-- operators
--
local function operators (self)
  return common.operators(self.config.operators)
end


--
-- query
--
query = function (self, sql, doNotThrow)
  if self.config.debugDB then
    log(sql)
  end

  local res, err = self.db:query(sql)

  while err == "again" and self.config.usePreparedStatement do
    res, err = self.db:read_result() -- we are looking for the last one
  end

  if err then
    if doNotThrow then
      return nil, err
    else
      exception(err)
    end
  else
    if res and #res > 0 then
      if self.config.debugDB then
        log(dump(res))
      end
    end
    return res
  end
end


--
-- close
--
local function close (self)
  local ok, err = self.db:close()
  return ok, err
end


--
-- create table
--
local function createTable (self, typeName)
  local sql = common.createTable(self.config, self.types, typeName)
  query(self, sql)
end


--
-- create all tables
--
local function createAllTables (self)
  for k,v in pairs(self.types) do
    self:createTable(k)
  end
end


--
-- drop table
--
local function dropTable (self, typeName)
  local sql = common.dropTable(self.config, self.types, typeName)
  query(self, sql)
end


--
-- drop all tables
--
local function dropAllTables (self)
  local res = query(self, self.config.allTablesSQL(self.opts.database))

  if res and #res > 0 then
    for i=1,#res do
      self:dropTable(res[i].table_name or res[i].TABLE_NAME)
    end
  end
end


--
-- export
--
local function export (self)
  local objects = {}
  local relations = {}

  for k,v in pairs(self.types) do
    local res = self:find({[k] = {}})

    if res and #res > 0 then
      local t = {}

      for i=1,#res do
        local id = res[i].id
        res[i].id = nil

        t[id] = res[i]
      end

      if k:find("-", 1, true) then
        relations[k] = t
      else
        objects[k] = t
      end
    end
  end

  return {objects = objects, relations = relations}
end


--
-- import
--
local function import (self, import)
  if type(import) == "string" then
    import = require(import)
  elseif type(import) == "table" then
    -- nothing more needed
  else
    exception("supply name of the module to import or the import object itself")
  end

  if import.objects then
    for typeName,typeMap in pairs(import.objects) do
      for _,obj in pairs(typeMap) do
        local id = self:add({[typeName] = obj})
        obj.id = id
      end
    end
  end

  if import.relations then
    for typeName,typeMap in pairs(import.relations) do
      local fromToRelation = split(typeName, "-")

      local from
      if fromToRelation[1]:find(".", 1, true) then
        from = split(fromToRelation[1], ".")[1] -- first part
      else
        from = fromToRelation[1]
      end

      local to
      if fromToRelation[2]:find(".", 1, true) then
        to = split(fromToRelation[2], ".")[1] -- first part
      else
        to = fromToRelation[2]
      end

      for _,obj in pairs(typeMap) do
        local key = import.objects[from][obj.key].id
        local value = import.objects[to][obj.value].id

        local id = self:add({[typeName] = {key = key, value = value}})
      end
    end
  end
end


--
-- select
--
local function select (self, proto, references, justCount, page, orderBy)
  if length(proto) ~= 1 then
    exception("find only one type") 
  end

  for typeName,value in pairs(proto) do
    local join = {}
    local where = {}
    local aliases = {}
    aliases[typeName] = typeName

    splitValueToJoinAndWhere(self.types, typeName, value, join, where, aliases)

    local what = getProperties(self.types, typeName)

    local sql = common.select(self.config, typeName, what, join, where, justCount, page, orderBy)
    local res = query(self, sql)

    local resWithReferences = setUpReferences(self, typeName, res, false)

    if references then
      prePopulate(resWithReferences, references)
    end

    if resWithReferences then
      return resWithReferences, typeName
    else
      return res, typeName
    end
  end
end


--
-- add
--
local function add (self, proto)
  if length(proto) ~= 1 then
    exception("add only one type") 
  end

  for typeName,value in pairs(proto) do
    value.id = uuid()

    local r, o, d = splitValueToPropertiesReferencesAndDeletes(self.config, self.types, false, typeName, value, value.id)

    -- 'r' contains at least id
    local sql = common.add(self.config, typeName, r)
    query(self, sql)

    deleteRelations(self, d)
    addRelations(self, o)

    local mt = getMetatableWithReferences(self, typeName)
    setmetatable(value, mt)

    return value.id
  end
end


--
-- add all
--
local function addAll (self, proto, updateProto)
  if length(proto) ~= 1 then
    exception("add only one type")
  end

  for typeName,value in pairs(proto) do
    local t = self.types[typeName] -- type
    if t then
      for k,v in pairs(value) do
        local property = t[k]
        if not property then exception("property " .. typeName .. "." .. k .. " does not exist!") end

        local referenceType
        if property.type:find(".", 1, true) then
          local typeAndProperty = split(property.type, ".")
          referenceType = typeAndProperty[1]
        else
          referenceType = property.type
        end

        if property.type ~= "id" and property.type ~= "integer" and property.type ~= "float" and property.type ~= "boolean" and property.type ~= "string" then
          local updateProperty, nextUpdateProto
          if updateProto and #updateProto > 0 then
            for j=1,#updateProto do
              if type(updateProto[j]) == "string" then
                if updateProto[j] == k then
                  updateProperty = true
                end
              else
                local x, y = next(updateProto[j])
                if x == k then
                  nextUpdateProto = y
                end
              end
            end
          end

          if not updateProperty then
            if #v > 0 then
              for i=1,#v do
                addAll(self, {[referenceType] = v[i]}, nextUpdateProto)
              end
            else
              addAll(self, {[referenceType] = v}, nextUpdateProto)
            end
          end
        end
      end

      add(self, proto)
      return proto
    else
      exception("type " .. typeName .. " does not exist!")
    end
  end
end


--
-- delete
--
local function delete (self, proto)
  if length(proto) ~= 1 then
    exception("delete only one type") 
  end

  for typeName,value in pairs(proto) do
    local t = self.types[typeName] -- type
    if t then
      -- check if invalid properties are supplied
      for k,v in pairs(value) do
        if not t[k] then exception("property " .. typeName .. "." .. k .. " does not exist!") end
      end

      local example = value
      if value.id then example = {id = value.id} end -- delete only by id if supplied

      local sql = common.delete(self.config, typeName, example)
      query(self, sql)

      if value.id then
        local d = getRelationDeletes(self, value.id, typeName)
        deleteRelations(self, d)
      end
    else
      exception("type " .. typeName .. " does not exist!")
    end
  end
end


--
-- update
--
local function update (self, proto, set)
  if length(proto) ~= 1 then
    exception("update only one type") 
  end

  if set then
    for typeName,value in pairs(proto) do
      if not value.id then exception("object does not have id or it is not persisted") end

      -- update rows & relations
      local r, o, d = splitValueToPropertiesReferencesAndDeletes(self.config, self.types, true, typeName, set, value.id)

      if length(r) > 0 then -- do not add nothing if empty, 'r' does not contain id
        local sql = common.update(self.config, typeName, value, r)
        query(self, sql)
      end

      deleteRelations(self, d)
      addRelations(self, o)

      set.id = value.id -- set back id in object
      return value.id
    end
  else
    for typeName,value in pairs(proto) do
      if not value.id then exception("object does not have id or it is not persisted") end

      local id = value.id
      value.id = nil -- update everything but id

      -- update rows & relations
      local r, o, d = splitValueToPropertiesReferencesAndDeletes(self.config, self.types, true, typeName, value, id)

      if length(r) > 0 then -- do not add nothing if empty, 'r' does not contain id
        local sql = common.update(self.config, typeName, {id = id}, r)
        query(self, sql)
      end

      deleteRelations(self, d)
      addRelations(self, o)

      value.id = id -- set back id in object
      return id
    end
  end
end


--
-- END OF API
--



--
-- build
--
local function build (modules, rdbms)
  local config = dialect[rdbms]

  for name,t in pairs(modules) do
    for k,v in pairs(t) do
      if type(v) ~= "table" then
        if v == "string" then
          t[k] = {type = "string", length = config.stringLength}
        else
          if v ~= "id" and v ~= "integer" and v ~= "float" and v ~= "boolean" and v ~= "string" then
            t[k] = {type = v, has = "one"}
          else
            t[k] = {type = v}
          end
        end
      elseif v.type == "string" and not v.length then
        v.length = config.stringLength
      end
    end

    -- add unique ID
    t.id = {type = "id"}
  end

  -- create relations --
  local relations = {}
  for name,t in pairs(modules) do
    if name ~= "_" then
      for k,v in pairs(t) do
        local property = t[k]
        if property.type ~= "id" and property.type ~= "integer" and property.type ~= "float" and property.type ~= "boolean" and property.type ~= "string" then
          local from = name .. "." .. k
          local to = property.type

          -- check relation declaration
          if property.type:find(".", 1, true) then
            local typeAndProperty = split(property.type, ".")
            if modules[typeAndProperty[1]] then
              local reference = modules[typeAndProperty[1]][typeAndProperty[2]]
              if not reference or reference.type ~= from then 
                exception("properties " .. from .. " and " .. to .. " are not linked!")
              end
            else
              exception("type " .. typeAndProperty[1] .. " does not exists!")
            end
          else
            if not modules[property.type] then
              exception("type " .. property.type .. " does not exists!")
            end
          end

          -- create relation
          if from < to then
            relations[from .. "-" .. to] = {id = {type = "id"}, key = {type = "string", length = 36}, value = {type = "string", length = 36}}
          else
            relations[to .. "-" .. from] = {id = {type = "id"}, key = {type = "string", length = 36}, value = {type = "string", length = 36}}
          end
        end
      end
    end
  end

  -- copy relations to types
  for k,v in pairs(relations) do
    modules[k] = v
  end

  return modules
end


--
-- connect
--
local function connectToDatabase (opts, driver)
  local db, err = driver:new()
  if not db then
    exception("failed to instantiate driver: " .. err)
  end
  
  db:set_timeout(opts.timeout or 3000)

  local ok, err, errcode, sqlstate = db:connect(opts)
  if not ok then
    exception(string.format("failed to connect: %s errcode=%s sqlstate=%s", err, errcode, sqlstate))
  end

  return db
end


local function connect (opts)
  -- configure connection --
  if not opts.rdbms then exception("rdbms required") end
  local config = dialect[opts.rdbms]
  config.usePreparedStatement = opts.usePreparedStatement
  config.debugDB = opts.debugDB
  
  local driver = opts.driver
  if not driver then 
    exception("driver required") 
  elseif type(driver) == "string" then
    if string.sub(driver, -1) == '.' then -- driver ends with '.'
      driver = require(driver .. opts.rdbms)
    else
      driver = require(driver)
    end
  elseif type(driver) == "function" then
    driver = driver()
  end
  
  local types = opts.types
  if not types then 
    exception("types required")
  elseif type(types) == "string" then
    types = require(types)
  end
  types = build(types, opts.rdbms)

  -- connect to database --
  local db = connectToDatabase(opts, driver)

  -- construct orm api --
  return {
    db = db,
    opts = opts,
    types = types,
    config = config,
    driver = driver,

    transaction = transaction,

    operators = operators,
    query = query,
    close = close,

    createTable = createTable,
    createAllTables = function (self)
      transaction(self, createAllTables)
    end,

    dropTable = dropTable,
    dropAllTables = function (self)
      transaction(self, dropAllTables)
    end,

    export = export,
    import = function (self, data)
      return transaction(self, import, data)
    end,

    find = function (self, x1, x2, x3, x4)
      if type(x1) == "table" then
        local proto, references = x1, x2
        local orderBy = proto.orderBy
        if proto.orderBy then proto.orderBy = nil end -- remove orderBy
        local res, typeName = select(self, proto, references, nil, nil, orderBy)
        return res, typeName
      elseif type(x1) == "number" and type(x2) == "number" then
        local pageNumber, pageSize, proto, references = x1, x2, x3, x4
        local orderBy = proto.orderBy
        if proto.orderBy then proto.orderBy = nil end -- remove orderBy
        local res, typeName = select(self, proto, references, nil, {number = pageNumber, size = pageSize}, orderBy)
        return res, typeName
      elseif type(x1) == "number" and type(x2) == "table" then
        local pageNumber, pageSize, proto, references = 1, x1, x2, x3
        local orderBy = proto.orderBy
        if proto.orderBy then proto.orderBy = nil end -- remove orderBy
        local res, typeName = select(self, proto, references, nil, {number = pageNumber, size = pageSize}, orderBy)
        return res, typeName
      else
        exception("illegal arguments")
      end
    end,

    findOne = function (self, proto, references)
      if proto.orderBy then proto.orderBy = nil end -- remove orderBy
      local res, typeName = select(self, proto, references)
      if res and #res == 1 then
        return res[1], typeName
      elseif not res or #res == 0 then
        exception(next(proto) .. " must be one not none")
      else
        exception(next(proto) .. " must be one not many ==> " .. dump(res))
      end
    end,

    count = function (self, proto)
      if type(proto) ~= "table" then exception("illegal arguments") end  
      if proto.orderBy then proto.orderBy = nil end -- remove orderBy
      local references = nil
      local res = select(self, proto, references, true)
      for _,n in pairs(res[1]) do return tonumber(n) end -- count(n) is the first and only value of the object
    end,

    add = function (self, proto)
      return transaction(self, add, proto)
    end,
    addAll = function (self, proto, updateProto)
      return transaction(self, addAll, proto, updateProto)
    end,

    delete = function (self, proto)
      return transaction(self, delete, proto)
    end,

    update = function (self, proto, set)
      return transaction(self, update, proto, set)
    end
  }
end


return {connect = connect, build = build}
