return function (err)
  if not ngx then 
    print(err .. "\n" .. debug.traceback())
    error(err)
  end

  if err then
    if type(err) == "table" then
      local json = require "json"
      ngx.log(ngx.ERR, json.encode(err) .. "\n" .. debug.traceback())
    else
      ngx.log(ngx.ERR, err .. "\n" .. debug.traceback())
    end
  else
    err = "error"
    ngx.log(ngx.ERR, err .. "\n" .. debug.traceback())
  end

  error(err)
end