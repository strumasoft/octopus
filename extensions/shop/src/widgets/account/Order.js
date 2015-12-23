Widget.Order = function (cart) {
    if (cart && cart.productEntries) {
        for (var i = 0; i < cart.productEntries.length; i++) {
            var product = cart.productEntries[i].product
            
            product.url = property.shopUrl + property.productUrl + "/" + product.code
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
						    <strong><span>{{cart.productEntries[i].quantity}}</span></strong>
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

Widget.Order.prototype = {
	constructor: Widget.Order
}