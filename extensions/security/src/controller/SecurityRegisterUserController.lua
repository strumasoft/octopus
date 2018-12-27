local json = require "json"
local property = require "property"
local database = require "database"
local util = require "util"
local userService = require "userService"



local parameters = util.parseForm(util.urldecode(ngx.req.get_body_data()))

if util.isNotEmpty(parameters.email) 
	and util.isNotEmpty(parameters.password) 
	and util.isNotEmpty(parameters.repeatPassword)
	and (parameters.password == parameters.repeatPassword)
then
	local db = database.connect()
	local status, res = pcall(userService.registerAndSetToken, db, parameters.email, parameters.password)
	db:close()

	if status then
		ngx.say("successful register")
	else
		ngx.say("unsuccessful register")
	end
else
	ngx.say("wrong data")
end