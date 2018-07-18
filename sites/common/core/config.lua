local config = {} -- extension configuration

config.modules = {
	{name = "builder", script = "builder.lua"},
	{name = "cookie", script = "cookie.lua"},
	{name = "crypto", script = "crypto.lua"},
	{name = "date", script = "date.lua"},
	{name = "eval", script = "eval.lua"},
	{name = "exception", script = "exception.lua"},
	{name = "exit", script = "exit.lua"},
	{name = "fileutil", script = "fileutil.lua"},
	{name = "http", script = "http.lua"},
	{name = "http_headers", script = "http_headers.lua"},
	{name = "json", script = "json.lua"},
	{name = "param", script = "param.lua"},
	{name = "parse", script = "parse.lua"},
	{name = "persistence", script = "persistence.lua"},
	{name = "stacktrace", script = "stacktrace.lua"},
	{name = "template", script = "template.lua"},
	{name = "upload", script = "upload.lua"},
	{name = "utf8", script = "utf8.lua"},
	{name = "utf8data", script = "utf8data.lua"},
	{name = "util", script = "util.lua"},
	{name = "uuid", script = "uuid.lua"},
}

config.javascripts = {
	{name = "parse", script = "js/parse.js"},
	{name = "widget", script = "js/widget.js"}
}

return config -- return extension configuration