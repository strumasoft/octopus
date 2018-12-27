Widget.Error = function (errors) {
	var data = {errors: errors, guid: Widget.guid()}

	this.data = data
	this.html = parse(function(){/*!
		{{?@ data.errors instanceof Array
			<div id="{{guid}}">
			<div class="button" title="{{@localize("clickToClose")}}" onclick='Widget.Error.hide("{{guid}}");'>
				<i class="fa fa-times"></i></div>
			{{# errors[i]
				<h2 class="hand" style="color: red;">{{errors[i]}}</h2>
			}}#
			</div>
		}}?
	*/}, data)
}

Widget.Error.prototype = {
	constructor: Widget.Error
}

Widget.Error.hide = function (guid) {
	$("#" + guid).hide()
}