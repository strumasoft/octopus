local stacktrace = require "stacktrace"



return function (err)
    stacktrace(err)
    
    ngx.status = ngx.HTTP_INTERNAL_SERVER_ERROR
    
    if type(err) == "table" then
        ngx.say(next(err))
    else
        ngx.say(err)
    end
    
    ngx.exit(ngx.HTTP_OK)
end