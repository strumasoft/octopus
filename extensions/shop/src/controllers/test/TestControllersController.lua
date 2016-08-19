local parse = require "parse"
local json = require "json"
local param = require "param"


local externalJS = [[
	<script type="text/javascript" src="/static/tests.js"></script>
]]


local initJS = [[
	executeTests()
]]


local page = parse(require("BaselineHtmlTemplate"), {
	title = "Test Controllers",
	externalJS = externalJS,
	initJS = initJS
})

ngx.say(page)