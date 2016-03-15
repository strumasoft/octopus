Widget.DemoError = function (errors) {
	var data = {errors: errors}

	this.data = data
	this.html = parse(function(){/*!
		{{?@ data.errors instanceof Array
			<div id="errors">
			<div class="button" title="{{@localize("clickToClose")}}" onclick='Widget.DemoError.hide();'>
				<i class="fa fa-times"></i></div>
			{{# errors[i]
				<h2 class="hand" style="color: red;">{{errors[i]}}</h2>
			}}#
			</div>
		}}?
	*/}, data)
}

Widget.DemoError.prototype = {
	constructor: Widget.DemoError
}

Widget.DemoError.hide = function (guid) {
	$("#errors").hide()
}