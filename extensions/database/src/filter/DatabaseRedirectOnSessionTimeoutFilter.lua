local property = require "property"
local util = require "util"
local database = require "database"
local userService = require "userService"



-- security --
if property.requireSecurity then
  local db = database.connect()
  local ok, res = pcall(userService.loggedIn, db, {}, {"dbAdmin"})
  db:close()

  -- remove cache --
  ngx.ctx = {}

  if not ok or not res then
    if util.isNotEmpty(ngx.var.args) then
      ngx.redirect(property.securityLoginUrl .. ngx.var.uri .. "?" .. ngx.var.args)
      ngx.exit(ngx.HTTP_OK)
    else
      ngx.redirect(property.securityLoginUrl .. ngx.var.uri)
      ngx.exit(ngx.HTTP_OK)
    end
  end
end