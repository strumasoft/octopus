return function (err, status)
  ngx.status = status or ngx.HTTP_INTERNAL_SERVER_ERROR

  if type(err) == "table" then
    local json = require "json"
    ngx.say(json.encode(err))
  elseif err then
    ngx.say(err)
  end

  return ngx.exit(ngx.HTTP_OK)
end