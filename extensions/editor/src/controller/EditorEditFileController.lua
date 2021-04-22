local json = require "json"
local param = require "param"
local property = require "property"
local exit = require "exit"
local editor = require "Editor"
local parse = require "parse"
local directory = require "Directory"
local util = require "util"
local fileutil = require "fileutil"



local externalJS = [[
	<script src="/baseline/static/ace/ace.js" type="text/javascript"></script>
	<script src="/baseline/static/js/init-baseline.js" type="text/javascript"></script>
]]


local externalCSS = [[
	<link href="/editor/static/editor-favicon.ico" rel="shortcut icon" type="image/vnd.microsoft.icon" />
]]


local initJSTemplate = [[
	var vars = {}

	var editor = new Widget.Editor({id: "editor"})
	var editorSearchResult = new Widget.EditorSearchResult({{files}})
	var editorSearchHeader = new Widget.EditorSearchHeader("{{title}}")

	var editorSearchTemplate = new Widget.EditorSearchTemplate({
		searchResult: editorSearchResult.html,
		editor: editor.html,
		header: editorSearchHeader.html
	})

	Widget.setHtmlToPage(editorSearchTemplate.html);

	editor.init()
	$("#directoryNavigation").css("max-height", Widget.EditorTemplate.maxHeight())
	vars.searchEditor = editor
	
	Widget.EditorSearchHeader.toggle();
]]


local function process ()
	local directoryName = param.directoryName
	local fileName = param.fileName

	local files = {fileName}

	local paths = util.split(fileName, "/")
	local title = paths[#paths]

	return parse(require("BaselineHtmlTemplate"), {
		title = title, 
		externalJS = externalJS,
		externalCSS = externalCSS,
		initJS = parse(initJSTemplate, {
			title = fileutil.escapeCommandlineSpecialCharacters(title), 
			files = json.encode(files)
		})
	})
end


local status, res = pcall(process)
if status then
	if res then ngx.say(res) end
else
	exit(res)
end