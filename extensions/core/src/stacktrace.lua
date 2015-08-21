return function (err)
    if not ngx then 
        print(err .. "\n\t" .. debug.traceback())
        return
    end
    
    if err then
        if type(err) == "table" then
            ngx.log(ngx.ERR, next(err) .. "\n\t" .. debug.traceback())
        else
            ngx.log(ngx.ERR, err .. "\n\t" .. debug.traceback())
        end
    else
        ngx.log(ngx.ERR, "\n\t" .. debug.traceback())
    end
end