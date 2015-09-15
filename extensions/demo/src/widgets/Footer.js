Widget.Footer = function (data) {
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

Widget.Footer.prototype = {
	constructor: Widget.Footer
}