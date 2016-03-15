Widget.Editor = function (data) {
	this.data = data
	this.html = parse(function(){/*!
		<div id="{{id}}"></div>
	*/}, data)
}

Widget.Editor.prototype = {
	constructor: Widget.Editor,
	
	init: function () {
		var aceEditor = ace.edit(this.data.id)
	    aceEditor.setTheme("ace/theme/chrome")
	    aceEditor.getSession().setMode("ace/mode/text")
	    
	    aceEditor.setShowPrintMargin(false)
	    aceEditor.getSession().setTabSize(4)
	    aceEditor.getSession().setUseSoftTabs(false)
	    //aceEditor.getSession().setUseWorker(false) // disable syntax checker and information
	    
	    document.getElementById(this.data.id).style.fontSize = "14px"
	    document.getElementById(this.data.id).style.height = Widget.EditorTemplate.maxHeight()
	    
	    aceEditor.on('change', function (e) {
	        // e.data.action - insertLines|insertText|removeLines|removeText
	        Widget.EditorHeader.saved(false)
	    })
	    
	    this.aceEditor = aceEditor
	},
	
	setValue: function (content) {
	    // delete previous and set new content
	    this.aceEditor.removeLines()
		this.aceEditor.setValue(content, -1)
		
		// remove last new line (added by ace)
		this.aceEditor.navigateFileEnd()
		this.aceEditor.navigateLeft(1)
		this.aceEditor.removeToLineEnd()
		this.aceEditor.navigateFileStart()
		
		// mark saved
		Widget.EditorHeader.saved(true)
	},
	
	getValue: function () {
		return this.aceEditor.getValue()
	},
	
	setMode: function (e) {
		var mode
		
		if (e == "lua") {
			mode = "ace/mode/lua"	
		} else if (e == "js") {
			mode = "ace/mode/javascript"
		} else if (e == "json") {
			mode = "ace/mode/json"
		} else if (e == "css") {
			mode = "ace/mode/css"
		} else if (e == "html") {
			mode = "ace/mode/html"
		} else if (e == "xml") {
			mode = "ace/mode/xml"
		} else if (e == "c") {
			mode = "ace/mode/c_cpp"
		} else if (e == "cpp") {
			mode = "ace/mode/c_cpp"
		} else if (e == "h") {
			mode = "ace/mode/c_cpp"
		} else if (e == "hpp") {
			mode = "ace/mode/c_cpp"
		} else if (e == "ino") {
			mode = "ace/mode/c_cpp"
		} else if (e == "java") {
			mode = "ace/mode/java"
		} else if (e == "scala") {
			mode = "ace/mode/scala"
		} else if (e == "sbt") {
			mode = "ace/mode/scala"
		} else if (e == "sh") {
			mode = "ace/mode/sh"
		} else if (e == "sql") {
			mode = "ace/mode/sql"
		} else if (e == "scad") {
			mode = "ace/mode/scad"
		} else {
			mode = "ace/mode/text"
		}
		
		this.aceEditor.getSession().setMode(mode)
	}
}