Widget.AccountOptions = function (data) {
    this.data = data
	this.html = parse(function(){/*!
		<ul class="alt">
			<li><h4><a style="color: #49bf9d;" href="{{@ property.shopUrl + property.accountOrdersUrl}}">Orders</a></h4></li>
			<li><h4><a style="color: #49bf9d;" href="{{@ property.shopUrl + property.accountAddressesUrl}}">Addresses</a></h4></li>
			<li></li>
		</ul>
	*/}, data)
}

Widget.AccountOptions.prototype = {
	constructor: Widget.AccountOptions
}