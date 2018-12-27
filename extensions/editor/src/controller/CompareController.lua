local parse = require "parse"


ngx.say(parse(require("BaselineHtmlTemplate"), {
	title = "Compare",
	externalJS = [[
		<script src="/baseline/static/js/init-baseline.js" type="text/javascript"></script>
		
		<script src="/baseline/static/ace/ace.js" type="text/javascript"></script>
		
		<script src="/baseline/static/js/diff_match_patch.js" type="text/javascript"></script>
		<script src="/baseline/static/js/jquery.pretty-text-diff.js" type="text/javascript"></script>
	
		<link rel="stylesheet" type="text/css" href="/baseline/static/js/diffview.css"/>
		<script type="text/javascript" src="/baseline/static/js/diffview.js"></script>
		<script type="text/javascript" src="/baseline/static/js/difflib.js"></script>
	]],
	externalCSS = [[
		<link href="/editor/static/editor-favicon.ico" rel="shortcut icon" type="image/vnd.microsoft.icon" />
	]],
	customJS = [[
		function diffUsingJS(viewType, originalContent, changedContent) {
			"use strict";
			var byId = function (id) { return document.getElementById(id); },
				base = difflib.stringAsLines(originalContent),
				newtxt = difflib.stringAsLines(changedContent),
				sm = new difflib.SequenceMatcher(base, newtxt),
				opcodes = sm.get_opcodes(),
				diffoutputdiv = byId("diffoutput");
	
			diffoutputdiv.innerHTML = "";
			var contextSize = null;
	
			diffoutputdiv.appendChild(diffview.buildView({
				baseTextLines: base,
				newTextLines: newtxt,
				opcodes: opcodes,
				baseTextName: "OLD",
				newTextName: "NEW",
				contextSize: contextSize,
				viewType: viewType
			}));
		}
	]],
	initJS = [[
		var vars = {}
		
		vars.originalEditor = new Widget.CompareEditor({id: "originalEditor", name: "Old"})
		vars.changedEditor = new Widget.CompareEditor({id: "changedEditor", name: "New"})

		Widget.setContainerToPage([
			[
				{size: "12u", widget: new Widget.CompareHeader()}
			],
			[
				{size: "6u", small: "12u", widget: vars.originalEditor},
				{size: "6u", small: "12u", widget: vars.changedEditor}
			],
			[
				{size: "12u", widget: new Widget.CompareTabs()}
			]
		])
		
		vars.originalEditor.init()
		vars.originalEditor.setHeight("20em")
		vars.changedEditor.init()
		vars.changedEditor.setHeight("20em")
	]]
}))