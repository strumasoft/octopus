local param = require "param"
local property = require "property"
local database = require "database"
local userService = require "userService"



-- security --
if property.requireSecurity then
	local db = database.connect()
	local status, res = pcall(userService.loggedIn, db)
	db:close()

	-- remove cache --
	ngx.ctx = {}

	if not status or not res then
		if param.isNotEmpty(ngx.var.args) then
			ngx.redirect(property.shopUrl .. property.loginUrl .. ngx.var.uri .. "?" .. ngx.var.args)
			ngx.exit(ngx.HTTP_OK)
		else
			ngx.redirect(property.shopUrl .. property.loginUrl .. ngx.var.uri)
			ngx.exit(ngx.HTTP_OK)
		end
	end
end