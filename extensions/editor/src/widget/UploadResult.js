Widget.UploadResult = function (files) {
	var data = {files: files}

	this.data = data
	this.html = parse(function(){/*!
		{{? files.length > 0
			<ul class="no-bullets">
				{{# files[i]
					<li class="file">
						<div id="{{files[i]}}" class="nowrap">
							<i class="fa fa-file-o"></i>
							{{files[i]}}
						</div>
					</li>
				}}#
			</ul>
		}}?
	*/}, data)
}

Widget.UploadResult.prototype = {
	constructor: Widget.UploadResult
}