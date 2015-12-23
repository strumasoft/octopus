local json = require "dkjson"
local parse = require "parse"
local param = require "param"
local property = require "property"
local localization = require "localization"
local database = require "database"
local exit = require "exit"
local localeService = require "localeService"
local priceService = require "priceService"
local cartService = require "cartService"



local function process (db, data)
    local locale = localeService.getLocale(db)
    data.locale = locale
    
    
    local cart = cartService.updateProductEntry(db, param.productEntryId, param.quantity)
    data.cart = cartService.convertCart(db, cart)
end


local data = {}
local db = database.connect()
local status, err = pcall(process, db, data)
db:close()


if status then
    ngx.say(json.encode(data))
else
    exit(err)
end