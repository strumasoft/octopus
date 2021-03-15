local config = {} -- extension configuration

config.frontend = {
	mainColor = "#49bf9d",
	selectedColor = "#1e90ff",

	databaseUrl = "/database",
	databaseHomeUrl = "",

	databaseExecuteUrl = "/execute",
	databaseDeleteUrl = "/delete",
	databaseDeleteReferenceUrl = "/deleteReference",
	databaseDeleteAllReferencesUrl = "/deleteAllReferences",
	databaseAddUrl = "/add",
	databaseAddReferenceUrl = "/addReference",
	databaseEditUrl = "/edit",
	databaseSaveUrl = "/save",
}

config.property = {
	forbidDirectSqlQuery = true,
}

config.localization = {

}

config.location = {
	{name = property.databaseUrl .. property.databaseHomeUrl, script = "controller/DatabaseController.lua", access = "DatabaseRedirectOnSessionTimeoutFilter"},
	{name = property.databaseUrl .. property.databaseExecuteUrl, script = "controller/DatabaseExecuteController.lua", requestBody = true, access = "DatabaseThrowErrorOnSessionTimeoutFilter"},
	{name = property.databaseUrl .. property.databaseDeleteUrl, script = "controller/DatabaseDeleteController.lua", requestBody = true, access = "DatabaseThrowErrorOnSessionTimeoutFilter"},
	{name = property.databaseUrl .. property.databaseDeleteReferenceUrl, script = "controller/DatabaseDeleteReferenceController.lua", requestBody = true, access = "DatabaseThrowErrorOnSessionTimeoutFilter"},
	{name = property.databaseUrl .. property.databaseDeleteAllReferencesUrl, script = "controller/DatabaseDeleteAllReferencesController.lua", requestBody = true, access = "DatabaseThrowErrorOnSessionTimeoutFilter"},
	{name = property.databaseUrl .. property.databaseAddUrl, script = "controller/DatabaseAddController.lua", access = "DatabaseThrowErrorOnSessionTimeoutFilter"},
	{name = property.databaseUrl .. property.databaseAddReferenceUrl, script = "controller/DatabaseAddReferenceController.lua", access = "DatabaseThrowErrorOnSessionTimeoutFilter"},
	{name = property.databaseUrl .. property.databaseEditUrl, script = "controller/DatabaseEditController.lua", access = "DatabaseThrowErrorOnSessionTimeoutFilter"},
	{name = property.databaseUrl .. property.databaseSaveUrl, script = "controller/DatabaseSaveController.lua", requestBody = true, access = "DatabaseThrowErrorOnSessionTimeoutFilter"}
}

config.access = {
	{name = "DatabaseRedirectOnSessionTimeoutFilter", script = "filter/DatabaseRedirectOnSessionTimeoutFilter.lua"},
	{name = "DatabaseThrowErrorOnSessionTimeoutFilter", script = "filter/DatabaseThrowErrorOnSessionTimeoutFilter.lua"},
}

config.javascript = {
	{name = "DatabaseTemplate", script = "controller/DatabaseTemplate.js"},
	{name = "DatabaseNavigation", script = "widget/DatabaseNavigation.js"},
	{name = "DatabaseHeader", script = "widget/DatabaseHeader.js"},
	{name = "DatabaseEditor", script = "widget/DatabaseEditor.js"},
	{name = "DatabaseTabs", script = "widget/DatabaseTabs.js"},
	{name = "DatabaseResult", script = "widget/DatabaseResult.js"},
	{name = "DatabaseEditObject", script = "widget/DatabaseEditObject.js"}
}

config.stylesheet = {
	{name = "DatabaseTemplate", script = "controller/DatabaseTemplate.css"},
	{name = "DatabaseNavigation", script = "widget/DatabaseNavigation.css"},
	{name = "DatabaseHeader", script = "widget/DatabaseHeader.css"},
}

config.module = {
}

config.static = {
	"static"
}

return config -- return extension configuration