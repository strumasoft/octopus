local config = {} -- extension configuration

config.property = {
	failedLoginAttempts = 7,
	failedLoginAttemptsTimeout = 10800, -- 3h

	securityLoginUrl = "/security/login",
	securityRegisterUrl = "/security/register",
	securityLoginUserUrl = "/security/loginUser",
	securityRegisterUserUrl = "/security/registerUser",
}

config.localization = {

}

config.location = {
	{name = property.securityLoginUrl, script = "controllers/SecurityLoginPageController.lua"},
	{name = property.securityRegisterUrl, script = "controllers/SecurityRegisterPageController.lua"},
	{name = property.securityLoginUserUrl, script = "controllers/SecurityLoginUserController.lua", requestBody = true},
	{name = property.securityRegisterUserUrl, script = "controllers/SecurityRegisterUserController.lua", requestBody = true},
}

config.javascript = {
	{name = "SecurityLoginForm", script = "widgets/LoginForm.js"},
	{name = "SecurityRegisterForm", script = "widgets/RegisterForm.js"},
}

config.stylesheet = {

}

config.modules = {
	{name = "testUser", script = "testUser.lua"},
	{name = "securityImport", script = "securityImport.lua"},
	{name = "userService", script = "modules/UserService.lua"}
}

config.static = {

}

config.types = {
	"types.lua"
}

return config -- return extension configuration