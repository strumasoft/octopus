local json = require "json"
local parse = require "parse"
local param = require "param"
local property = require "property"
local localization = require "localization"
local database = require "database"
local exit = require "exit"
local exception = require "exception"
local exceptionHandler = require "exceptionHandler"
local localeService = require "localeService"
local priceService = require "priceService"
local cartService = require "cartService"



local function process (db, data)
	local locale = localeService.getLocale(db)
	data.locale = locale


	local cart = cartService.getCart(db)
	if cart.productEntries then
		data.redirectUrl = property.shopUrl .. property.checkoutAddressesUrl
		return
	else
		exceptionHandler.toCookie("cart does not have products")
		data.redirectUrl = property.shopUrl .. property.cartUrl
		return
	end
end


local data = {}
local db = database.connect()
local status, err = pcall(process, db, data)
db:close()


if status and data.redirectUrl then
	return ngx.redirect(data.redirectUrl)
else
	exceptionHandler.toCookie(err)
	return ngx.redirect(property.shopUrl .. property.cartUrl)
end