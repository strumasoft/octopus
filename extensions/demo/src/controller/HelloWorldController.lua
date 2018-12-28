local _ = require "template"

ngx.header.content_type = 'text/plain'

ngx.say(_.t1{
	_ = _, -- import template
	message1 = "Hello",
	message2 = "Worrld",
	message3 = "!!!",
})

ngx.say(_.t2{
	message = "gogo",
	logo = "$",
	array = {{1,2}, {3,4}, {5,6}},
	array2 = {7,8},
	array3 = {
		x = "X",
		y = "Y"
	},
    array4 = {},
})