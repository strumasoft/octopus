Widget.EditorSearchHeader = function (data) {
	this.data = data
	this.html = parse(function(){/*!
		<header id="header" class="skel-layers-fixed">
			<h1><div id="menu" class="hand">Search</div></h1>
			<nav id="nav">
				<ul>
				    <!-- Toggle -->
					<li><div id="toggleAction" class="button special" 
					    onclick='Widget.EditorSearchHeader.toggle();'>
				        Narrow</div>
					</li>
				    
				    <!-- Save -->
					<li><div id="saveAction" class="button special" 
					    onclick='Widget.EditorHeader.save();'>
				        Save</div>
					</li>
				</ul>
			</nav>
		</header>
	*/}, data)
}

Widget.EditorSearchHeader.prototype = {
	constructor: Widget.EditorSearchHeader
}

Widget.EditorSearchHeader.toggleNavigation = "3u 12u(medium)"
Widget.EditorSearchHeader.toggleEditor = "9u 12u(medium)"
Widget.EditorSearchHeader.toggleName = "Wide"

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