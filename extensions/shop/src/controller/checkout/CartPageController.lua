local json = require "json"
local parse = require "parse"
local param = require "param"
local property = require "property"
local localization = require "localization"
local database = require "database"
local exception = require "exception"
local exceptionHandler = require "exceptionHandler"
local localeService = require "localeService"
local priceService = require "priceService"
local cartService = require "cartService"



local function process (db, data)
  local locale = localeService.getLocale(db)
  data.locale = locale


  local cart = cartService.getCart(db)
  data.cart = cartService.convertCart(db, cart)


  data.checkoutUrl = property.shopUrl .. property.checkoutUrl
  data.checkoutMessage = localization.checkoutMessage[locale]


  exceptionHandler.fromCookieToData(data)
end


local data = {}
local db = database.connect()
local ok, err = pcall(process, db, data)
db:close()
if not ok then
  exceptionHandler.toData(data, err)
end


ngx.say(parse(require("BaselineHtmlTemplate"), {
  title = "Cart",
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

    vars.cart = {{cart}}

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
        {size: "6u", medium: "8u", small: "12u", widget: "<h2>Shopping Cart</h2>"}
      ],
      [
        {size: "12u", widget: new Widget.Cart({{cart}})}
      ],
      [
        {size: "3u -9u", medium: "6u -6u", small: "12u", widget: '<h1 class="button special"><a href={{checkoutUrl}}>{{checkoutMessage}}</a></h1>'}
      ]
    ]);
  ]], json.encodeProperties(data, {"checkoutMessage"}))
}))