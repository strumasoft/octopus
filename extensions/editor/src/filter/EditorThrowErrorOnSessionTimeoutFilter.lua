local param = require "param"
local property = require "property"
local database = require "database"
local userService = require "userService"



-- security --
if property.requireSecurity then
  local db = database.connect()
  local status, res = pcall(userService.loggedIn, db, {}, {"codeEditor"})
  db:close()

  -- remove cache --
  ngx.ctx = {}

  if not status or not res then
    ngx.status = ngx.HTTP_FORBIDDEN
    ngx.say("ERROR: user not logged in")
    ngx.exit(ngx.HTTP_OK)
  end
end