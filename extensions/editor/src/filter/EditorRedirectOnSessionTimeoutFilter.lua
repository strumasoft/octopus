local property = require "property"
local database = require "database"
local util = require "util"
local userService = require "userService"



-- security --
if property.requireSecurity then
  local db = database.connect()
  local status, res = pcall(userService.loggedIn, db, {}, {"codeEditor"})
  db:close()

  -- remove cache --
  ngx.ctx = {}

  if not status or not res then
    if util.isNotEmpty(ngx.var.args) then
      ngx.redirect(property.securityLoginUrl .. ngx.var.uri .. "?" .. ngx.var.args)
      ngx.exit(ngx.HTTP_OK)
    else
      ngx.redirect(property.securityLoginUrl .. ngx.var.uri)
      ngx.exit(ngx.HTTP_OK)
    end
  end
end