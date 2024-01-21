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
  if not cart.deliveryMethod then
    exceptionHandler.toCookie("cart does not have delivery method")
    data.redirectUrl = property.shopUrl .. property.checkoutDeliveryMethodUrl
    return
  end


  local paymentMethods = db:find({paymentMethod = {}}, {
    {name = {locale = locale}},
  })
  data.paymentMethods = paymentMethods


  exceptionHandler.fromCookieToData(data)
end


local data = {}
local db = database.connect()
local ok, err = pcall(process, db, data)
db:close()
if not ok then 
  exceptionHandler.toData(data, err)
end


if ok and data.redirectUrl then
  return ngx.redirect(data.redirectUrl)
end


ngx.say(parse(require("BaselineHtmlTemplate"), {
  title = "Checkout Payment Method",
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
        {size: "6u", medium: "8u", small: "12u", widget: "<h2>Checkout Payment Method</h2>"}
      ],
      [
        {size: "6u", medium: "8u", small: "12u", widget: new Widget.PaymentMethodForm({{paymentMethods}})}
      ]
    ]);
  ]], json.encodeProperties(data))
}))