Widget.EditorSearchResult = function (filePaths) {
	var files = []

	if (filePaths != null) {
		for (var i = 0; i < filePaths.length; i++) {
			files[i] = {}
			files[i].guid = Widget.guid()
			files[i].path = filePaths[i]
		}
	}

	var data = {files: files}

	this.data = data
	this.html = parse(function(){/*!
		{{? files.length > 0
			<ul class="no-bullets">
				{{# files[i]
					<li class="file">
						<div id="{{files[i].guid}}" class="nowrap"
							onclick='Widget.EditorNavigation.openFile("{{files[i].path}}", "{{files[i].guid}}")'>
							<i class="fa fa-file-o"></i>
							{{files[i].path}}
						</div>
					</li>
				}}#
			</ul>
		}}?
	*/}, data)
}

Widget.EditorSearchResult.prototype = {
	constructor: Widget.EditorSearchResult
}