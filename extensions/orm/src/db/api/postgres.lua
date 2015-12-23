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
        between = "BETWEEN",
        like = "LIKE",
        inside = "IN"
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
    executeAndDelete = function (...)
        local varargs = {...}
        
        local sql = {}
        sql[#sql + 1] = ";EXECUTE p(0, "
        
        local n, index = 0, 0
        for i=1,#varargs do
            n = n + length(varargs[i])
            for k,v in pairs(varargs[i]) do
                index = index + 1
                
                sql[#sql + 1] = "'" .. convertToString(v) .. "'"
            
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
    }