Widget.ShopHeader = function (data) {
    data = data || {}
    
    data.homeUrl = property.shopUrl + property.shopHomeUrl
    data.accountUrl = property.shopUrl + property.accountUrl
    data.cartUrl = property.shopUrl + property.cartUrl
    data.checkoutUrl = property.shopUrl + property.checkoutUrl
    
	this.data = data
	this.html = parse(function(){/*!
		<header id="header" class="skel-layers-fixed">
			<nav id="nav">
				<ul>
				    <li><a class="button special hand" style="color: white;"
				        href="{{homeUrl}}">{{@localize("homeMessage")}}</a>
				    </li>
				    <li><a class="button special hand" style="color: white;"
				        href="{{accountUrl}}">{{@localize("accountMessage")}}</a>
				    </li>
				    <li><a class="button special hand" style="color: white;"
				        href="{{cartUrl}}">{{@localize("cartMessage")}}</a>
				    </li>
				    <li><a class="button special hand" style="color: white;"
				        href="{{checkoutUrl}}">{{@localize("checkoutMessage")}}</a>
				    </li>
				    
				    <li><img class="hand" border="0" 
				        src="/shop/static/bg_flag.gif" alt="bg flag"
				        onclick='Widget.ShopHeader.setCountry("BG");'>
				    </li>
				    <li><img class="hand" border="0" 
				        src="/shop/static/uk_flag.gif" alt="bg flag"
				        onclick='Widget.ShopHeader.setCountry("GB");'>
				    </li>
				</ul>
			</nav>
		</header>
	*/}, data)
}

Widget.ShopHeader.prototype = {
	constructor: Widget.ShopHeader
}

Widget.ShopHeader.setCountry = function (country) {
    $.get(property.shopUrl + property.changeCountryUrl, {country: country}, function(data) {
		location.reload()
	})
}