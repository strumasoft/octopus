Widget.CompareTabs = function () {
	var tabs = [
		{   
			guid: Widget.guid(),
			id: "oldfilecontent",
			name: "old",
			html: '<pre class="diffbox"></pre>'
		}, 
		{   
			guid: Widget.guid(),
			id: "newfilecontent",
			name: "new",
			html: '<pre class="diffbox"></pre>'
		}, 
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
		}
	]
	var data = {tabs: tabs}

	this.data = data
	this.html = parse(function(){/*!
		<div id="diffComparatorTabs">
			{{# tabs[i]
				<button class="button special diffComparatorButton"
					id="{{tabs[i].guid}}"
					onclick='Widget.CompareTabs.show("{{tabs[i].id}}", "{{tabs[i].guid}}")'>
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

Widget.CompareTabs.prototype = {
	constructor: Widget.CompareTabs
}

Widget.CompareTabs.show = function (id, guid) {
	$(".diffComparator").hide()
	$(".diffComparatorButton").css('text-decoration', 'none')

	$("#" + id).show()
	$("#" + guid).css('text-decoration', 'underline')
}