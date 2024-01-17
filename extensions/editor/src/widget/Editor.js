Widget.Editor = function (data) {
  this.data = data
  this.html = parse(function(){/*!
    <div id="{{id}}"></div>
  */}, data)

  document.addEventListener('keydown', function (event) {
    if (event.ctrlKey && event.key === 's') {
      event.preventDefault()
      Widget.EditorHeader.save()
    }
  })
}

Widget.Editor.prototype = {
  constructor: Widget.Editor,

  init: function (hight) {
    var aceEditor = ace.edit(this.data.id)
    this.aceEditor = aceEditor

    aceEditor.setTheme("ace/theme/chrome")
    aceEditor.getSession().setMode("ace/mode/text")

    aceEditor.setShowPrintMargin(false)

    aceEditor.getSession().setOptions({ tabSize: 2, useSoftTabs: true });
    //aceEditor.getSession().setTabSize(4)
    //aceEditor.getSession().setUseSoftTabs(false)

    //aceEditor.getSession().setUseWorker(false) // disable syntax checker and information

    this.setFontSize("14px")
    this.setHeight(hight ? hight : Widget.EditorTemplate.maxHeight())

    aceEditor.on('change', function (e) {
      // e.data.action - insertLines|insertText|removeLines|removeText
      Widget.EditorHeader.saved(false)
    })
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

    if (e == "js") {
      mode = "ace/mode/javascript"
    } else if (e == "ts") {
      mode = "ace/mode/typescript"
    } else if (e == "jsx") {
      mode = "ace/mode/jsx"
    } else if (e == "tsx") {
      mode = "ace/mode/tsx"
    } else if (e == "vue") {
      mode = "ace/mode/xml"
    } else if (e == "json") {
      mode = "ace/mode/json"
    } else if (e == "css") {
      mode = "ace/mode/css"
    } else if (e == "less") {
      mode = "ace/mode/less"
    } else if (e == "sass") {
      mode = "ace/mode/sass"
    } else if (e == "scss") {
      mode = "ace/mode/scss"
    } else if (e == "html") {
      mode = "ace/mode/html"
    } else if (e == "xhtml") {
      mode = "ace/mode/html"
    } else if (e == "xml") {
      mode = "ace/mode/xml"
    } else if (e == "wsdl") {
      mode = "ace/mode/xml"
    } else if (e == "jsp") {
      mode = "ace/mode/html"
    } else if (e == "tag") {
      mode = "ace/mode/html"
    } else if (e == "vm") {
      mode = "ace/mode/velocity"
    } else if (e == "properties") {
      mode = "ace/mode/properties"
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
    } else if (e == "qml") {
      mode = "ace/mode/qml"
    } else if (e == "cs") {
      mode = "ace/mode/csharp"
    } else if (e == "java") {
      mode = "ace/mode/java"
    } else if (e == "scala") {
      mode = "ace/mode/scala"
    } else if (e == "sbt") {
      mode = "ace/mode/scala"
    } else if (e == "groovy") {
      mode = "ace/mode/groovy"
    } else if (e == "hs") {
      mode = "ace/mode/haskel"
    } else if (e == "lhs") {
      mode = "ace/mode/haskel"
    } else if (e == "lua") {
      mode = "ace/mode/lua"
    } else if (!isEmpty(e) && e.split("/")[e.split("/").length-1].toLowerCase().indexOf("makefile") >= 0) {
      mode = "ace/mode/makefile"
    } else if (e == "md") {
      mode = "ace/mode/markdown"
    } else if (e == "markdown") {
      mode = "ace/mode/markdown"
    } else if (e == "m") {
      mode = "ace/mode/matlab"
    } else if (e == "pl") {
      mode = "ace/mode/perl"
    } else if (e == "php") {
      mode = "ace/mode/php"
    } else if (e == "ps1") {
      mode = "ace/mode/powershell"
    } else if (e == "pro") {
      mode = "ace/mode/prolog"
    } else if (e == "py") {
      mode = "ace/mode/python"
    } else if (e == "rb") {
      mode = "ace/mode/ruby"
    } else if (e == "rbw") {
      mode = "ace/mode/ruby"
    } else if (e == "scad") {
      mode = "ace/mode/scad"
    } else if (e == "sh") {
      mode = "ace/mode/sh"
    } else if (e == "sql") {
      mode = "ace/mode/sql"
    } else if (e == "tcl") {
      mode = "ace/mode/tcl"
    } else if (e == "yaml") {
      mode = "ace/mode/yaml"
    } else if (e == "dockerfile") {
      mode = "ace/mode/dockerfile"
    } else if (e == "v") {
      mode = "ace/mode/verilog"
    } else if (e == "vh") {
      mode = "ace/mode/verilog"
    } else if (e == "vlg") {
      mode = "ace/mode/verilog"
    } else if (e == "verilog") {
      mode = "ace/mode/verilog"
    } else if (e == "vhd") {
      mode = "ace/mode/vhdl"
    } else if (e == "vhdl") {
      mode = "ace/mode/vhdl"
    } else {
      mode = "ace/mode/text"
    }

    this.aceEditor.getSession().setMode(mode)
  }, 
  
  setFontSize: function (x) {
    document.getElementById(this.data.id).style.fontSize = x
  },
  
  getHeight: function () {
    return document.getElementById(this.data.id).style.height
  },
  
  setHeight: function (x) {
    document.getElementById(this.data.id).style.height = x
    this.aceEditor.resize()
  },

  getId: function () {
    return this.data.id
  }
}
