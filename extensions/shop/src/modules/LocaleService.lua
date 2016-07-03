local property = require "property"
local uuid = require "uuid"
local cookie = require "cookie"
local exception = require "exception"
local util = require "util"
local countryService = require "countryService"



local localeCookieName = "locale"


local function getLocale (db)
	local locale, err = cookie:get(localeCookieName)
	if util.isEmpty(locale) or err then
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
		domain = ngx.var.server_name,
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