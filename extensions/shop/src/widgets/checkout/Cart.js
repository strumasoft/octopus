Widget.Cart = function (cart) {
	if (cart && cart.productEntries) {
		for (var i = 0; i < cart.productEntries.length; i++) {
			var product = cart.productEntries[i].product

			product.url = property.shopUrl + property.productUrl + "/" + product.code
			product.quantityId = Widget.guid()
		}
	}

	var data = {cart: cart, pictureWidth: property.thumbnailPictureWidth, pictureHeight: property.thumbnailPictureHeight}

	this.data = data
	this.html = parse(function(){/*!
		<div class="table-wrapper">
			<table class="alt">
				<thead>
					<tr>
						<th>Picture</th>
						<th>Name</th>
						<th>Unit Price</th>
						<th>Quantity</th>
						<th>Total Price</th>
					</tr>
				</thead>
				<tbody>
					{{# cart.productEntries[i]
					<tr>
						<td>
							<a href="{{cart.productEntries[i].product.url}}">
								<img src="{{cart.productEntries[i].product.pictures[0].content}}" width="{{pictureWidth}}" height="{{pictureHeight}}" />
							</a>
						</td>
						<td>{{cart.productEntries[i].product.name[0].content}}</td>
						<td>
							<strong><span>{{cart.productEntries[i].unitPrice}}</span></strong>
						</td>
						<td>
							<input type="text" class="quantity"
								id="{{cart.productEntries[i].product.quantityId}}"
								value="{{cart.productEntries[i].quantity}}" />

							<div class="hand inline" onclick='Widget.Cart.update("{{cart.productEntries[i].product.quantityId}}", "{{cart.productEntries[i].id}}");'>
								&nbsp;<i class="fa fa-refresh"></i>
							</div>
							<div class="hand inline" onclick='Widget.Cart.update("{{cart.productEntries[i].product.quantityId}}", "{{cart.productEntries[i].id}}", 0);'>
								&nbsp;<i class="fa fa-times"></i>
							</div>
						</td>
						<td>
							<strong><span>{{cart.productEntries[i].totalPrice}}</span></strong>
						</td>
					</tr>
					}}#
				</tbody>
				<tfoot>
					<tr>
						<td colspan="4"></td>
						<td>
							Net Price: <strong><span>{{cart.totalNetPrice}}</span></strong>
						</td>
					</tr>
					<tr>
						<td colspan="4"></td>
						<td>
							VAT: <strong><span>{{cart.totalVAT}}</span></strong>
						</td>
					</tr>
					<tr>
						<td colspan="4"></td>
						<td>
							Gross Price: <strong><span>{{cart.totalGrossPrice}}</span></strong>
						</td>
					</tr>
				</tfoot>
			</table>
		</div>
	*/}, data)
}

Widget.Cart.prototype = {
	constructor: Widget.Cart
}

Widget.Cart.add = function (code, quantity) {
	if (!isEmpty(code) && !isEmpty(quantity) && quantity >= 0) {
		$.get(property.shopUrl + property.addToCartUrl, {productCode: code, quantity: quantity})
			.success(function (info) {
				var infoPopup = new Widget.InfoPopup({info: info})
			})
			.error(function(jqXHR, textStatus, errorThrown) {
				var infoPopup = new Widget.InfoPopup({info: jqXHR.responseText})
			})

		//Widget.MiniCart.updateNumberOfProducts()
	}
}

Widget.Cart.update = function (quantityId, productEntryId, quantity) {
	if (quantity != null) {
		quantity = parseInt(quantity)
		if (isNaN(quantity)) {
			var infoPopup = new Widget.InfoPopup({info: "enter valid quantity"})
			return
		}
	} else {
		quantity = parseInt($("#" + quantityId).val())
		if (isNaN(quantity)) {
			var infoPopup = new Widget.InfoPopup({info: "enter valid quantity"})
			return
		}
	}

	if (quantity >= 0) {
		$.get(property.shopUrl + property.updateProductEntryUrl, {productEntryId: productEntryId, quantity: quantity})
			.success(function (info) {
				location.reload()
			})
			.error(function(jqXHR, textStatus, errorThrown) {
				var infoPopup = new Widget.InfoPopup({info: jqXHR.responseText})
			})
	} else {
		var infoPopup = new Widget.InfoPopup({info: "enter valid quantity"})
	}
}