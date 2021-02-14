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
	port = port,
	securePort = securePort,
	luaCodeCache = luaCodeCache,
	serverName = "localhost",
	errorLog = "error_log logs/error.log;",
	accessLog = "access_log logs/access.log;",
	includeDrop = "",
	maxBodySize = "50k",
	
	databaseConnection = {
		rdbms       =   rdbms,
		host        =   rdbms_host,
		port        =   rdbms_port,
		user        =   rdbms_user,
		password    =   rdbms_password,
		database    =   "demo",
		compact     =   false
	},

	globalParameters = {
		octopusHostDir = octopusHostDir,
		sourceCtxPath = "",
		requireSecurity = requireSecurity,
		sessionTimeout = sessionTimeout,
	},
}