local param = require "param"
local property = require "property"
local uuid = require "uuid"
local cookie = require "cookie"
local exception = require "exception"
local countryService = require "countryService"



local localeCookieName = "locale"


local function getLocale (db)
    local locale, err = cookie:get(localeCookieName)
    if param.isEmpty(locale) or err then
        local country = countryService.getCountry(db)
        return country.locale
        --return property.defaultLocale
    else
        return locale
    end
end


local function setLocale (locale)
    -- set locale in cookie
    local ok, err = cookie:set({
        key = localeCookieName,
        value = locale,
        path = "/",
        domain = property.domain,
        --max_age = property.sessionTimeout,
        --secure = true,
        httponly = true
    })
    
    if not ok then
        exception(err)
    end
end


return {
    getLocale = getLocale,
    setLocale = setLocale
}