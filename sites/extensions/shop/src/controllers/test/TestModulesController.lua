local parse = require "parse"
local json = require "json"
local param = require "param"



local page = parse(require("BaselineHtmlTemplate"), {
	title = "Test Modules"
})

ngx.say(page)