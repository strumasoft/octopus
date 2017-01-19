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
	<link href="/editor/static/search-favicon.ico" rel="shortcut icon" type="image/vnd.microsoft.icon" />
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
]]


local function aggregateAllFilesContainingQuery (files, directoryName, query, filter, isPlainString, isFileName, isIgnoreCase)
	for entry, attr in pairs(directory.entries(directoryName)) do
		if attr.mode == "file" then
			local path = attr.path
			if util.isEmpty(filter) or path:find(filter) then
				if isFileName then 
					if path:findQuery(query, 1, isPlainString, isIgnoreCase) then
						files[#files + 1] = path
					end
				else
					local content = editor.fileContent(path)
					if content:findQuery(query, 1, isPlainString, isIgnoreCase) then
						files[#files + 1] = path
					end
				end
			end
		elseif attr.mode == "directory" then
			aggregateAllFilesContainingQuery(files, attr.path, query, filter, isPlainString, isFileName, isIgnoreCase)
		end
	end
end


local function replaceQuery (files, directoryName, query, replace, isPlainString, isFileName, isIgnoreCase, repository, username, password)
	for i=1,#files do
		if isFileName then
			local oldName = files[i]
			local newName = oldName:replaceQuery(query, replace, isPlainString, isIgnoreCase)

			if util.isNotEmpty(repository) and util.isNotEmpty(username) and util.isNotEmpty(password) then
				local repo = require(repository)
				repo.move(username, password, oldName, newName, directoryName)
			else
				editor.rename(oldName, newName)
			end
		else
			local content = editor.fileContent(files[i])
			local newContent = content:replaceQuery(query, replace, isPlainString, isIgnoreCase)

			if newContent then
				editor.save(files[i], newContent)
			end
		end
	end
end


local function process ()
	local directoryName = param.directoryName
	local query = param.query
	local replace = param.replace
	local filter = param.filter
	local isRegex = util.toboolean(param.isRegex)
	local isFileName = util.toboolean(param.isFileName)
	local isIgnoreCase = util.toboolean(param.isIgnoreCase)

	local files = {}

	if util.isNotEmpty(query) and util.isNotEmpty(directoryName) then
		local isPlainString = not isRegex

		aggregateAllFilesContainingQuery(files, directoryName, query, filter, isPlainString, isFileName, isIgnoreCase)

		if util.isNotEmpty(replace) and #files > 0 then
			replaceQuery(files, directoryName, query, replace, isPlainString, isFileName, isIgnoreCase, param.repository, param.username, param.password)
		end
	end


	return parse(require("BaselineHtmlTemplate"), {
		title = query, 
		externalJS = externalJS,
		externalCSS = externalCSS,
		initJS = parse(initJSTemplate, {
			title = fileutil.escapeCommandlineSpecialCharacters(query), 
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