local json = require "json"
local parse = require "parse"
local param = require "param"
local property = require "property"
local localization = require "localization"
local database = require "database"
local exception = require "exception"
local exceptionHandler = require "exceptionHandler"
local exit = require "exit"
local uuid = require "uuid"
local localeService = require "localeService"
local priceService = require "priceService"
local cartService = require "cartService"



local function process (db, data)
	local op = db:operators()


	local locale = localeService.getLocale(db)
	data.locale = locale


	local cart = cartService.getCart(db)
	if not cart.productEntries or not cart.address or not cart.deliveryMethod or not cart.paymentMethod then
		exceptionHandler.toCookie("cart does not have products/address/deliveryMethod/paymentMethod")
		data.redirectUrl = property.shopUrl .. property.cartUrl
		return
	end


	local order = db:findOne({cart = {id = op.equal(cart.id)}}, {
		"totalGrossPrice", 
		"totalNetPrice", 
		"totalVAT",
		{productEntries = {"unitPrice", "totalPrice", "product"}},
		"deliveryMethod",
		"paymentMethod",
		"address",
		"user",
	})

	uuid.seed(db:timestamp())
	order.code = uuid()
	order.creationTime = os.date("%Y-%m-%d %H:%M:%S")

	db:addAll({order = order}, {
		{productEntries = {"product"}},
		"deliveryMethod",
		"paymentMethod",
		"user", 
	})
end


local data = {}
local db = database.connect()
local status, err = pcall(process, db, data)
db:close()


if status then
	if data.redirectUrl then
		return ngx.redirect(data.redirectUrl)
	else
		return ngx.redirect(property.shopUrl .. property.checkoutConfirmationUrl)
	end
else
	exceptionHandler.toCookie(err)
	return ngx.redirect(property.shopUrl .. property.checkoutReviewOrderUrl)
end