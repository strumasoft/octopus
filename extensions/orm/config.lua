local config = {} -- extension configuration

config.property = {
    usePreparedStatement = true,
}

config.modules = {
	{name = "database", script = "database.lua"},
	{name = "db.api.common", script = "db/api/common.lua"},
	{name = "db.api.mysql", script = "db/api/mysql.lua"},
	{name = "db.api.postgres", script = "db/api/postgres.lua"},
	{name = "db.driver.mysql", script = "db/driver/mysql.lua"},
	{name = "db.driver.postgres", script = "db/driver/postgres.lua"},
}


return config -- return extension configuration