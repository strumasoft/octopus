Widget.EditorSearchTemplate = function (data) {
	this.data = data
	this.html = parse(function(){/*!
		<div id="main" class="container">
			<!-- Header -->
			{{header}}

			<div class="row">
				<div class="12u" id="editorSearchTemplateNavigation">
					<div id="directoryNavigation">
						{{searchResult}}
					</div>
				</div>
				<div class="12u" id="editorSearchTemplateEditor">
					{{editor}}
				</div>
			</div>
		</div>
	*/}, data)

	// overide editor's maxHeight
	Widget.EditorTemplate.maxHeight = function () {
		var size = window.innerHeight < $("#main").height() ? $("#main").height() : window.innerHeight
		return size - Widget.EditorHeader.height() - 30 + "px"
	}
}

Widget.EditorSearchTemplate.prototype = {
	constructor: Widget.EditorSearchTemplate
}