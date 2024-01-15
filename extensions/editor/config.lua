local config = {} -- extension configuration

local editorHeaderStyleButton = [[style="font-size: 21px; padding-top: 5px;"></i>]]

config.frontend = {
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
	editorEditFileUrl = "/editFile",
	editorUploadFileUrl = "/uploadFile",
	editorDownloadFileUrl = "/downloadFile",
	
	compareUrl = "/compare",
	cryptographyUrl = "/cryptography",
	cryptographyEncrypt = "encrypt",
	cryptographyDecrypt = "decrypt",
	cryptographyHashPassword = "hashPassword",
	
	editorSaved = [[<i class="fa fa-lock" ]] .. editorHeaderStyleButton,
	editorUnsaved = [[<i class="fa fa-unlock" ]] .. editorHeaderStyleButton,
	editorSearchExpand = [[<i class="fa fa-expand" ]] .. editorHeaderStyleButton,
	editorSearchCompress = [[<i class="fa fa-compress" ]] .. editorHeaderStyleButton,
}

config.property = {
	fileUploadChunkSize = 8196,
}

config.location = {
	{name = property.editorUrl .. property.editorHomeUrl, script = "controller/EditorController.lua", access = "EditorRedirectOnSessionTimeoutFilter"},
	{name = property.editorUrl .. property.editorFileContentUrl, script = "controller/operation/FileContentController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.editorUrl .. property.editorDirectoryUrl, script = "controller/operation/DirectoryController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.editorUrl .. property.editorSaveUrl, script = "controller/operation/SaveController.lua", requestBody = "30M", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.editorUrl .. property.editorSearchUrl, script = "controller/EditorSearchController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.editorUrl .. property.editorRenameUrl, script = "controller/operation/RenameController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.editorUrl .. property.editorRemoveUrl, script = "controller/operation/RemoveController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.editorUrl .. property.editorCreateFileUrl, script = "controller/operation/CreateFileController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.editorUrl .. property.editorCreateDirectoryUrl, script = "controller/operation/CreateDirectoryController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.editorUrl .. property.editorEditFileUrl, script = "controller/EditorEditFileController.lua", access = "EditorRedirectOnSessionTimeoutFilter"},
	{name = property.editorUrl .. property.editorUploadFileUrl, script = "controller/EditorUploadFileController.lua", uploadBody = "30M", access = "EditorRedirectOnSessionTimeoutFilter"},
	{name = property.editorUrl .. property.editorDownloadFileUrl, script = "controller/EditorDownloadFileController.lua", access = "EditorRedirectOnSessionTimeoutFilter"},
	{name = property.editorUrl .. property.compareUrl, script = "controller/CompareController.lua", access = "EditorRedirectOnSessionTimeoutFilter"},
	{name = property.editorUrl .. property.cryptographyUrl, script = "controller/CryptographyController.lua", requestBody = true, access = "EditorRedirectOnSessionTimeoutFilter"},
}

config.access = {
	{name = "EditorRedirectOnSessionTimeoutFilter", script = "filter/EditorRedirectOnSessionTimeoutFilter.lua"},
	{name = "EditorThrowErrorOnSessionTimeoutFilter", script = "filter/EditorThrowErrorOnSessionTimeoutFilter.lua"},
}

config.javascript = {
	{name = "EditorTemplate", script = "controller/EditorTemplate.js"},
	{name = "Editor", script = "widget/Editor.js"},
	{name = "EditorNavigation", script = "widget/EditorNavigation.js"},
	{name = "EditorHeader", script = "widget/EditorHeader.js"},
	{name = "EditorSearchPopup", script = "widget/EditorSearchPopup.js"},
	{name = "EditorSearchResult", script = "widget/EditorSearchResult.js"},
	{name = "EditorSearchTemplate", script = "controller/EditorSearchTemplate.js"},
	{name = "EditorSearchHeader", script = "widget/EditorSearchHeader.js"},
	{name = "UploadResult", script = "widget/UploadResult.js"},
	{name = "CompareEditor", script = "widget/CompareEditor.js"},
	{name = "CompareTabs", script = "widget/CompareTabs.js"},
	{name = "CompareHeader", script = "widget/CompareHeader.js"},
	{name = "CryptographyTabs", script = "widget/CryptographyTabs.js"},
}

config.stylesheet = {
	{name = "EditorTemplate", script = "controller/EditorTemplate.css"},
	{name = "EditorNavigation", script = "widget/EditorNavigation.css"},
	{name = "EditorHeader", script = "widget/EditorHeader.css"},
}

config.module = {
	{name = "Directory", script = "module/Directory.lua"},
	{name = "Editor", script = "module/Editor.lua"}
}

config.static = {
	"static"
}

return config -- return extension configuration