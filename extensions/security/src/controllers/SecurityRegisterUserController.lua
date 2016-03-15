local json = require "dkjson"
local param = require "param"
local property = require "property"
local database = require "database"
local userService = require "userService"



local parameters = param.parseForm(param.urldecode(ngx.req.get_body_data()))


if param.isNotEmpty(parameters.name) 
	and param.isNotEmpty(parameters.email) 
	and param.isNotEmpty(parameters.password) 
	and param.isNotEmpty(parameters.repeatPassword)
	and (parameters.password == parameters.repeatPassword)
then
	local db = database.connect()
	local status, res = pcall(userService.registerAndSetToken, db, parameters.email, parameters.password)
	db:close()


	if status then
		local to = userService.redirectTo(property.securityRegisterUserUrl)

		if param.isNotEmpty(to) then
			return ngx.redirect(to)
		else
			ngx.say("successful login <br/>")
		end
	else
		ngx.say("wrong credentials <br/>")
	end
else
	ngx.say("wrong data <br/>")
end