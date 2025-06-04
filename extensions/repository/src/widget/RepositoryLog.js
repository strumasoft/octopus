Widget.RepositoryLog = function () {
  var data = {}
  if (localStorage.getItem("isDark") === "true") {
    data.clazz = "dark";
  }

  this.data = data
  this.html = parse(function(){/*!
    <div>
      <div class="diffComparator">
        <pre id="repositoryLogContent" class="diffbox {{clazz}}"></pre>
      </div>
    </div>
  */}, data)
}

Widget.RepositoryLog.prototype = {
  constructor: Widget.RepositoryLog
}

Widget.RepositoryLog.setContent = function (content) {
  $('#repositoryLogContent').html(Widget.createHTML(content))
}