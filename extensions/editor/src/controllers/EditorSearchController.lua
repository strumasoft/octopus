local json = require "dkjson"
local param = require "param"
local property = require "property"
local exit = require "exit"
local editor = require "Editor"
local parse = require "parse"
local directory = require "Directory"
local util = require "util"



local externalJS = parse([[
    <script src="https://cdn.jsdelivr.net/ace/{{aceVersion}}/min/ace.js" type="text/javascript" charset="utf-8"></script>
	<script type="text/javascript" src="/baseline/static/js/init-baseline.js"></script>
]], {aceVersion = property.aceEditorVersion})


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
]]


local function aggregateAllFilesContainingQuery (files, directoryName, query, filter, isPlainString, isFileName)
    for entry, attr in pairs(directory.entries(directoryName)) do
        if attr.mode == "file" then
            local path = attr.path
            if param.isEmpty(filter) or path:find(filter) then
                if isFileName then 
                    if path:find(query, 1, isPlainString) then
                        files[#files + 1] = path
                    end
                else
                    local content = editor.fileContent(path)
                    if content:find(query, 1, isPlainString) then
                        files[#files + 1] = path
                    end
                end
            end
        elseif attr.mode == "directory" then
            aggregateAllFilesContainingQuery(files, attr.path, query, filter, isPlainString, isFileName)
        end
    end
end


local function replaceQuery (files, query, replace, isPlainString, isFileName, repository, username, password)
    for i=1,#files do
        if isFileName then
            local oldName = files[i]
            local newName = oldName:replace(query, replace, isPlainString)
            
            if param.isNotEmpty(repository) and param.isNotEmpty(username) and param.isNotEmpty(password) then
                local repo = require(repository)
                repo.move(username, password, oldName, newName)
            else
                editor.rename(oldName, newName)
            end
        else
            local content = editor.fileContent(files[i])
            local newContent = content:replace(query, replace, isPlainString)
            
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
    local isRegex = param.toboolean(param.isRegex)
    local isFileName = param.toboolean(param.isFileName)
    
    local files = {}
    
    if param.isNotEmpty(query) and param.isNotEmpty(directoryName) then
        local isPlainString = not isRegex
        
        aggregateAllFilesContainingQuery(files, directoryName, query, filter, isPlainString, isFileName)
        
        if param.isNotEmpty(replace) and #files > 0 then
            replaceQuery(files, query, replace, isPlainString, isFileName, param.repository, param.username, param.password)
        end
    end
    
    
    return parse(require("BaselineHtmlTemplate"), {
    	title = query, 
    	externalJS = externalJS,
    	externalCSS = externalCSS,
    	initJS = parse(initJSTemplate, {
    	    title = util.escapeCommandlineSpecialCharacters(query), 
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