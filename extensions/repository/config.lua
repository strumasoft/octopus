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
	{name = property.repositoryUrl .. property.repositoryStatusUrl, script = "controllers/RepositoryStatusController.lua", access = "EditorRedirectOnSessionTimeoutFilter"},
	{name = property.repositoryUrl .. property.repositoryFileHistoryUrl, script = "controllers/RepositoryFileHistoryController.lua", access = "EditorRedirectOnSessionTimeoutFilter"},
	{name = property.repositoryUrl .. property.repositoryLogHistoryUrl, script = "controllers/RepositoryLogHistoryController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.repositoryUrl .. property.repositoryCommitHistoryUrl, script = "controllers/RepositoryCommitHistoryController.lua", access = "EditorRedirectOnSessionTimeoutFilter"},
	{name = property.repositoryUrl .. property.repositoryFileRevisionContentUrl, script = "controllers/operations/FileRevisionContentController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.repositoryUrl .. property.repositoryFileDiffUrl, script = "controllers/operations/FileDiffController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.repositoryUrl .. property.repositoryCommitUrl, script = "controllers/operations/CommitController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.repositoryUrl .. property.repositoryUpdateUrl, script = "controllers/operations/UpdateController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.repositoryUrl .. property.repositoryRevertUrl, script = "controllers/operations/RevertController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.repositoryUrl .. property.repositoryAddUrl, script = "controllers/operations/AddController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.repositoryUrl .. property.repositoryDeleteUrl, script = "controllers/operations/DeleteController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.repositoryUrl .. property.repositoryRefreshUrl, script = "controllers/operations/RefreshController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
	{name = property.repositoryUrl .. property.repositoryMergeUrl, script = "controllers/operations/MergeController.lua", access = "EditorThrowErrorOnSessionTimeoutFilter"},
}

config.javascript = {
	{name = "RepositoryTemplate", script = "controllers/RepositoryTemplate.js"},
	{name = "RepositoryStatusNavigation", script = "widgets/RepositoryStatusNavigation.js"},
	{name = "RepositoryStatusHeader", script = "widgets/RepositoryStatusHeader.js"},
	{name = "RepositoryFileHistoryNavigation", script = "widgets/RepositoryFileHistoryNavigation.js"},
	{name = "RepositoryFileHistoryHeader", script = "widgets/RepositoryFileHistoryHeader.js"},
	{name = "RepositoryDiff", script = "widgets/RepositoryDiff.js"},
	{name = "RepositoryPatch", script = "widgets/RepositoryPatch.js"},
	{name = "RepositoryLog", script = "widgets/RepositoryLog.js"},
}

config.stylesheet = {
	{name = "RepositoryTemplate", script="controllers/RepositoryTemplate.css"},
}

config.modules = {
	{name = "SVN", script = "modules/SVN.lua"},
	{name = "GIT", script = "modules/GIT.lua"},
}

config.static = {
	"static"
}

return config -- return extension configuration