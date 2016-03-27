local json = require "dkjson"
local param = require "param"
local property = require "property"
local database = require "database"
local userService = require "userService"



local parameters = param.parseForm(param.urldecode(ngx.req.get_body_data()))

local db = database.connect()
local status, res = pcall(userService.loginAndSetToken, db, parameters.email, parameters.password)
db:close()


if status and res then
	local to = userService.redirectTo(property.securityLoginUserUrl)

	if param.isNotEmpty(to) then
		return ngx.redirect(to)
	else
		ngx.say("successful login <br/>")
	end
else
	ngx.say("wrong credentials <br/>")
end