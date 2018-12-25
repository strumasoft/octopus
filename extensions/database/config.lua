local config = {} -- extension configuration

config.property = {
	forbidDirectSqlQuery = true,
	
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

config.localization = {

}

config.location = {
	{name = property.databaseUrl .. property.databaseHomeUrl, script = "controllers/DatabaseController.lua", access = "DatabaseRedirectOnSessionTimeoutFilter"},
	{name = property.databaseUrl .. property.databaseExecuteUrl, script = "controllers/DatabaseExecuteController.lua", requestBody = true, access = "DatabaseThrowErrorOnSessionTimeoutFilter"},
	{name = property.databaseUrl .. property.databaseDeleteUrl, script = "controllers/DatabaseDeleteController.lua", requestBody = true, access = "DatabaseThrowErrorOnSessionTimeoutFilter"},
	{name = property.databaseUrl .. property.databaseDeleteReferenceUrl, script = "controllers/DatabaseDeleteReferenceController.lua", requestBody = true, access = "DatabaseThrowErrorOnSessionTimeoutFilter"},
	{name = property.databaseUrl .. property.databaseDeleteAllReferencesUrl, script = "controllers/DatabaseDeleteAllReferencesController.lua", requestBody = true, access = "DatabaseThrowErrorOnSessionTimeoutFilter"},
	{name = property.databaseUrl .. property.databaseAddUrl, script = "controllers/DatabaseAddController.lua", access = "DatabaseThrowErrorOnSessionTimeoutFilter"},
	{name = property.databaseUrl .. property.databaseAddReferenceUrl, script = "controllers/DatabaseAddReferenceController.lua", access = "DatabaseThrowErrorOnSessionTimeoutFilter"},
	{name = property.databaseUrl .. property.databaseEditUrl, script = "controllers/DatabaseEditController.lua", access = "DatabaseThrowErrorOnSessionTimeoutFilter"},
	{name = property.databaseUrl .. property.databaseSaveUrl, script = "controllers/DatabaseSaveController.lua", requestBody = true, access = "DatabaseThrowErrorOnSessionTimeoutFilter"}
}

config.access = {
	{name = "DatabaseRedirectOnSessionTimeoutFilter", script = "filter/DatabaseRedirectOnSessionTimeoutFilter.lua"},
	{name = "DatabaseThrowErrorOnSessionTimeoutFilter", script = "filter/DatabaseThrowErrorOnSessionTimeoutFilter.lua"},
}

config.javascript = {
	{name = "DatabaseTemplate", script = "controllers/DatabaseTemplate.js"},
	{name = "DatabaseNavigation", script = "widgets/DatabaseNavigation.js"},
	{name = "DatabaseHeader", script = "widgets/DatabaseHeader.js"},
	{name = "DatabaseEditor", script = "widgets/DatabaseEditor.js"},
	{name = "DatabaseTabs", script = "widgets/DatabaseTabs.js"},
	{name = "DatabaseResult", script = "widgets/DatabaseResult.js"},
	{name = "DatabaseEditObject", script = "widgets/DatabaseEditObject.js"}
}

config.stylesheet = {
	{name = "DatabaseTemplate", script = "controllers/DatabaseTemplate.css"},
	{name = "DatabaseNavigation", script = "widgets/DatabaseNavigation.css"},
	{name = "DatabaseHeader", script = "widgets/DatabaseHeader.css"},
}

config.modules = {
}

config.static = {
	"static"
}

return config -- return extension configuration