local util = require "util"


local m = {} -- module

setmetatable(m, { 
	__index = function (table, key)
		local x = ngx.var["arg_" .. key]
		if x then
			return util.unescape(x)
		else
			return nil
		end
	end 
	}
)

return m -- return module