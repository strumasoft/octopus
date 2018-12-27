local config = {} -- extension configuration

config.property = {
	debugRepo = false,
	
	redirectErrorToOutputStream = " 2>&1",

	repositoryUrl = "/repository",

	repositoryStatusUrl = "/status",
	repositoryFileHistoryUrl = "/fileHistory",
	repositoryLogHistoryUrl = "/logHistory",
	repositoryCommitHistoryUrl = "/commitHistory",
	repositoryFileRevisionContentUrl = "/fileRevisionContent",
	repositoryFileDiffUrl = "/fileDiff",
	repositoryCommitUrl = "/commit",
	repositoryUpdateUrl = "/update",
	repositoryRevertUrl = "/revert",
	repositoryAddUrl = "/add",
	repositoryDeleteUrl = "/delete",
	repositoryRefreshUrl = "/refresh",
	repositoryMergeUrl = "/merge",
}

config.location = {
	{name = property.repositoryUrl .. property.repositoryStatusUrl, script = "controller/RepositoryStatusController.lua", access = "EditorRedirectOnSessionTimeoutFilter"},
	{name = property.repositoryUrl .. property.repositoryFileHistoryUrl, script = "controller/RepositoryFileHistoryController.lua", access = "EditorRedirectOnSessionTimeoutFilter"},
	{name = property.repositoryUrl .. property.repositoryLogHistoryUrl, script = "controller/RepositoryLogHistoryController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.repositoryUrl .. property.repositoryCommitHistoryUrl, script = "controller/RepositoryCommitHistoryController.lua", access = "EditorRedirectOnSessionTimeoutFilter"},
	{name = property.repositoryUrl .. property.repositoryFileRevisionContentUrl, script = "controller/operation/FileRevisionContentController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.repositoryUrl .. property.repositoryFileDiffUrl, script = "controller/operation/FileDiffController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.repositoryUrl .. property.repositoryCommitUrl, script = "controller/operation/CommitController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.repositoryUrl .. property.repositoryUpdateUrl, script = "controller/operation/UpdateController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.repositoryUrl .. property.repositoryRevertUrl, script = "controller/operation/RevertController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.repositoryUrl .. property.repositoryAddUrl, script = "controller/operation/AddController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.repositoryUrl .. property.repositoryDeleteUrl, script = "controller/operation/DeleteController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.repositoryUrl .. property.repositoryRefreshUrl, script = "controller/operation/RefreshController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.repositoryUrl .. property.repositoryMergeUrl, script = "controller/operation/MergeController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
}

config.javascript = {
	{name = "RepositoryTemplate", script = "controller/RepositoryTemplate.js"},
	{name = "RepositoryStatusNavigation", script = "widget/RepositoryStatusNavigation.js"},
	{name = "RepositoryStatusHeader", script = "widget/RepositoryStatusHeader.js"},
	{name = "RepositoryFileHistoryNavigation", script = "widget/RepositoryFileHistoryNavigation.js"},
	{name = "RepositoryFileHistoryHeader", script = "widget/RepositoryFileHistoryHeader.js"},
	{name = "RepositoryDiff", script = "widget/RepositoryDiff.js"},
	{name = "RepositoryPatch", script = "widget/RepositoryPatch.js"},
	{name = "RepositoryLog", script = "widget/RepositoryLog.js"},
}

config.stylesheet = {
	{name = "RepositoryTemplate", script="controller/RepositoryTemplate.css"},
}

config.module = {
	{name = "SVN", script = "module/SVN.lua"},
	{name = "GIT", script = "module/GIT.lua"},
}

config.static = {
	"static"
}

return config -- return extension configuration