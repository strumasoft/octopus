Widget.EditorSearchTemplate = function (data) {
	this.data = data
	this.html = parse(function(){/*!
		<div id="main" class="container">
			<!-- Header -->
			{{header}}

			<div class="row">
				<div class="3u 12u(medium)" id="editorSearchTemplateNavigation">
					<div id="directoryNavigation">
						{{searchResult}}
					</div>
				</div>
				<div class="9u 12u(medium)" id="editorSearchTemplateEditor">
					{{editor}}
				</div>
			</div>
		</div>
	*/}, data)
}

Widget.EditorSearchTemplate.prototype = {
	constructor: Widget.EditorSearchTemplate
}