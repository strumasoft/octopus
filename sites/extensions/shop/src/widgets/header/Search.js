Widget.Search = function () {
	var data = {}

	this.data = data
	this.html = parse(function(){/*!
		<div class="row eshop-search">
			<div class="8u">
				<input class="search-field" type="text" name="keyword" value="" placeholder="Find a product...">
			</div>
			<div class="4u add-on">
				<i class="fa fa-question"></i>
			</div>
		</div>
	*/}, data)
}

Widget.Search.prototype = {
	constructor: Widget.Search
}