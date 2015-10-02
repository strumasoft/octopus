return function (err)
    ngx.status = ngx.HTTP_INTERNAL_SERVER_ERROR
    
    if type(err) == "table" then
        local k,v = next(err)
        ngx.say(v)
    else
        ngx.say(err)
    end
    
    ngx.exit(ngx.HTTP_OK)
end