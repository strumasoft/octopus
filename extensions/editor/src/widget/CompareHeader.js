Widget.CompareHeader = function () {
	var data = {}

	this.data = data
	this.html = parse(function(){/*!
		<header id="header" class="skel-layers-fixed">
			<nav id="nav">
				<ul>
					<!-- Compare -->
					<li><div id="compareAction" class="button special" 
						onclick='Widget.CompareHeader.compare();'>
						Compare</div>
					</li>
				</ul>
			</nav>
		</header>
	*/}, data)
}

Widget.CompareHeader.prototype = {
	constructor: Widget.CompareHeader
}

Widget.CompareHeader.compare = function () {
	var originalContent = vars.originalEditor.getValue()
	var changedContent = vars.changedEditor.getValue()

	$("#oldfilecontent .diffbox").html(Widget.createHTML(originalContent))
	$("#newfilecontent .diffbox").html(Widget.createHTML(changedContent))

	diffUsingJS(0, originalContent, changedContent)

	$("#comparator").prettyTextDiff({
		cleanup: $("#cleanup").is(":checked"),
		originalContent: originalContent,
		changedContent: changedContent,
		diffContainer: ".diffbox"
	});
}