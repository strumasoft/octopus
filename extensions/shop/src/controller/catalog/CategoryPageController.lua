local json = require "json"
local parse = require "parse"
local property = require "property"
local localization = require "localization"
local database = require "database"
local exception = require "exception"
local exceptionHandler = require "exceptionHandler"
local util = require "util"
local localeService = require "localeService"
local priceService = require "priceService"



local function process (db, data)
  local op = db:operators()


  local locale = localeService.getLocale(db)
  data.locale = locale

  local rootCategory = db:findOne({category = {code = op.equal("root")}}, {
    {subcategories = {
      {name = {locale = locale}}
    }}
  })
  data.categories = rootCategory.subcategories


  local categoryCode
  local uries = util.split(ngx.var.uri, "/")
  if property.categoryUrl == "/" .. uries[#uries - 1] then
    categoryCode = uries[#uries]
  end

  if categoryCode then
    local category = db:findOne({category = {code = op.equal(categoryCode)}})

    if category.subcategories then
      data.subcategories = category.subcategories({
        {name = {locale = locale}}
      })
    end

    if category.products then
      local products = category.products({
        "pictures",
        "prices",
        {name = {locale = locale}}
      })
      priceService.convertProductsPrices(db, products)
      data.products = products
    end

    local productAttributes = db:find({productAttribute = {values = {products = {categories = {code = op.equal(categoryCode)}}}}}, {
      {values = {
        {name = {locale = locale}}    
      }},
      {name = {locale = locale}}
    })
    data.productAttributes = productAttributes
  end
end


local data = {}
local db = database.connect()
local ok, err = pcall(process, db, data)
db:close()
if not ok then 
  exceptionHandler.toData(data, err)
end


ngx.say(parse(require("BaselineHtmlTemplate"), {
  title = "Category Page",
  externalJS = [[
    <script type="text/javascript" src="/baseline/static/js/init-shop.js"></script>
  ]],
  externalCSS = [[
    <link href="/shop/static/favicon.ico" rel="shortcut icon" type="image/vnd.microsoft.icon" />

    <link rel="stylesheet" href="/shop/static/style.css" type="text/css" />
  ]],
  initJS = parse([[
    var vars = {}

    vars.locale = {{locale}}

    Widget.setContainerToPage([
      [
        {size: "12u", widget: new Widget.ShopHeader()}
      ],
      [
        {size: "3u", medium: "6u", small: "12u", widget: new Widget.Logo()},
        {size: "3u", medium: "6u", small: "12u", widget: new Widget.CallUs()},
        {size: "3u", medium: "6u", small: "12u", widget: new Widget.Search()},
        {size: "3u", medium: "6u", small: "12u", widget: new Widget.MiniCart()}
      ],
      [
        {size: "12u", widget: new Widget.Error({{error}})}
      ],
      [
        {size: "12u", widget: new Widget.HorizontalNavigation({{categories}})}
      ],
      [
        {size: "11u -1u", widget: new Widget.HorizontalNavigation({{subcategories}})}
      ],
      [
        {size: "3u", small: "12u", widget: new Widget.ProductAttributeFilter({{productAttributes}})},
        {size: "9u", small: "12u", widget: new Widget.ProductsGrid({{products}})}
      ]
    ])
  ]], json.encodeProperties(data))
}))