local config = {} -- extension configuration

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

config.location = {
  {name = "/", script = "controller/IndexController.lua"},
  {name = "/hello", script = "controller/HelloWorldController.lua"},
  {name = "/product", script = "controller/ProductDetailController.lua"},
}

config.module = {
  {name = "DemoProductService", script = "module/DemoProductService.lua"},
}

config.html = {
  {name = "t1", script = "widget/DemoTemplate1.lua"},
  {name = "t2", script = "widget/DemoTemplate2.lua"},
}

config.javascript = {
  {name = "DemoProductDetail", script = "widget/DemoProductDetail.js"},
  {name = "DemoError", script = "widget/DemoError.js"},
  {name = "DemoHeader", script = "widget/DemoHeader.js"},
  {name = "DemoFooter", script = "widget/DemoFooter.js"},
}

config.stylesheet = {

}

config.static = {
  "static"
}

config.type = {

}

return config -- return extension configuration