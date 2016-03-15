local json = require "dkjson"
local parse = require "parse"
local param = require "param"
local property = require "property"
local localization = require "localization"
local database = require "database"
local exit = require "exit"
local exception = require "exception"
local userService = require "userService"
local localeService = require "localeService"
local priceService = require "priceService"
local cartService = require "cartService"



local function process (db, data)
	local op = db:operators()


	local locale = localeService.getLocale(db)
	data.locale = locale


	local address = param.parseForm(param.urldecode(ngx.req.get_body_data()))
	data.address = address

	if param.isNotEmpty(address.id) then
		db:update({address = address})
	else
		local user = userService.authenticatedUser(db)
		if user then
			address.user = user
			db:add({address = address})

			user.addresses = nil -- refresh
		end
	end
end


local data = {}
local db = database.connect()
local status, err = pcall(process, db, data)
db:close()


if status then
	return ngx.redirect(property.shopUrl .. property.accountAddressesUrl)
else
	exception.toCookie(err)

	if data.address and data.address.id then
		return ngx.redirect(property.shopUrl .. property.accountAddressUrl .. "?address=" .. data.address.id)
	else
		return ngx.redirect(property.shopUrl .. property.accountAddressesUrl)
	end
end