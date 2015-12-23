Widget.DatabaseNavigation = function (types) {
	types = types || []
	
	for (var i = 0; i < types.length; i++) {types[i].guid = Widget.guid()}
	
	var filteredTypes = []
	for (var i = 0; i < types.length; i++) {
	    if (types[i].name.indexOf("-") < 0) {filteredTypes.push(types[i])}
	}

	var data = {types: filteredTypes}
	
	this.data = data
	this.html = parse(function(){/*!
		{{? types.length > 0
			<ul class="no-bullets">
				{{# types[i]
					<li class="file">
						<div id="{{types[i].guid}}" class="nowrap" 
						onclick='Widget.DatabaseNavigation.selectType("{{types[i].name}}", "{{types[i].guid}}")'>
							<i class="fa fa-database"></i>
							{{types[i].name}}
						</div>
					</li>
				}}#
			</ul>
		}}?
	*/}, data)
}

Widget.DatabaseNavigation.prototype = {
	constructor: Widget.DatabaseNavigation,
	
	init: function () {
		$("#directoryNavigation").css("max-height", Widget.DatabaseTemplate.maxHeight())
	}
}

Widget.DatabaseNavigation.selectType = function (type, guid) {
    Widget.DatabaseNavigation.selectFileName(guid)
    Widget.DatabaseNavigation.type = type
}

Widget.DatabaseNavigation.selectFileName = function (guid) {
	if (!isEmpty(editor.fileGuid)) {
	    $("#" + editor.fileGuid).css("font-weight", "normal")
	    $("#" + editor.fileGuid).css("color", property.mainColor)
	}
	
	editor.fileGuid = guid
	$("#" + editor.fileGuid).css("font-weight", "900")
	$("#" + editor.fileGuid).css("color", property.selectedColor)
}