Widget.ProductDetail = function (product) {
    var data = {product: product, pictureWidth: property.pictureWidth, pictureHeight: property.pictureHeight}
	
	this.data = data
	this.html = parse(function(){/*!
	    <div class="row">
    	    <div class="5u 12u(medium)">
                <a href="{{product.pictures[0].content}}">
                    <img src="{{product.pictures[0].content}}" title="{{product.name[0].content}}" alt="{{product.name[0].content}}" width="{{pictureWidth}}" height="{{pictureHeight}}" />
                </a>
            </div>
     
            <div class="7u 12u(medium)">
                <h1>{{product.name[0].content}}</h1>
                
                <p>
                    <img src="/shop/static/stars-5.png" />
                    <a href="#reviews" style="cursor: pointer;">1 Reviews</a> | 
                    <a href="#reviews" style="cursor: pointer;">Write a review</a>
                </p>
                
                <address>
                    <strong>Product Code:</strong>
                    <span>{{product.code}}</span>
                </address>
                
                <h2>
                    <strong><span>{{product.prices[0]}}</span></strong>
                </h2>
                    
                <div class="product-cart">
                    <i class="fa fa-plus-square"></i>
                    <i class="fa fa-minus-square"></i>
                    
                    <button id="add-to-cart" class="button special" type="button"
                        onclick='Widget.Cart.add("{{product.code}}", 1);'>{{@localize("addToCart")}}</button>
                
                    <i class="fa fa-heart"></i>
                    <i class="fa fa-refresh"></i>
                    <i class="fa fa-question"></i>
                </div>    
            </div>
        </div>
        <!-- //row -->
        
        <div class="row">
            <div class="12u">
                <h3><span class="title-block">Description</span></h3>
                <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit</p>
            </div>
        </div>
        <!-- //row -->
        
        <div class="row">
            <div class="12u">
                <h3><span class="title-block">Reviews (1)</span></h3>
                <div class="rating">
                    <img src="/shop/static/stars-5.png" alt="" />
                </div>
                <div class="text">Aliquam a malesuada lorem. Nunc in porta.</div>
            </div>
        </div>
        <!-- //row -->
	*/}, data)
}

Widget.ProductDetail.prototype = {
	constructor: Widget.ProductDetail
}