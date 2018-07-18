local config = {} -- extension configuration

config.modules = {
	{name = "access", script = "access.lua"},
	--forbidstatic.lua
	{name = "htmltemplates", script = "htmltemplates.lua"},
	--javascripts.lua
	{name = "localization", script = "localization.lua"},
	--locations.lua
	{name = "modules", script = "modules.lua"},
	--parse.lua
	{name = "property", script = "property.lua"},
	--static.lua
	--stylesheets.lua
	{name = "tests", script = "tests.lua"},
	{name = "types", script = "types.lua"},
}

return config -- return extension configuration
