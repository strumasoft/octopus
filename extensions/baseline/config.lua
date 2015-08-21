local config = {} -- extension configuration

config.static = {
	"static"
}

config.modules = {
	{name = "BaselineHtmlTemplate", script = "BaselineHtmlTemplate.lua"}
}

config.javascripts = {
	{name = "Popup", script = "widgets/popup/Popup.js"},
	{name = "InfoPopup", script = "widgets/popup/InfoPopup.js"},
	{name = "OneFieldPopup", script = "widgets/popup/OneFieldPopup.js"},
	{name = "TwoFieldsPopup", script = "widgets/popup/TwoFieldsPopup.js"},
	{name = "ThreeFieldsPopup", script = "widgets/popup/ThreeFieldsPopup.js"},
	{name = "QuestionPopup", script = "widgets/popup/QuestionPopup.js"}
}

config.stylesheets = {
	{name = "Popup", script = "widgets/popup/Popup.css"}
}

return config -- return extension configuration