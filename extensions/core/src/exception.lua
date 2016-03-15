local json = require "dkjson"
local param = require "param"
local property = require "property"
local localization = require "localization"



local function exception (err, ...)
	if not ngx then 
		print(err .. "\n\t" .. debug.traceback())
		error(err)
	end

	if err then
		if type(err) == "table" then
			ngx.log(ngx.ERR, json.encode(err) .. "\n\t" .. debug.traceback())
		else
			local varargs = {...}

			local message = localization[err]
			if message then
				if #varargs > 0 then
					ngx.log(ngx.ERR, string.format(message.en, ...) .. "\n\t" .. debug.traceback())
				else
					ngx.log(ngx.ERR, message.en .. "\n\t" .. debug.traceback())
				end
			else
				if #varargs > 0 then
					ngx.log(ngx.ERR, string.format(err, ...) .. "\n\t" .. debug.traceback())
				else
					ngx.log(ngx.ERR, err .. "\n\t" .. debug.traceback())
				end
			end

			-- wrap evertying in object --
			err = {err}
			for i=1,#varargs do
				err[#err + 1] = varargs[i]
			end
		end
	else
		err = "error"
		ngx.log(ngx.ERR, err .. "\n\t" .. debug.traceback())
	end

	error(err)
end


local function getMessage (err, locale)
	if err then
		if type(err) == "table" then
			if #err > 0 then
				local args = {}
				for i=2,#err do
					args[#args + 1] = err[i]
				end

				local message = localization[err[1]]
				if message then
					return string.format(message[locale or "en"], unpack(args))
				else
					return string.format(err[1], unpack(args))
				end
			else
				return json.encode(err)
			end
		else
			local message = localization[err]
			if message then
				return message[locale or "en"]
			else
				return err
			end
		end
	else
		return "error"
	end
end


local function addError (data, err)
	if data.error then
		data.error[#data.error + 1] = getMessage(err, data.locale)
	else
		data.error = {getMessage(err, data.locale)}
	end
end


local function setErrorToCookie (errorMessage)
	local cookie = require "cookie"

	-- add error to cookie
	local ok, err = cookie:set({
		key = "error",
		value = ngx.encode_base64(json.encode(errorMessage)), -- encode message
		path = "/",
		domain = property.domain,
		max_age = property.sessionTimeout,
		secure = param.requireSecureToken(),
		httponly = true
	})

	if not ok then
		exception(err)
	end
end


--
-- get error from cookie (cookieName="error") and set it to data.error 
-- then remove error from cookie by setting max_age to 0
--
-- call it last, not before redirect otherwise it will be deleted!!!
--
local function getAndDeleteErrorFromCookie (data)
	local cookie = require "cookie"

	-- get error from cookie
	local errorMessage, err = cookie:get("error")
	if param.isEmpty(errorMessage) or err then
		return false
	end

	addError(data, json.decode(ngx.decode_base64(errorMessage))) -- decode message


	-- delete error from cookie
	local ok, err = cookie:set({
		key = "error",
		value = errorMessage,
		path = "/",
		domain = property.domain,
		max_age = 0,
		secure = param.requireSecureToken(),
		httponly = true
	})

	if not ok then
		exception(err)
	end
end


local M = {
	getMessage = getMessage,
	toData = addError,
	toCookie = setErrorToCookie,
	fromCookieToData = getAndDeleteErrorFromCookie,
}
setmetatable(M, {__call = function (t, ...) exception(...) end})
return M