Widget.MiniCart = function () {
	var data = {}
	
	this.data = data
	this.html = parse(function(){/*!
		<div id="eshop-cart" class="eshop-cart">
    		<div class="eshop-items">
    			<a>
    				<i class="fa fa-shopping-cart">&nbsp;</i>
    				<span>Shopping Cart</span>
    				<span id="eshop-cart-total" oldNumberOfProducts="0">0</span>
    			</a>
    		</div>
    		<div class="eshop-content">
    		    <div class="eshop-content-empty">
    				Your shopping cart is empty!
    			</div>
    		</div>
    	</div>
	*/}, data)
}

Widget.MiniCart.prototype = {
	constructor: Widget.MiniCart
}

Widget.MiniCart.updateNumberOfProducts = function () {
    var numberOfProducts = $("#eshop-cart-total")
    var oldNumber = parseInt(numberOfProducts.attr("oldNumberOfProducts"))
    numberOfProducts.attr("oldNumberOfProducts", oldNumber + 1)
    numberOfProducts.html(oldNumber + 1)
}