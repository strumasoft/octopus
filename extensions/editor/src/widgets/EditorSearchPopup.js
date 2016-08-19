Widget.EditorSearchPopup = function (data) {
	data.proceedButtonGuid = Widget.guid()
	data.queryGuid = Widget.guid()
	data.replaceGuid = Widget.guid()
	data.filterGuid = Widget.guid()
	data.isRegexGuid = Widget.guid()
	data.isFileNameGuid = Widget.guid()
	data.isIgnoreCaseGuid = Widget.guid()

	var info = parse(function(){/*!
		{{?@ !isEmpty(data.info)
			<h1>{{info}}</h1>
		}}?

		<input class="space-down-popup-input" type="text" id="{{queryGuid}}" placeholder="Query" />
		
		<input type="radio" id="{{isRegexGuid}}" name="queryOptions" >
		<label for="{{isRegexGuid}}">Regex</label>

		<input type="radio" id="{{isIgnoreCaseGuid}}" name="queryOptions" >
		<label for="{{isIgnoreCaseGuid}}">Ignore Case</label>
		
		<br/>

		<input type="checkbox" id="{{isFileNameGuid}}" name="{{isFileNameGuid}}" >
		<label for="{{isFileNameGuid}}">File Name</label>

		<input class="space-down-popup-input" type="text" id="{{replaceGuid}}" placeholder="Replace" />

		<input class="space-down-popup-input" type="text" id="{{filterGuid}}" placeholder="Filter" />

		<br/>

		<a class="button" 
			onclick='vars.editorSearchPopup.delete()'>
			Close
		</a>
		<a class="button special"
			id="{{proceedButtonGuid}}"
			href="javascript:;" target="_blank"
			onclick='return vars.editorSearchPopup.proceed("{{proceedButtonGuid}}", "{{queryGuid}}", "{{replaceGuid}}", "{{filterGuid}}", "{{isRegexGuid}}", "{{isFileNameGuid}}", "{{isIgnoreCaseGuid}}")'>
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