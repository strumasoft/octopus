local parse = require "parse"
local json = require "json"
local param = require "param"


local internalJS = [[
	<script type="text/javascript" src="/static/tests.js"></script>
]]


local initJS = [[
	executeTests()
]]


local page = parse(require("BaselineHtmlTemplate"), {
	title = "Test Controllers",
	internalJS = internalJS,
	initJS = initJS
})

ngx.say(page)