local config = {} -- extension configuration

config.property = {
    mainColor = "#49bf9d",
    selectedColor = "#1e90ff",
    
    editorUrl = "/editor",
    editorHomeUrl = "",
    
    editorFileContentUrl = "/fileContent",
    editorDirectoryUrl = "/directory",
    editorSaveUrl = "/save",
    editorSearchUrl = "/search",
    editorRenameUrl = "/rename",
    editorRemoveUrl = "/remove",
    editorCreateFileUrl = "/createFile",
    editorCreateDirectoryUrl = "/createDirectory",
}

config.locations = {
	{name = property.editorUrl .. property.editorHomeUrl, script = "controllers/EditorController.lua", access = "EditorRedirectOnSessionTimeoutFilter"},
	{name = property.editorUrl .. property.editorFileContentUrl, script = "controllers/operations/FileContentController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.editorUrl .. property.editorDirectoryUrl, script = "controllers/operations/DirectoryController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.editorUrl .. property.editorSaveUrl, script = "controllers/operations/SaveController.lua", requestBody = "10000k", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.editorUrl .. property.editorSearchUrl, script = "controllers/EditorSearchController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.editorUrl .. property.editorRenameUrl, script = "controllers/operations/RenameController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.editorUrl .. property.editorRemoveUrl, script = "controllers/operations/RemoveController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.editorUrl .. property.editorCreateFileUrl, script = "controllers/operations/CreateFileController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.editorUrl .. property.editorCreateDirectoryUrl, script = "controllers/operations/CreateDirectoryController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
}

config.access = {
    {name = "EditorRedirectOnSessionTimeoutFilter", script = "filter/EditorRedirectOnSessionTimeoutFilter.lua"},
    {name = "EditorThrowErrorOnSessionTimeoutFilter", script = "filter/EditorThrowErrorOnSessionTimeoutFilter.lua"},
}

config.javascripts = {
	{name = "EditorTemplate", script = "controllers/EditorTemplate.js"},
	{name = "Editor", script = "widgets/Editor.js"},
	{name = "EditorNavigation", script = "widgets/EditorNavigation.js"},
	{name = "EditorHeader", script = "widgets/EditorHeader.js"},
	{name = "EditorSearchPopup", script = "widgets/EditorSearchPopup.js"},
	{name = "EditorSearchResult", script = "widgets/EditorSearchResult.js"},
	{name = "EditorSearchTemplate", script = "controllers/EditorSearchTemplate.js"},
	{name = "EditorSearchHeader", script = "widgets/EditorSearchHeader.js"},
}

config.stylesheets = {
	{name = "EditorTemplate", script = "controllers/EditorTemplate.css"},
	{name = "EditorNavigation", script = "widgets/EditorNavigation.css"},
	{name = "EditorHeader", script = "widgets/EditorHeader.css"},
}

config.modules = {
	{name = "Directory", script = "modules/Directory.lua"},
	{name = "Editor", script = "modules/Editor.lua"}
}

config.static = {
    
}

return config -- return extension configuration