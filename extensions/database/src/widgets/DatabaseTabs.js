Widget.DatabaseTabs = function (data) {
	this.data = data
	this.html = parse(function(){/*!
		<div>
			{{# tabs[i]
				<div class="databaseTab" style="display: none"
					id="{{tabs[i].id}}">
					{{tabs[i].html}}
				</div>
			}}#
		</div>
	*/}, data)
}

Widget.DatabaseTabs.prototype = {
	constructor: Widget.DatabaseTabs
}