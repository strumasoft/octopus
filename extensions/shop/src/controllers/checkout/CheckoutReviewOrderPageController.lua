local json = require "json"
local parse = require "parse"
local param = require "param"
local property = require "property"
local localization = require "localization"
local database = require "database"
local exception = require "exception"
local localeService = require "localeService"
local priceService = require "priceService"
local cartService = require "cartService"



local function process (db, data)
	local locale = localeService.getLocale(db)
	data.locale = locale


	local cart = cartService.getCart(db)
	if not cart.paymentMethod then
		exception.toCookie("cart does not have payment method")
		data.redirectUrl = property.shopUrl .. property.checkoutPaymentMethodUrl
		return
	end


	data.cart = cartService.convertCart(db, cart)


	data.placeOrderUrl = property.shopUrl .. property.checkoutPlaceOrderUrl
	data.placeOrderMessage = localization.placeOrder[locale]


	exception.fromCookieToData(data)
end


local data = {}
local db = database.connect()
local status, err = pcall(process, db, data)
db:close()
if not status then 
	exception.toData(data, err)
end


if status and data.redirectUrl then
	return ngx.redirect(data.redirectUrl)
end


ngx.say(parse(require("BaselineHtmlTemplate"), {
	title = "Review Order",
	externalJS = [[
		<script type="text/javascript" src="/baseline/static/js/init-shop.js"></script>
	]],
	externalCSS = [[
		<link href="/shop/static/favicon.ico" rel="shortcut icon" type="image/vnd.microsoft.icon" />

		<link rel="stylesheet" href="/shop/static/style.css" type="text/css" />
	]],
	initJS = parse([[
		var vars = {}

		vars.locale = {{locale}}

		Widget.setContainerToPage([
			[
				{size: "12u", widget: new Widget.ShopHeader()}
			],
			[
				{size: "3u", medium: "6u", small: "12u", widget: new Widget.Logo()},
				{size: "3u", medium: "6u", small: "12u", widget: new Widget.CallUs()},
				{size: "3u", medium: "6u", small: "12u", widget: new Widget.Search()},
				{size: "3u", medium: "6u", small: "12u", widget: new Widget.MiniCart()}
			],
			[
				{size: "12u", widget: new Widget.Error({{error}})}
			],
			[
				{size: "6u", medium: "8u", small: "12u", widget: "<h2>Review Order</h2>"}
			],
			[
				{size: "12u", widget: new Widget.Cart({{cart}})}
			],
			[
				{size: "3u -9u", medium: "6u -6u", small: "12u", widget: '<h1 class="button special"><a href={{placeOrderUrl}}>{{placeOrderMessage}}</a></h1>'}
			]
		]);
	]], json.encodeProperties(data, {"placeOrderMessage"}))
}))