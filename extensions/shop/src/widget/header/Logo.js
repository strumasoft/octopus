Widget.Logo = function () {
  var data = {logoUrl: property.shopUrl + property.shopHomeUrl}

  this.data = data
  this.html = parse(function(){/*!
    <div class="logo-image">
      <a href="{{@ property.shopUrl + property.shopHomeUrl}}" title="Web Shop Template">
        <img class="logo-img" src="/shop/static/logo.png" height="60px" />
      </a>
    </div>
  */}, data)
}

Widget.Logo.prototype = {
  constructor: Widget.Logo
}