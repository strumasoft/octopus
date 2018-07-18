Widget.CallUs = function () {
	var data = {}

	this.data = data
	this.html = parse(function(){/*!
		<div class="row eshop-call-us">
			<div class="3u eshop-phone">
				<i class="fa fa-phone"></i>
			</div>
			<div class="9u">
				<h2>0123-456-789</h2>
				<p>free call orders 24/24h</p>
			</div>
		</div>
	*/}, data)
}

Widget.CallUs.prototype = {
	constructor: Widget.CallUs
}