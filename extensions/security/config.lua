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

config.locations = {
	{name = property.securityLoginUrl, script = "controllers/SecurityLoginPageController.lua"},
	{name = property.securityRegisterUrl, script = "controllers/SecurityRegisterPageController.lua"},
	{name = property.securityLoginUserUrl, script = "controllers/SecurityLoginUserController.lua", requestBody = true},
	{name = property.securityRegisterUserUrl, script = "controllers/SecurityRegisterUserController.lua", requestBody = true},
}

config.javascripts = {
	{name = "SecurityLoginForm", script = "widgets/LoginForm.js"},
	{name = "SecurityRegisterForm", script = "widgets/RegisterForm.js"},
}

config.stylesheets = {

}

config.modules = {
	{name = "testUser", script = "testUser.lua"},
	{name = "securityImport", script = "import.lua"},
	{name = "userService", script = "modules/UserService.lua"}
}

config.static = {

}

config.types = {
	"types.lua"
}

config.tests = {

}

return config -- return extension configuration