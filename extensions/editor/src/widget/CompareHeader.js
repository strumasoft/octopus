Widget.CompareHeader = function () {
  var data = {}
  if (localStorage.getItem("isDark") === "true") {
    data.theme = "fa-moon-o";
    setTimeout(() => Widget.EditorHeader.theme(true), 50);
  } else {
    data.theme = "fa-sun-o";
  }

  this.data = data
  this.html = parse(function(){/*!
    <header id="header" class="skel-layers-fixed">
      <nav id="nav">
        <ul>
          <!-- Theme -->
          <li><div id="theme" class="hand" 
            onclick='Widget.EditorHeader.theme();'>
            <i class="fa {{theme}}"></i></div>
          </li>
          
          <!-- Compare -->
          <li><div id="compareAction" class="button special" 
            onclick='Widget.CompareHeader.compare();'>
            Compare</div>
          </li>
        </ul>
      </nav>
    </header>
  */}, data)
}

Widget.CompareHeader.prototype = {
  constructor: Widget.CompareHeader
}

Widget.CompareHeader.compare = function () {
  var originalContent = vars.originalEditor.getValue()
  var changedContent = vars.changedEditor.getValue()

  $("#oldfilecontent .diffbox").html(Widget.createHTML(originalContent))
  $("#newfilecontent .diffbox").html(Widget.createHTML(changedContent))

  diffUsingJS(0, originalContent, changedContent)

  $("#comparator").prettyTextDiff({
    cleanup: $("#cleanup").is(":checked"),
    originalContent: originalContent,
    changedContent: changedContent,
    diffContainer: ".diffbox"
  })
  
  Widget.CompareTabs.show("comparator", $("button.diffComparatorButton:last-child").attr('id'))
}