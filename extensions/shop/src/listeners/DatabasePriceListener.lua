return {
	before = {
		update = function ()
			ngx.log(ngx.ERR, "beforeUpdatePriceListener") 
		end
	},

	after = {
		update = function ()
			ngx.log(ngx.ERR, "afterUpdatePriceListener") 
		end,

		delete = function ()
			ngx.log(ngx.ERR, "afterDeletePriceListener") 
		end
	}
}