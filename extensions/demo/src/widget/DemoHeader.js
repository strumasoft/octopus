Widget.DemoHeader = function (data) {
  data = data || {}

  this.data = data
  this.html = parse(function(){/*!
    <header id="header" class="skel-layers-fixed">
      <nav id="nav">
        <ul>
          <li><a class="button special hand" style="color: white;"
            href="/">{{@localize("index")}}</a>
          </li>
          <li><a class="button special hand" style="color: white;"
            href="">{{@localize("reload")}}</a>
          </li>
          <li><a class="button special hand" style="color: white;"
            onclick='Widget.DemoHeader.showError()'>{{@localize("showError")}}</a>
          </li>
        </ul>
      </nav>
    </header>
  */}, data)
}

Widget.DemoHeader.prototype = {
  constructor: Widget.DemoHeader
}

Widget.DemoHeader.showError = function () {
  if($("#errors").length == 0) {
    var infoPopup = new Widget.InfoPopup({info: localize("noErrors")})
  } else {
    $("#errors").show()
  }
}