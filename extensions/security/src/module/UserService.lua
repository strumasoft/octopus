local property = require "property"
local uuid = require "uuid"
local cookie = require "cookie"
local exception = require "exception"
local util = require "util"
local fileutil = require "fileutil"
local crypto = require "crypto"


local function authenticate (db, email, password)
	local op = db:operators()

	if util.isNotEmpty(email) and util.isNotEmpty(password) then
		local user = db:findOne({user = {email = op.equal(email)}})

		-- failed authentication policy
		if user.failedLoginAttempts and user.failedLoginAttempts - property.failedLoginAttempts >= 0 then
			if user.lastFailedLoginTime then
				local elapsedTime = os.time() - user.lastFailedLoginTime
				if elapsedTime < 0 or elapsedTime < property.failedLoginAttemptsTimeout then
					user.token = "" -- terminate session
					user.lastFailedLoginTime = os.time()
					db:update({user = user})
					return
				end
			else
				user.token = "" -- terminate session
				user.lastFailedLoginTime = os.time()
				db:update({user = user})
				return
			end
		end
		
		local hash = crypto.passwordKey(password, crypto.decodeBase64(user.passwordSalt), 32)
		if hash == crypto.decodeBase64(user.passwordHash) then
			-- failed authentication policy
			user.failedLoginAttempts = 0
			user.lastFailedLoginTime = os.time()
			db:update({user = user})
			return user -- user is successfully authenticated!
		else
			-- failed authentication policy
			user.failedLoginAttempts = user.failedLoginAttempts + 1
			user.lastFailedLoginTime = os.time()
			if user.failedLoginAttempts >= property.failedLoginAttempts then user.token = "" end -- terminate session
			db:update({user = user})
			return
		end
	end
end


local function setToken (db, user)
	uuid.seed(db:timestamp())

	user.token = uuid()
	user.lastLoginTime = os.time()

	-- persist user's token and lastLoginTime
	db:update({user = user})

	-- set token in cookie
	local ok, err = cookie:set({
		key = "token",
		value = user.token,
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


--
-- NOTE: ngx.ctx.user holds the user for the whole request
--
local function authenticatedUser (db)
	local op = db:operators()

	if ngx.ctx.user then
		return ngx.ctx.user
	end

	local token, err = cookie:get("token")
	if util.isEmpty(token) or err then
		return false
	end

	local user = db:findOne({user = {token = op.equal(token)}})

	if util.isNotEmpty(user.lastLoginTime) then
		local elapsedTime = os.time() - user.lastLoginTime
		if elapsedTime >= 0 and elapsedTime <= property.sessionTimeout then
			ngx.ctx.user = user
			return user
		end
	end
end


local function authorize (db, user, permissions, groups)
	if permissions then
		for j=1,#permissions do
			-- try finding permission in user.permissions
			local filtered = user.permissions({code = permissions[j]})
			if #filtered == 0 then
				-- if not found yet search permission in user.groups
				local found = false
				for i=1,#user.groups do
					-- try finding permission in user.groups[i]
					local filtered = user.groups[i].permissions({code = permissions[j]})
					if #filtered > 0 then found = true end
				end
				if not found then return false end
			end
		end
	end

	if groups then
		for i=1,#groups do
			-- try finding group in user.groups
			local filtered = user.groups({code = groups[i]})
			if #filtered == 0 then return false end
		end
	end

	return true 
end


local function loginAndSetToken (db, email, password)
	local user = authenticate(db, email, password)
	if user then
		setToken(db, user)
		return true
	end

	return false
end


local function loggedIn (db, permissions, groups)
	local user = authenticatedUser(db)
	if user then
		return authorize(db, user, permissions, groups)
	end

	return false
end


local function register (db, email, password)
	local hash, salt = crypto.passwordKey(password, nil, 32)
	if util.isNotEmpty(hash) and util.isNotEmpty(salt) then
		local passwordHash = crypto.encodeBase64(hash)
		local passwordSalt = crypto.encodeBase64(salt)
		return db:add({user = {email = email, passwordHash = passwordHash, passwordSalt = passwordSalt}})
	end
end


local function registerAndSetToken (db, email, password)
	local op = db:operators()

	local id = register(db, email, password)

	local user = db:findOne({user = {id = op.equal(id)}})
	setToken(db, user)
end


local function redirectTo (url)
	local to

	local uri = ngx.var.uri
	if uri ~= url then
		to = uri:sub(url:len() + 1, uri:len())

		local args = ngx.var.args
		if util.isNotEmpty(args) then
			to = to .. "?" .. args
		end
	end

	return to
end


-- module table --
return {
	authenticate = authenticate,
	setToken = setToken,

	authenticatedUser = authenticatedUser,
	authorize = authorize,

	loginAndSetToken = loginAndSetToken,
	loggedIn = loggedIn,

	register = register,
	registerAndSetToken = registerAndSetToken,

	redirectTo = redirectTo,
}