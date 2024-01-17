local uuid = require "uuid"
local cookie = require "cookie"
local exception = require "exception"
local util = require "util"



local countryCookieName = "country"


--
-- NOTE: ngx.ctx.country holds country, currency and locale for the whole request
--
local function getCountry (db)
  local property = require "property"

  local op = db:operators()

  if ngx.ctx.country then
    return ngx.ctx.country
  end

  local countryIsocode, err = cookie:get(countryCookieName)
  if util.isEmpty(countryIsocode) or err then
    local country = db:findOne({country = {isocode = op.equal(property.defaultCountryIsocode)}})
    ngx.ctx.country = country
    return country
  else
    local country = db:findOne({country = {isocode = op.equal(countryIsocode)}})
    ngx.ctx.country = country
    return country
  end
end


local function setCountry (countryIsocode)
  --local property = require "property"

  -- set countryIsocode in cookie
  local ok, err = cookie:set({
    key = countryCookieName,
    value = countryIsocode,
    path = "/",
    domain = ngx.var.host,
    --max_age = property.sessionTimeout,
    --secure = true,
    httponly = true
  })

  if not ok then
    exception(err)
  end
end


return {
  getCountry = getCountry,
  setCountry = setCountry,
}