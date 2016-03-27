Widget.RepositoryDiff = function (data) {
	var tabs = [
		{   
			guid: Widget.guid(),
			id: "diffoutput",
			name: "diff",
			html: ''
		}, 
		{
			guid: Widget.guid(),
			id: "comparator",
			name: "match",
			html: '<pre class="diffbox"></pre>'
		},
		{
			guid: Widget.guid(),
			id: "patch",
			name: "patch",
			html: '<pre class="diffbox"></pre>'
		}
	]
	data.tabs = tabs

	this.data = data
	this.html = parse(function(){/*!
		<div id="diffComparatorTabs">
			{{# tabs[i]
				<button class="button special diffComparatorButton"
					id="{{tabs[i].guid}}"
					onclick='Widget.RepositoryDiff.show("{{tabs[i].id}}", "{{tabs[i].guid}}")'>
					{{tabs[i].name}}
				</button>
			}}#
		</div>

		<div>
			{{# tabs[i]
				<div class="diffComparator" style="display: none"
					id="{{tabs[i].id}}">
					{{tabs[i].html}}
				</div>
			}}#
		</div>
	*/}, data)
}

Widget.RepositoryDiff.prototype = {
	constructor: Widget.RepositoryDiff
}

Widget.RepositoryDiff.show = function (id, guid) {
	$(".diffComparator").hide()
	$(".diffComparatorButton").css("background-color", property.mainColor)

	$("#" + id).show()
	$("#" + guid).css("background-color", property.selectedColor)
}