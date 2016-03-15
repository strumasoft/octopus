local json = require "dkjson"
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
	local op = db:operators()


	local locale = localeService.getLocale(db)
	data.locale = locale


	local rootCategory = db:findOne({category = {code = op.equal("root")}}, {
		{subcategories = {
			{name = {locale = locale}}
		}}
	})
	data.categories = rootCategory.subcategories


	local products = db:find({product = {}}, {
		"pictures",
		"prices",
		{name = {locale = locale}}
	})
	if products then
		priceService.convertProductsPrices(db, products)
		data.products = products
	end


	local productAttributes = db:find({productAttribute = {}}, {
		{values = {
			{name = {locale = locale}}    
		}},
		{name = {locale = locale}}
	})
	data.productAttributes = productAttributes
end


local data = {}
local db = database.connect()
local status, err = pcall(process, db, data)
db:close()
if not status then 
	exception.toData(data, err)
end


ngx.say(parse(require("BaselineHtmlTemplate"), {
	title = "Shop",
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
				{size: "12u", widget: new Widget.HorizontalNavigation({{categories}})}
			],
			[
				{size: "3u", small: "12u", widget: new Widget.ProductAttributeFilter({{productAttributes}})},
				{size: "9u", small: "12u", widget: new Widget.ProductsGrid({{products}})}
			]
		])

		//var bg = new Widget.Background()
	]], json.encodeProperties(data))
}))