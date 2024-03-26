local config = {} -- extension configuration

config.property = {
  usePreparedStatement = true,
  debugDB = false,
}

config.module = {
  {name = "database", script = "database.lua"}, -- @deprecated > use luaorm > https://github.com/strumasoft/luaorm
  {name = "db.api.common", script = "db/api/common.lua"},
  {name = "db.api.mysql", script = "db/api/mysql.lua"},
  {name = "db.api.postgres", script = "db/api/postgres.lua"},
  {name = "db.driver.mysql", script = "db/driver/mysql.lua"},
  {name = "db.driver.postgres", script = "db/driver/postgres.lua"},
}


return config -- return extension configuration