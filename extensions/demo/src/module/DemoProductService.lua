local exception = require "exception"


local function getProduct (productCode)
  if productCode == "1" then
    return {
      code = "1",
      name = "Box",
      description = "Very good box",
      price = "$20",
      picture = "/demo/static/box.jpg",
      width = "300px",
      height = "300px",
    }
  else
    exception("product '" .. productCode .. "' not found")
  end
end


return {
  getProduct = getProduct,
}