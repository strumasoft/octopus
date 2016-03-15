Widget.EditorTemplate = function (data) {
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
					{{editor}}
				</div>
			</div>
		</div>
	*/}, data)
}

Widget.EditorTemplate.prototype = {
	constructor: Widget.EditorTemplate,

	setDirectoryNavigation: function (html) {
		$("#directoryNavigation").html(html)
	}
}

Widget.EditorTemplate.maxHeight = function () {
	return window.innerHeight - Widget.EditorHeader.height() - 30 + "px"
}