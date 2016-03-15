local json = require "dkjson"
local parse = require "parse"
local param = require "param"
local property = require "property"
local localization = require "localization"
local database = require "database"
local exception = require "exception"
local localeService = require "localeService"
local priceService = require "priceService"



local function process (db, data)
	local op = db:operators()


	local locale = localeService.getLocale(db)
	data.locale = locale


	local productCode
	local uries = param.split(ngx.var.uri, "/")
	if property.productUrl == "/" .. uries[#uries - 1] then
		productCode = uries[#uries]
	end

	if productCode then
		local product = db:findOne({product = {code = op.equal(productCode)}}, {
			"pictures",
			"prices",
			{name = {locale = locale}}    
		})
		priceService.convertProductsPrices(db, product)
		data.product = product
	end
end


local data = {}
local db = database.connect()
local status, err = pcall(process, db, data)
db:close()
if not status then 
	exception.toData(data, err)
end


ngx.say(parse(require("BaselineHtmlTemplate"), {
	title = "Product Detail",
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
				{size: "9u -3u", medium: "8u -4u", small: "12u", widget: new Widget.ProductDetail({{product}})}
			]
		])
	]], json.encodeProperties(data))
}))