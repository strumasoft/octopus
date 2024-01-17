Widget.CompareEditor = function (data) {
  var editor = new Widget.Editor(data)
  
  editor.html = parse(function(){/*!
    <h1 style="margin: 1em;">{{name}}</h1>
    <div id="{{id}}"></div>
  */}, data)
  
  return editor
}

Widget.CompareEditor.prototype = {
  constructor: Widget.CompareEditor
}