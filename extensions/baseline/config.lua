local config = {} -- extension configuration

config.property = {
	baseline_color1 = "#fff",
	baseline_color2 = "#000",
	baseline_color3 = "#49bf9d",
	baseline_color4 = "#000",
	baseline_color5 = "144, 144, 144",
	baseline_color6 = "#bbb",
	baseline_color7 = "#737373",
	baseline_color8 = "#595959",
	baseline_color9 = "#5cc6a7",
	baseline_color01 = "#3eb08f",
	baseline_color02 = "#ccc",
	baseline_color03 = "#cdede4",
	baseline_color04 = "#f6f6f6",
	baseline_color05 = "#f2f2f2",
	baseline_color06 = "0, 0, 0",
	baseline_color07 = "#555",
	baseline_color08 = "#ebebeb",
	baseline_color09 = "#d9d9d9",
	
	baseline_font1 = "Arial, Helvetica, sans-serif",
	baseline_font2 = '"Courier New", monospace',
}

config.module = {
	{name = "BaselineHtmlTemplate", script = "BaselineHtmlTemplate.lua"}
}

config.javascript = {
	{name = "Popup", script = "widget/popup/Popup.js"},
	{name = "InfoPopup", script = "widget/popup/InfoPopup.js"},
	{name = "OneFieldPopup", script = "widget/popup/OneFieldPopup.js"},
	{name = "TwoFieldsPopup", script = "widget/popup/TwoFieldsPopup.js"},
	{name = "ThreeFieldsPopup", script = "widget/popup/ThreeFieldsPopup.js"},
	{name = "QuestionPopup", script = "widget/popup/QuestionPopup.js"}
}

config.stylesheet = {
	{name = "style", script = "widget/style.css"},
	{name = "Popup", script = "widget/popup/Popup.css"}
}

config.parse = {
	{name = "/build/static/nav.css", script = "widget/nav.css"}
}

config.static = {
	"static"
}

return config -- return extension configuration