local json = require "json"
local parse = require "parse"
local param = require "param"
local property = require "property"
local database = require "database"



local externalJS = [[
	<script src="/baseline/static/ace/ace.js" type="text/javascript"></script>
	<script src="/baseline/static/js/init-baseline.js" type="text/javascript"></script>
]]


local externalCSS = [[
	<link href="/database/static/database-favicon.ico" rel="shortcut icon" type="image/vnd.microsoft.icon" />
]]


local initJSTemplate = [[
	var vars = {}


	var editor = new Widget.DatabaseEditor({id: "editor"})

	vars.scriptTab = {   
		guid: Widget.guid(),
		id: Widget.guid(),
		name: "Script",
		html: editor.html
	}

	vars.resultTab = {
		guid: Widget.guid(),
		id: Widget.guid(),
		name: "Result",
		html: '<div class="resultbox"></div>'
	}

	vars.editTab = {
		guid: Widget.guid(),
		id: Widget.guid(),
		name: "Edit",
		html: '<div class="resultbox"></div>'
	}

	var tabs = [vars.scriptTab, vars.resultTab, vars.editTab]

	var databaseTabs = new Widget.DatabaseTabs({tabs: tabs})

	var databaseNavigation = new Widget.DatabaseNavigation({{types}})
	var databaseHeader = new Widget.DatabaseHeader({tabs: tabs})

	var databaseTemplate = new Widget.DatabaseTemplate({
		tabs: databaseTabs.html,
		navigation: databaseNavigation.html, 
		header: databaseHeader.html
	})

	Widget.setHtmlToPage(databaseTemplate.html);

	editor.init()
	databaseNavigation.init()
]]



local db = database.connect()
db:close()


-- sort types --
local typeNames = {}
for k,v in pairs(db.types) do typeNames[#typeNames + 1] = k end
table.sort(typeNames)

-- wrap everything up --
local types = {}
for i=1,#typeNames do
	local k = typeNames[i]
	types[#types + 1] = {name = k}
end



local page = parse(require("BaselineHtmlTemplate"), {
	title = "Database", 
	externalJS = externalJS,
	externalCSS = externalCSS,
	initJS = parse(initJSTemplate, {
		types = json.encode(types)
	})
})

ngx.say(page)