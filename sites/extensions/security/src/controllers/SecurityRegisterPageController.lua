local json = require "json"
local parse = require "parse"
local param = require "param"
local property = require "property"
local userService = require "userService"



local data = {}


ngx.say(parse(require("BaselineHtmlTemplate"), {
	title = "Register",
	externalJS = [[
		<script type="text/javascript" src="/baseline/static/js/init-shop.js"></script>
	]],
	initJS = parse([[
		var vars = {}

		Widget.setContainerToPage([
			[
				{size: "6u", medium: "8u", small: "12u", widget: new Widget.RegisterForm({})}
			]
		]);
	]], json.encodeProperties(data))
}))