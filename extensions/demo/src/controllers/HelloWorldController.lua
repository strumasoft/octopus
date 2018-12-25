local _ = require "template"
	
ngx.say(_.t1{
	_ = _,
	message1 = "Hello",
	message2 = "World",
	message3 = _.t2{
		message = "!!!"
	}
})