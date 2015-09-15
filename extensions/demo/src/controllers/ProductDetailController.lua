local json = require "dkjson"
local parse = require "parse"
local param = require "param"
local property = require "property"
local localization = require "localization"
local exception = require "exception"
local productService = require "ProductService"



local function process (data)
    data.locale = "en"
    
    
    local productCode
    local uries = param.split(ngx.var.uri, "/")
    
    if #uries < 3 then exception("product code required") end
    productCode = uries[#uries]
    
    if productCode then
        local product = productService.getProduct(productCode)
        data.product = product
    end
end


local data = {}
local status, err = pcall(process, data)
if not status then 
    exception.toData(data, err)
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
    	
    	Widget.setHeader(new Widget.Header())
        Widget.setContainerToPage([
        	[
        	    {size: "12u", widget: new Widget.Error({{error}})}
        	],
        	[
        	    {size: "9u -3u", medium: "8u -4u", small: "12u", widget: new Widget.ProductDetail({{product}})}
        	]
    	])
    	Widget.setFooter(new Widget.Footer())
    ]], json.encodeProperties(data))
}))