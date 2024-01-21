local json = require "json"
local parse = require "parse"
local property = require "property"
local localization = require "localization"
local database = require "database"
local exit = require "exit"
local exception = require "exception"
local exceptionHandler = require "exceptionHandler"
local util = require "util"
local userService = require "userService"
local localeService = require "localeService"
local priceService = require "priceService"
local cartService = require "cartService"



local function process (db, data)
  local op = db:operators()


  local locale = localeService.getLocale(db)
  data.locale = locale


  local cart = cartService.getCart(db)
  local user = userService.authenticatedUser(db)
  if user then
    local function addAddressTransaction ()
      local address = util.parseForm(util.urldecode(ngx.req.get_body_data()))
      address.user = user
      address.carts = {cart}
      db:add({address = address})

      user.addresses = nil -- refresh
    end

    local ok, res = pcall(db.transaction, db, addAddressTransaction)
    if not ok then exception("user=" .. user.id .. " => " .. res) end
  end
end


local data = {}
local db = database.connect()
local ok, err = pcall(process, db, data)
db:close()


if ok then
  return ngx.redirect(property.shopUrl .. property.checkoutDeliveryMethodUrl)
else
  exceptionHandler.toCookie(err)
  return ngx.redirect(property.shopUrl .. property.checkoutAddressUrl)
end