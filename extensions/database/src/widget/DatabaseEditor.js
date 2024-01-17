Widget.DatabaseEditor = function (data) {
  this.data = data
  this.html = parse(function(){/*!
    <div id="{{id}}"></div>
  */}, data)
}

Widget.DatabaseEditor.prototype = {
  constructor: Widget.DatabaseEditor,

  init: function () {
    var aceEditor = ace.edit(this.data.id)
    aceEditor.setTheme("ace/theme/chrome")
    aceEditor.getSession().setMode("ace/mode/lua")

    aceEditor.setShowPrintMargin(false)

    aceEditor.getSession().setOptions({ tabSize: 2, useSoftTabs: true });
    //aceEditor.getSession().setTabSize(4)
    //aceEditor.getSession().setUseSoftTabs(true)

    //aceEditor.getSession().setUseWorker(false) // disable syntax checker and information

    document.getElementById(this.data.id).style.fontSize = "14px"
    document.getElementById(this.data.id).style.height = Widget.DatabaseTemplate.maxHeight()

    this.aceEditor = aceEditor
  },

  setValue: function (content) {
    // delete previous and set new content
    this.aceEditor.removeLines()
    this.aceEditor.setValue(content, -1)
    this.aceEditor.navigateFileStart()
  },

  getValue: function () {
    return this.aceEditor.getValue()
  }
}