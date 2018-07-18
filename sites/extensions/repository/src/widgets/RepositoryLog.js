Widget.RepositoryLog = function () {
	var data = {}

	this.data = data
	this.html = parse(function(){/*!
		<div>
			<div class="diffComparator">
				<pre id="repositoryLogContent" class="diffbox"></pre>
			</div>
		</div>
	*/}, data)
}

Widget.RepositoryLog.prototype = {
	constructor: Widget.RepositoryLog
}

Widget.RepositoryLog.setContent = function (content) {
	$('#repositoryLogContent').html(Widget.createHTML(content))
}