Widget.EditorSearchHeader = function (title) {
	var data = {title: title}

	this.data = data
	this.html = parse(function(){/*!
		<header id="header" class="skel-layers-fixed">
			<h1><div id="menu" class="hand">{{title}}</div></h1>
			<nav id="nav">
				<ul>
					<!-- View History -->
					<li><a id="repositoryFileHistoryAction" class="hand" style="color: white;" 
						href="javascript:;" target="_blank"
						onclick='return Widget.EditorHeader.repositoryFileHistory();'>
						<i class="fa fa-eye"></i> <i class="fa fa-file-o"></i></a>
					</li>
					
					<!-- Remove -->
					<li><div id="removeFileAction" class="hand" 
						onclick='Widget.EditorHeader.removeFileName();'>
						<i class="fa fa-minus"></i> <i class="fa fa-file-o"></i></div>
					</li>
					
					<!-- Edit -->
					<li><div id="editFileAction" class="hand" 
						onclick='Widget.EditorSearchHeader.editFile();'>
						<i class="fa fa-pencil-square-o"></i></div>
					</li>

					<!-- Save -->
					<li><div id="saveAction" class="button special" 
						onclick='Widget.EditorHeader.save();'>
						{{@ property.editorSaved}}</div>
					</li>

					<!-- Toggle -->
					<li><div id="toggleAction" class="button special" 
						onclick='Widget.EditorSearchHeader.toggle();'>
						{{@ property.editorSearchExpand}}</div>
					</li>
				</ul>
			</nav>
		</header>
	*/}, data)
}

Widget.EditorSearchHeader.prototype = {
	constructor: Widget.EditorSearchHeader
}

Widget.EditorSearchHeader.toggleNavigation = "12u"
Widget.EditorSearchHeader.toggleEditor = "12u"
Widget.EditorSearchHeader.toggleName = property.editorSearchCompress

Widget.EditorSearchHeader.toggle = function () {
	var navigationClass = $("#editorSearchTemplateNavigation").attr("class")
	$("#editorSearchTemplateNavigation").attr("class", Widget.EditorSearchHeader.toggleNavigation)
	Widget.EditorSearchHeader.toggleNavigation = navigationClass

	var editorClass = $("#editorSearchTemplateEditor").attr("class")
	$("#editorSearchTemplateEditor").attr("class", Widget.EditorSearchHeader.toggleEditor)
	Widget.EditorSearchHeader.toggleEditor = editorClass

	var toggleName = $("#toggleAction").html()
	$("#toggleAction").html(Widget.EditorSearchHeader.toggleName)
	Widget.EditorSearchHeader.toggleName = toggleName
}

Widget.EditorSearchHeader.editFile = function () {
	var directoryName = getURLParameter("directoryName")

	if (isEmpty(directoryName)) {
		var infoPopup = new Widget.InfoPopup({info: "directory is required!"})
	} else if (isEmpty(editor.fileName)) {
		var infoPopup = new Widget.InfoPopup({info: "Select file!"})
	} else {
		var newSessionUrl = Widget.EditorHeader.newSessionUrl(
			property.editorUrl + property.editorEditFileUrl, 
			{directoryName: encodeURIComponent(directoryName), 
				fileName: encodeURIComponent(editor.fileName)})

		window.open(newSessionUrl)
	}
}