local json = require "json"
local parse = require "parse"
local property = require "property"
local localization = require "localization"
local exception = require "exception"
local param = require "param"
local productService = require "DemoProductService"



local function process (data)
	data.locale = "en"

	local productCode = param.code
	if productCode then
		local product = productService.getProduct(productCode)
		data.product = product
	else
		exception("product code required")
	end
end


local data = {}
local status, err = pcall(process, data)
if not status then 
	data.error = {err}
end


ngx.say(parse(require("BaselineHtmlTemplate"), {
	title = "Product Detail",
	externalJS = [[
		<script type="text/javascript" src="/baseline/static/js/init-shop.js"></script>
	]],
	externalCSS = [[

	]],
	initJS = parse([[
		var vars = {}

		vars.locale = {{locale}}

		Widget.setHeader(new Widget.DemoHeader())
		Widget.setContainerToPage([
			[
				{size: "12u", widget: new Widget.DemoError({{error}})}
			],
			[
				{size: "9u -3u", medium: "8u -4u", small: "12u", widget: new Widget.DemoProductDetail({{product}})}
			]
		])
		Widget.setFooter(new Widget.DemoFooter())
	]], json.encodeProperties(data))
}))