local json = require "json"
local parse = require "parse"
local param = require "param"
local property = require "property"
local localization = require "localization"
local database = require "database"
local exit = require "exit"
local exception = require "exception"
local util = require "util"
local localeService = require "localeService"
local priceService = require "priceService"
local cartService = require "cartService"



local function process (db, data)
	local op = db:operators()


	local locale = localeService.getLocale(db)
	data.locale = locale


	if util.isNotEmpty(param.address) then
		local address = db:findOne({address = {id = op.equal(param.address)}})

		local cart = cartService.getCart(db)
		cart.address = address
		db:update({cart = cart})
	else
		exception("address is empty")
	end
end


local data = {}
local db = database.connect()
local status, err = pcall(process, db, data)
db:close()


if status then
	return ngx.redirect(property.shopUrl .. property.checkoutDeliveryMethodUrl)
else
	exception.toCookie(err)
	return ngx.redirect(property.shopUrl .. property.checkoutAddressesUrl)
end