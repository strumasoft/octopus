local _ = require "template"

ngx.header.content_type = 'text/plain'

ngx.say(_.t2{
	message = "gogo",
	array = {{1,2}, {3,4}, {5,6}},
	array2 = {7,8},
	logo = "$"
})