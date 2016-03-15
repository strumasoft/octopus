Widget.Orders = function (data) {
	this.data = data
	this.html = parse(function(){/*!
		<form method="get" action="{{actionUrl}}" onsubmit='return Widget.validateRadioButton("order");'>
			<div class="row uniform">
				{{# orders[i]
					<div class="6u$ 8u$(medium) 12u$(small)">
						<input type="radio" id="order-{{orders[i].id}}" name="order" value="{{orders[i].id}}">
						<label for="order-{{orders[i].id}}">{{orders[i].creationTime}}</label>
					</div>
				}}#

				<div class="12u$">
					<ul class="actions">
						<li><input type="submit" value="{{actionName}}" /></li>
					</ul>
				</div>
			</div>
		</form>
	*/}, data)
}

Widget.Orders.prototype = {
	constructor: Widget.Orders
}