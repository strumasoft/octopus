local json = require "json"
local parse = require "parse"
local param = require "param"
local property = require "property"
local localization = require "localization"
local database = require "database"
local exit = require "exit"
local exception = require "exception"
local exceptionHandler = require "exceptionHandler"
local util = require "util"
local localeService = require "localeService"
local priceService = require "priceService"
local cartService = require "cartService"



local function process (db, data)
  local op = db:operators()


  local locale = localeService.getLocale(db)
  data.locale = locale


  if util.isNotEmpty(param.paymentMethod) then
    local paymentMethod = db:findOne({paymentMethod = {id = op.equal(param.paymentMethod)}})

    local cart = cartService.getCart(db)
    cart.paymentMethod = paymentMethod
    db:update({cart = cart})
  else
    exception("paymentMethod is empty")
  end
end


local data = {}
local db = database.connect()
local ok, err = pcall(process, db, data)
db:close()


if ok then
  return ngx.redirect(property.shopUrl .. property.checkoutReviewOrderUrl)
else
  exceptionHandler.toCookie(err)
  return ngx.redirect(property.shopUrl .. property.checkoutPaymentMethodUrl)
end