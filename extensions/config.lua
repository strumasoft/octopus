return {
  extensions = {
    {octopusExtensionsDir, "core"}, 
    {octopusExtensionsDir, "baseline"}, 
    --{octopusExtensionsDir, "orm"}, -- luaorm is part of 'core'
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
    driver      =   rdbms_driver,
    host        =   rdbms_host,
    port        =   rdbms_port,
    user        =   rdbms_user,
    password    =   rdbms_password,
    database    =   rdbms_db,
    compact     =   false,
    usePreparedStatement = false,
    debugDB = true,
    charset = "utf8",
    max_packet_size = 1024 * 1024,
    ssl = false
  },

  globalParameters = {
    octopusHostDir = octopusHostDir,
    sourceCtxPath = "",
    requireSecurity = requireSecurity,
    sessionTimeout = sessionTimeout,
  },
}