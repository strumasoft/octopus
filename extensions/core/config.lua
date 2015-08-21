local config = {} -- extension configuration

config.modules = {
	{name = "access", script = "access.lua"},
	{name = "cookie", script = "cookie.lua"},
	--autowire
	--builder
	{name = "databaseListeners", script = "databaseListeners.lua"},
	{name = "dkjson", script = "dkjson.lua"},
	{name = "eval", script = "eval.lua"},
	{name = "exception", script = "exception.lua"},
	{name = "exit", script = "exit.lua"},
	{name = "http", script = "http.lua"},
	{name = "http_headers", script = "http_headers.lua"},
	--javascripts
	{name = "localization", script = "localization.lua"},
	--locations
	{name = "modules", script = "modules.lua"},
	{name = "param", script = "param.lua"},
	{name = "parse", script = "parse.lua"},
	{name = "persistence", script = "persistence.lua"},
	{name = "property", script = "property.lua"},
	{name = "stacktrace", script = "stacktrace.lua"},
	--static
	--stylesheets
	--template
	{name = "tests", script = "tests.lua"},
	{name = "types", script = "types.lua"},
	{name = "util", script = "util.lua"},
	{name = "uuid", script = "uuid.lua"},
}

config.javascripts = {
	{name = "parse", script = "js/parse.js"},
	{name = "widget", script = "js/widget.js"}
}

return config -- return extension configuration