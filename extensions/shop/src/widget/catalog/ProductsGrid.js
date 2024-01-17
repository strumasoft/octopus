Widget.ProductsGrid = function (products) {
  if (products) {
    for (var i = 0; i < products.length; i++) {
      products[i].url = property.shopUrl + property.productUrl + "/" + products[i].code
    }
  }

  var data = {products: products, pictureWidth: property.pictureWidth, pictureHeight: property.pictureHeight}

  this.data = data
  this.html = parse(function(){/*!
    {{? products.length > 0
      <div class="row">
      {{# products[i]
        <div class="4u 6u(medium) 12u(small)">
          <a href="{{products[i].url}}">
            <img src="{{products[i].pictures[0].content}}" width="{{pictureWidth}}" height="{{pictureHeight}}" />
          </a>
          <div class="row">
            <div class="6u -2u">
              {{products[i].name[0].content}}
            </div>
            <div class="4u">
              <strong>{{products[i].prices[0]}}</strong>
            </div>
          </div>
          <div class="row">
            <div class="-4u">
              <button id="add-to-cart" class="button special addToCart" type="button"
                onclick='Widget.Cart.add("{{products[i].code}}", 1);'>{{@localize("addToCart")}}</button>
            </div>
          </div>
        </div>
      }}#
      </div>
    }}?
  */}, data)
}

Widget.ProductsGrid.prototype = {
  constructor: Widget.ProductsGrid
}