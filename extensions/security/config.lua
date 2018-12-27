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
	{name = property.securityLoginUrl, script = "controller/SecurityLoginPageController.lua"},
	{name = property.securityRegisterUrl, script = "controller/SecurityRegisterPageController.lua"},
	{name = property.securityLoginUserUrl, script = "controller/SecurityLoginUserController.lua", requestBody = true},
	{name = property.securityRegisterUserUrl, script = "controller/SecurityRegisterUserController.lua", requestBody = true},
}

config.javascript = {
	{name = "SecurityLoginForm", script = "widget/LoginForm.js"},
	{name = "SecurityRegisterForm", script = "widget/RegisterForm.js"},
}

config.stylesheet = {

}

config.module = {
	{name = "userService", script = "module/UserService.lua"},
	{name = "securityImport", script = "import.lua"},
}

config.static = {

}

config.type = {
	"types.lua"
}

return config -- return extension configuration