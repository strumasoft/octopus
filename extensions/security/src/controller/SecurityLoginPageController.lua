local json = require "json"
local parse = require "parse"
local param = require "param"
local property = require "property"
local userService = require "userService"



local to = userService.redirectTo(property.securityLoginUrl)


local data = {to = to}


ngx.say(parse(require("BaselineHtmlTemplate"), {
	title = "Login",
	externalJS = [[
		<script type="text/javascript" src="/baseline/static/js/init-shop.js"></script>
	]],
	initJS = parse([[
		var vars = {}

		Widget.setContainerToPage([
			[
				{size: "6u", medium: "8u", small: "12u", widget: new Widget.LoginForm({to: {{to}}})}
			]
		]);
	]], json.encodeProperties(data))
}))