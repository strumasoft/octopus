Widget.DatabaseTemplate = function (data) {
	this.data = data
	this.html = parse(function(){/*!
		<div id="main" class="container">
			<!-- Header -->
			{{header}}
		
			<div class="row">
				<div class="3u 12u(medium)">
					<div id="directoryNavigation">
						{{navigation}}
					</div>
				</div>
				<div class="9u 12u(medium)">
				    {{tabs}}
				</div>
			</div>
		</div>
	*/}, data)
}

Widget.DatabaseTemplate.prototype = {
	constructor: Widget.DatabaseTemplate
}

Widget.DatabaseTemplate.maxHeight = function () {
	return window.innerHeight - Widget.DatabaseHeader.height() - 30 + "px"
}