local eval = require "eval"
local parse = require "parse"
local json = require "dkjson"
local param = require "param"
local database = require "database"


-- prepare cript

local script = ngx.req.get_body_data()

local function f (env)
	local res, typeName = eval.code(script, env)
	return res, typeName
end


-- execute

local db = database.connect()
local op = db:operators()
db.query = nil -- forbid direct sql query

local status, res, typeName = pcall(f, {db = db, op = op})
db:close()


-- write response

if status then
	if type(res) == "table" then
		if #res > 0 then
			local results = {}
			for i=1,#res do
				results[#results + 1] = res[i]
			end

			results[#results + 1] = typeName -- last element is type name

			ngx.say(json.encode(results))
		else    
			if typeName then
				ngx.say(json.encode({res, typeName}))
			else
				ngx.say(json.encode(res))
			end
		end
	else
		ngx.say(res)
	end
else
	ngx.say(res)
end