local uuid = require "uuid"
local cookie = require "cookie"
local exception = require "exception"
local uuid = require "uuid"
local util = require "util"
local userService = require "userService"
local localeService = require "localeService"
local countryService = require "countryService"
local priceService = require "priceService"



local cartCookieName = "cart"


local function setCartCookie (cartId)
  local property = require "property"
  
  -- set cartId in cookie
  local ok, err = cookie:set({
    key = cartCookieName,
    value = cartId,
    path = "/",
    domain = ngx.var.host,
    max_age = property.sessionTimeout,
    secure = util.requireSecureToken(),
    httponly = true
  })

  if not ok then
    exception(err)
  end
end


local function createCart (db)
  uuid.seed(db:timestamp())

  local cart = {code = uuid()}
  db:add({cart = cart})

  return cart
end


--
-- NOTE: ngx.ctx.cart holds cart for the whole request
--
local function getCart (db)
  local op = db:operators()

  if ngx.ctx.cart then
    return ngx.ctx.cart
  end

  local user = userService.authenticatedUser(db)
  if user then
    if user.carts and #user.carts > 0 then
      local cart = user.carts[#user.carts] -- get last cart

      ngx.ctx.cart = cart
      return cart
    else    
      local cart = createCart(db)
      setCartCookie(cart.code)

      user.carts = {cart}
      db:update({user = user})

      ngx.ctx.cart = cart
      return cart
    end
  else
    local cartCode, err = cookie:get(cartCookieName)
    if util.isNotEmpty(cartCode) and not err then
      local res = db:find({cart = {code = op.equal(cartCode)}})
      if #res > 0 then
        local cart = res[1] -- get first cart

        ngx.ctx.cart = cart
        return cart
      else    
        local cart = createCart(db)
        setCartCookie(cart.code)

        ngx.ctx.cart = cart
        return cart
      end
    else    
      local cart = createCart(db)
      setCartCookie(cart.code)

      ngx.ctx.cart = cart
      return cart
    end
  end
end


local function calculateCart (db, cart)
  local country = countryService.getCountry(db)
  local currencyIsocode = country.currency.isocode


  local function calculateCartTransaction ()
    local totalGrossPrice = 0
    local totalNetPrice = 0
    local totalVAT = 0

    if cart.productEntries then
      for i=1,#cart.productEntries do
        if cart.productEntries[i].product.prices then
          local price = priceService.calculateProductPrice(db, cart.productEntries[i].product, cart.productEntries[i].product.prices[1])


          -- calculate and persist entry prices --

          local unitPrice = price.value
          if cart.productEntries[i].unitPrice then
            cart.productEntries[i].unitPrice = {currencyIsocode = currencyIsocode, value = unitPrice, net = price.net, id = cart.productEntries[i].unitPrice.id}
            db:update({price = cart.productEntries[i].unitPrice})
          else
            cart.productEntries[i].unitPrice = {currencyIsocode = currencyIsocode, value = unitPrice, net = price.net}
            db:add({price = cart.productEntries[i].unitPrice})
          end

          local totalPrice = price.value * cart.productEntries[i].quantity
          if cart.productEntries[i].totalPrice then
            cart.productEntries[i].totalPrice = {currencyIsocode = currencyIsocode, value = totalPrice, net = price.net, id = cart.productEntries[i].totalPrice.id}
            db:update({price = cart.productEntries[i].totalPrice})
          else
            cart.productEntries[i].totalPrice = {currencyIsocode = currencyIsocode, value = totalPrice, net = price.net}
            db:add({price = cart.productEntries[i].totalPrice})
          end

          db:update({productEntry = cart.productEntries[i]})


          -- calculate cart total prices --

          totalVAT = totalVAT + price.vat * cart.productEntries[i].quantity
          if price.net then
            totalNetPrice = totalNetPrice + totalPrice
            totalGrossPrice = totalNetPrice
          else
            totalGrossPrice = totalGrossPrice + totalPrice
            totalNetPrice = totalGrossPrice - totalVAT
          end
        else
          exception("cart=" .. cart.id .. " => product.code=" .. cart.productEntries[i].product.code .. " has no prices")
        end
      end
    end


    -- persist cart total prices --

    if cart.totalGrossPrice then
      cart.totalGrossPrice = {currencyIsocode = currencyIsocode, value = totalGrossPrice, net = false, id = cart.totalGrossPrice.id}
      db:update({price = cart.totalGrossPrice})
    else
      cart.totalGrossPrice = {currencyIsocode = currencyIsocode, value = totalGrossPrice, net = false}
      db:add({price = cart.totalGrossPrice})
    end

    if cart.totalNetPrice then
      cart.totalNetPrice = {currencyIsocode = currencyIsocode, value = totalNetPrice, net = true, id = cart.totalNetPrice.id}
      db:update({price = cart.totalNetPrice})
    else
      cart.totalNetPrice = {currencyIsocode = currencyIsocode, value = totalNetPrice, net = true}
      db:add({price = cart.totalNetPrice})
    end

    if cart.totalVAT then
      cart.totalVAT = {currencyIsocode = currencyIsocode, value = totalVAT, id = cart.totalVAT.id}
      db:update({price = cart.totalVAT})
    else
      cart.totalVAT = {currencyIsocode = currencyIsocode, value = totalVAT}
      db:add({price = cart.totalVAT})
    end

    db:update({cart = cart})
  end


  local status, res = pcall(db.transaction, db, calculateCartTransaction)
  if not status then exception("cart=" .. cart.id .. " => " .. res) end

  return cart
end


local function addProductToCart (db, cart, product, quantity)
  db:add({productEntry = {
    quantity = quantity,
    product = product,
    cart = cart,
  }})

  -- calculate cart --
  cart.productEntries = nil -- force refresh productEntries
  calculateCart(db, cart)
  return cart
end


local function updateProductEntryWithQuantity (db, cart, productEntry, quantity, add)
  if add then
    productEntry.quantity = productEntry.quantity + quantity
    db:update({productEntry = productEntry})
  else  
    if quantity == 0 then
      db:delete({productEntry = {id = productEntry.id}})
    else
      productEntry.quantity = quantity
      db:update({productEntry = productEntry})
    end
  end

  -- calculate cart --
  cart.productEntries = nil -- force refresh productEntries
  calculateCart(db, cart)
  return cart
end


local function addToCart (db, productCode, quantity)
  local op = db:operators()

  quantity = tonumber(quantity) -- convert quantity to number

  if util.isNotEmpty(productCode) and util.isNotEmpty(quantity) and quantity > 0 then
    quantity = math.floor(quantity) -- get the integer from quantity

    local product = db:findOne({product = {code = op.equal(productCode)}})

    local cart = getCart(db)
    if cart.productEntries and #cart.productEntries > 0 then
      local productEntry
      for i=1,#cart.productEntries do
        if cart.productEntries[i].product.code == productCode then
          productEntry = cart.productEntries[i]
        end
      end

      if productEntry then
        return updateProductEntryWithQuantity(db, cart, productEntry, quantity, true) -- add quantity to productEntry
      else
        return addProductToCart(db, cart, product, quantity)
      end
    else
      return addProductToCart(db, cart, product, quantity)
    end
  else
    exception("productCode or quantity is not valid")
  end
end


local function updateProductEntry (db, productEntryId, quantity)
  quantity = tonumber(quantity) -- convert quantity to number

  if util.isNotEmpty(productEntryId) and util.isNotEmpty(quantity) and quantity >= 0 then
    quantity = math.floor(quantity) -- get the integer from quantity

    local cart = getCart(db)
    if cart.productEntries and #cart.productEntries > 0 then
      local productEntry
      for i=1,#cart.productEntries do
        if cart.productEntries[i].id == productEntryId then
          productEntry = cart.productEntries[i]
        end
      end

      if productEntry then
        return updateProductEntryWithQuantity(db, cart, productEntry, quantity, false) -- set quantity to productEntry
      else
        exception("cart=" .. cart.id .. " => productEntry.id=" .. productEntryId .. " does not exist")
      end
    else
      exception("cart=" .. cart.id .. " => productEntries are empty")
    end
  else
    exception("productEntryId or quantity is not valid")
  end
end


local function convertCart (db, cart)
  -- prerequisites
  local locale = localeService.getLocale(db)

  -- convert products
  cart = cart({
    {productEntries = {
      {product = {
        "pictures",
        {name = {locale = locale}}
      }},
    }},  
  })

  -- convert prices
  priceService.convertCartPrices(db, cart)

  return cart
end


return {
  getCart = getCart,
  addToCart = addToCart,
  updateProductEntry = updateProductEntry,
  calculateCart = calculateCart,
  convertCart = convertCart,
}