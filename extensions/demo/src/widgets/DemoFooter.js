Widget.DemoFooter = function (data) {
	data = data || {}

	this.data = data
	this.html = parse(function(){/*!
		<footer id="footer">
			<div class="copyright">
				<strong class="main">{{@ localize("copyright")}}</strong>
			</div>
		</footer>
	*/}, data)
}

Widget.DemoFooter.prototype = {
	constructor: Widget.DemoFooter
}