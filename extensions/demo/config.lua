local config = {} -- extension configuration

config.locations = {
    {name = "/", script = "controllers/IndexController.lua"},
	{name = "/hello", script = "controllers/HelloWorldController.lua"},
	{name = "/product", script = "controllers/ProductDetailController.lua"},
}

config.javascripts = {
	{name = "DemoProductDetail", script = "widgets/DemoProductDetail.js"},
	{name = "DemoError", script = "widgets/DemoError.js"},
	{name = "DemoHeader", script = "widgets/DemoHeader.js"},
	{name = "DemoFooter", script = "widgets/DemoFooter.js"},
}

config.stylesheets = {
	
}

config.modules = {
	{name = "DemoProductService", script = "modules/DemoProductService.lua"},
}

config.static = {
    "static"
}

config.types = {

}

config.tests = {

}

config.localization = {
    helloMessage = {en = "Hello World", bg = "Здравейте!!!!"},
    copyright = {
        en = "&copy; cyberz.eu. All rights reserved.", 
        bg = "&copy; cyberz.eu. Всички права запазени."},
    reload = {en = "Reload", bg = "Презареди"},
    showError = {en = "Show Error", bg = "Покажи Грешката"},
    addToCart = {en = "Buy", bg = "Купи"},
    clickToClose = {en = "click to close", bg = "натисни за да го скриеш"},
    noErrors = {en = "no errors", bg = "няма грешки"},
    index = {en = "Index", bg = "начало"},
}

return config -- return extension configuration