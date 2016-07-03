local json = require "json"
local property = require "property"
local database = require "database"
local util = require "util"
local userService = require "userService"



local parameters = util.parseForm(util.urldecode(ngx.req.get_body_data()))


if util.isNotEmpty(parameters.name) 
	and util.isNotEmpty(parameters.email) 
	and util.isNotEmpty(parameters.password) 
	and util.isNotEmpty(parameters.repeatPassword)
	and (parameters.password == parameters.repeatPassword)
then
	local db = database.connect()
	local status, res = pcall(userService.registerAndSetToken, db, parameters.email, parameters.password)
	db:close()


	if status then
		local to = userService.redirectTo(property.securityRegisterUserUrl)

		if util.isNotEmpty(to) then
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