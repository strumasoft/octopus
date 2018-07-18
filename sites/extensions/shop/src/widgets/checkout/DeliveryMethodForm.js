Widget.DeliveryMethodForm = function (deliveryMethods) {
	var data = {deliveryMethods: deliveryMethods, action: property.shopUrl + property.checkoutSetDeliveryMethodUrl}

	this.data = data
	this.html = parse(function(){/*!
		<form method="get" action="{{action}}" onsubmit='return Widget.validateRadioButton("deliveryMethod");'>
			<div class="row uniform">
				{{# deliveryMethods[i]
					<div class="6u$ 8u$(medium) 12u$(small)">
						<input type="radio" id="deliveryMethod-{{deliveryMethods[i].id}}" name="deliveryMethod" value="{{deliveryMethods[i].id}}">
						<label for="deliveryMethod-{{deliveryMethods[i].id}}">{{deliveryMethods[i].description[0].content}}&nbsp;{{deliveryMethods[i].price}}</label>
					</div>
				}}#

				<div class="12u$">
					<ul class="actions">
						<li><input type="submit" value="{{@localize("continue")}}" /></li>
					</ul>
				</div>
			</div>
		</form>
	*/}, data)
}

Widget.DeliveryMethodForm.prototype = {
	constructor: Widget.DeliveryMethodForm
}