Widget.EditorSearchPopup = function (data) {
	data.proceedButtonGuid = Widget.guid()
	data.queryGuid = Widget.guid()
	data.replaceGuid = Widget.guid()
	data.filterGuid = Widget.guid()
	data.isRegexGuid = Widget.guid()
	data.isFileNameGuid = Widget.guid()

	var info = parse(function(){/*!
		{{?@ !isEmpty(data.info)
			<h1>{{info}}</h1>
		}}?

		<input class="spaced-down" type="text" id="{{queryGuid}}" placeholder="Query" />

		<input class="spaced-down" type="text" id="{{replaceGuid}}" placeholder="Replace" />

		<input class="spaced-down" type="text" id="{{filterGuid}}" placeholder="Filter" />

		<input type="checkbox" id="{{isRegexGuid}}" name="{{isRegexGuid}}" >
		<label for="{{isRegexGuid}}">Regex</label>

		<br/>

		<input type="checkbox" id="{{isFileNameGuid}}" name="{{isFileNameGuid}}" >
		<label for="{{isFileNameGuid}}">File Name</label>

		<br/>

		<a class="button" 
			onclick='vars.editorSearchPopup.delete()'>
			Close
		</a>
		<a class="button special"
			id="{{proceedButtonGuid}}"
			href="javascript:;" target="_blank"
			onclick='return vars.editorSearchPopup.proceed("{{proceedButtonGuid}}", "{{queryGuid}}", "{{replaceGuid}}", "{{filterGuid}}", "{{isRegexGuid}}", "{{isFileNameGuid}}")'>
			Search / Replace
		</a>
	*/}, data)

	this.popup = new Widget.Popup({info: info})
	this.popup.proceed = data.proceed
	vars.editorSearchPopup = this.popup
	this.popup.init()
}

Widget.EditorSearchPopup.prototype = {
	constructor: Widget.EditorSearchPopup
}