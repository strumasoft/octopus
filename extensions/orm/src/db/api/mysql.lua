--
-- number of properties of object 
--
local function length (obj)
	local i = 0
	if obj then
		for k,v in pairs(obj) do
			i = i + 1
		end
	end
	return i
end


--
-- convert value to string 
--
local function convertToString (value)
	if type(value) == "boolean" then
		if value then return "1" else return "0" end
	else
		return value
	end
end


--
-- table config
--
return {
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
		between = "BETWEEN",
		like = "LIKE",
		inside = "IN"
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
	executeAndDelete = function (...)
		local varargs = {...}

		local sql = {}

		sql[#sql + 1] = "'"

		local n, index = 0, 0
		for i=1,#varargs do
			n = n + length(varargs[i])
			for k,v in pairs(varargs[i]) do
				index = index + 1

				sql[#sql + 1] = ";SET @a" .. index .. " = " .. "'" .. convertToString(v) .. "'"
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
	page = function (pageNumber, pageSize)
		return " LIMIT " .. pageSize .. " OFFSET " .. (pageNumber-1)*pageSize
	end,
	}