Widget.RepositoryPatch = function () {
  var data = {}

  this.data = data
  this.html = parse(function(){/*!
    <div id="patch"></div>
  */}, data)
}

Widget.RepositoryPatch.prototype = {
  constructor: Widget.RepositoryPatch
}

Widget.RepositoryPatch.setContent = function (contents) {
  var html = ""

  for (var i = 0; i < contents.length; i++) {
    html = html 
      + '<div class="diffComparator"><pre class="diffbox">' 
      + Widget.decoratePatch(Widget.createHTML(contents[i])) 
      + "</pre></div>"
  }

  $('#patch').html(html)
}