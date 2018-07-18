local property = require "property"
local exception = require "exception"
local util = require "util"



--
-- number of properties of object 
--
local length = util.lengthOfObject


--
-- convert value to string 
--
local function convertToString (value, config)
	if type(value) == "boolean" then
		if value then return config.booleanTrue else return config.booleanFalse end
	else
		return value
	end
end


--
-- create table
--
local function createTable (config, types, typeName)
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
end


--
-- drop table
--
local function dropTable (config, types, typeName)
	return "DROP TABLE " .. config.escape .. typeName .. config.escape
end


--
-- operators
--
local function operators (ops)
	local op = {}

	for k,v in pairs(ops) do
		op[k] = function (value)
			return {operator = v, value = value}
		end
	end

	return op
end


--
-- select
--
local function select (config, typeName, what, join, where, count, page, orderBy)
	-- construct sql --
	local sql = {}


	if property.usePreparedStatement and #where > 0 then
		sql[#sql + 1] = config.prepare(where)
	end


	sql[#sql + 1] = "SELECT "
	if count then
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
		local placeholders = config.placeholders(where)

		sql[#sql + 1] = " WHERE "
		for i=1,#where do
			sql[#sql + 1] = config.escape .. where[i].type .. config.escape .. "." .. config.escape .. where[i].property .. config.escape
			sql[#sql + 1] = " " .. where[i].operation.operator .. " "

			if property.usePreparedStatement and #where > 0 then
				sql[#sql + 1] = placeholders[i]
			else
				sql[#sql + 1] = "'" .. convertToString(where[i].operation.value, config) .. "'"
			end

			if i < #where then
				sql[#sql + 1] = " AND "
			end
		end
	end


	if not count then
		sql[#sql + 1] = " GROUP BY "
		sql[#sql + 1] =  config.escape .. typeName .. config.escape .. "." .. config.escape .. "id" .. config.escape
	end
	
	
	if orderBy then
		sql[#sql + 1] = " ORDER BY "
		for i=1,#orderBy do
			sql[#sql + 1] = config.escape .. typeName .. config.escape .. "." .. config.escape .. orderBy[i].value .. config.escape .. " " .. orderBy[i].operator
			
			if i < #orderBy then
				sql[#sql + 1] = " ,"
			end
		end
	end
	
	
	if page then
		sql[#sql + 1] = config.page(page.number, page.size)
	end


	if property.usePreparedStatement and #where > 0 then
		local values = {}
		for i=1,#where do values[#values + 1] = where[i].operation.value end
		sql[#sql + 1] = config.executeAndDelete(values)
	end


	return table.concat(sql)
end


--
-- add
--
local function add (config, typeName, value)
	-- check if value is empty
	if length(value) == 0 then exception("can't add nothing to " .. typeName) end


	-- construct sql --
	local sql = {}


	if property.usePreparedStatement then
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
		if property.usePreparedStatement then
			sql[#sql + 1] = placeholders[i]
		else
			sql[#sql + 1] = "'" .. convertToString(v, config) .. "'"
		end

		if i < length(value) then
			sql[#sql + 1] = ", "
		else
			sql[#sql + 1] = ")"
		end

		i = i + 1
	end


	if property.usePreparedStatement then
		sql[#sql + 1] = config.executeAndDelete(value)
	end


	return table.concat(sql)
end


--
-- add bulk
--
local function addBulk (config, typeName, rowNames, values)
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

			sql[#sql + 1] = "'" .. convertToString(values[i][j], config) .. "'"

			if j < #values[i] then
				sql[#sql + 1] = ", "
			else
				sql[#sql + 1] = ")"
			end
		end

		if i < #values then sql[#sql + 1] = ", " end
	end


	return table.concat(sql)
end


--
-- delete
--
local function delete (config, typeName, value)
	-- check if value is empty
	if length(value) == 0 then exception("can't delete without where clause from " .. typeName) end


	-- construct sql --
	local sql = {}


	if property.usePreparedStatement then
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

		if property.usePreparedStatement then
			sql[#sql + 1] = placeholders[i]
		else
			sql[#sql + 1] = "'" .. convertToString(v, config) .. "'"
		end

		if i < length(value) then
			sql[#sql + 1] = " AND "
		end

		i = i + 1
	end


	if property.usePreparedStatement then
		sql[#sql + 1] = config.executeAndDelete(value)
	end


	return table.concat(sql)
end


--
-- update
--
local function update (config, typeName, value, set)
	-- check if value is empty
	if length(value) == 0 then exception("can't update without where clause to " .. typeName) end


	-- construct sql --
	local sql = {}


	if property.usePreparedStatement then
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

		if property.usePreparedStatement then
			sql[#sql + 1] = placeholders[i]
		else
			sql[#sql + 1] = "'" .. convertToString(v, config) .. "'"
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

		if property.usePreparedStatement then
			sql[#sql + 1] = placeholders[length(set) + i]
		else
			sql[#sql + 1] = "'" .. convertToString(v, config) .. "'"
		end

		if i < length(value) then
			sql[#sql + 1] = " AND "
		end

		i = i + 1
	end


	if property.usePreparedStatement then
		sql[#sql + 1] = config.executeAndDelete(set, value)
	end


	return table.concat(sql)
end


--
-- return API
--
return {
	length = length,
	createTable = createTable,
	dropTable = dropTable,

	operators = operators,
	select = select,
	add = add,
	addBulk = addBulk,
	delete = delete,
	update = update
}