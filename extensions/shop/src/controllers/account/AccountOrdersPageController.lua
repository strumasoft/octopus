local json = require "dkjson"
local parse = require "parse"
local param = require "param"
local property = require "property"
local localization = require "localization"
local database = require "database"
local exception = require "exception"
local userService = require "userService"
local localeService = require "localeService"
local priceService = require "priceService"
local cartService = require "cartService"



local function process (db, data)
    local locale = localeService.getLocale(db)
    data.locale = locale
    
    
    local user = userService.authenticatedUser(db)
    if user then
        ordersData = {}
        data.ordersData = ordersData
        
        ordersData.orders = user.orders
        ordersData.actionUrl = property.shopUrl .. property.accountOrderUrl
        ordersData.actionName = localization.viewOrder[locale]
    end
    
    
    exception.fromCookieToData(data)
end


local data = {}
local db = database.connect()
local status, err = pcall(process, db, data)
db:close()
if not status then 
    exception.toData(data, err)
end


ngx.say(parse(require("BaselineHtmlTemplate"), {
	title = "Account Orders",
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
        	    {size: "6u", medium: "8u", small: "12u", widget: "<h2>My Account</h2>"}
        	],
        	[
        	    {size: "3u", medium: "6u", small: "12u", widget: new Widget.AccountOptions()},
        	    {size: "9u", medium: "6u", small: "12u", widget: new Widget.Orders({{ordersData}})}
        	]
    	]);
    ]], json.encodeProperties(data))
}))