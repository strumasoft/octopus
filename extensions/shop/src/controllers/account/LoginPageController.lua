local json = require "json"
local parse = require "parse"
local property = require "property"
local localization = require "localization"
local database = require "database"
local exception = require "exception"
local util = require "util"
local userService = require "userService"
local localeService = require "localeService"
local priceService = require "priceService"
local cartService = require "cartService"



local function process (db, data)
	local locale = localeService.getLocale(db)
	data.locale = locale


	local to = userService.redirectTo(property.shopUrl .. property.loginUrl)
	if util.isNotEmpty(to) then
		data.to = to
	else
		data.to = property.shopUrl .. property.accountUrl
	end


	data.registerUrl = property.shopUrl .. property.registerUrl
end


local data = {}
local db = database.connect()
local status, err = pcall(process, db, data)
db:close()
if not status then 
	exception.toData(data, err)
end


ngx.say(parse(require("BaselineHtmlTemplate"), {
	title = "Login",
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
				{size: "6u", medium: "8u", small: "12u", widget: new Widget.LoginForm({to: {{to}}})}
			],
			[
				{size: "6u", medium: "8u", small: "12u", widget: '<h1 class="button special"><a href={{registerUrl}}>Register</a></h1>'}
			]
		]);
	]], json.encodeProperties(data))
}))