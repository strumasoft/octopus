return {

	user = {
		email               =   {type = "string", unique = true},
		passwordSalt        =   "string",
		passwordHash        =   "string",
		token               =   "string",
		lastLoginTime       =   "integer",
		lastFailedLoginTime =   "integer",
		failedLoginAttempts =   "integer",
		groups              =   hasMany("userGroup", "users"),
		permissions         =   hasMany("userPermission", "users")
	},

	userGroup = {
		code                =   {type = "string", unique = true},
		users               =   hasMany("user", "groups"),
		permissions         =   hasMany("userPermission", "groups")
	},

	userPermission = {
		code                =   {type = "string", unique = true},
		users               =   hasMany("user", "permissions"),
		groups              =   hasMany("userGroup", "permissions")
	},
}