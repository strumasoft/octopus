return {
	extensions = {
		{octopusExtensionsDir, "core"}, 
		{octopusExtensionsDir, "baseline"}, 
		{octopusExtensionsDir, "orm"}, 
		{octopusExtensionsDir, "security"}, 
		{octopusExtensionsDir, "editor"}, 
		{octopusExtensionsDir, "repository"}, 
		{octopusExtensionsDir, "database"}, 
		{octopusExtensionsDir, "shop"}, 
		{octopusExtensionsDir, "demo"},
	},
	
	octopusExtensionsDir = octopusExtensionsDir,
	octopusHostDir = octopusHostDir,
	port = 7878,
	securePort = 37878,
	luaCodeCache = "off",
	serverName = "localhost",
	errorLog = "error_log logs/error.log;",
	accessLog = "access_log logs/access.log;",
	includeDrop = [[#include drop.conf;]],
	maxBodySize = "50k",
	minifyJavaScript = false,
	minifyCommand = [[java -jar ../yuicompressor-2.4.8.jar %s -o %s]],
	
	databaseConnection = {
		rdbms       =   "postgres",
		host        =   "127.0.0.1",
		port        =   5432, 
		database    =   "demo",
		user        =   "demo",
		password    =   "demo",
		compact     =   false
	},

	globalParameters = {
		octopusHostDir = octopusHostDir,
		sourceCtxPath = "",
		requireSecurity = false,
		sessionTimeout = 3600,
	},
}