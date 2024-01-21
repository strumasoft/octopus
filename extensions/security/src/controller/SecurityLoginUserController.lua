local json = require "json"
local property = require "property"
local database = require "database"
local util = require "util"
local userService = require "userService"



local parameters = util.parseForm(util.urldecode(ngx.req.get_body_data()))

local db = database.connect()
local ok, res = pcall(userService.loginAndSetToken, db, parameters.email, parameters.password)
db:close()

if ok and res then
  local to = userService.redirectTo(property.securityLoginUserUrl)

  if util.isNotEmpty(to) then
    return ngx.redirect(to)
  else
    ngx.say("successful login")
  end
else
  ngx.say("wrong credentials")
end