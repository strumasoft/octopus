Widget.Popup = function (data) {
  this.data = data
  this.html = parse(function(){/*!
    <div>
      <div class="overlay"></div>
      <div class="popup">{{info}}</div>
    </div>
  */}, data)
}

Widget.Popup.prototype = {
  constructor: Widget.Popup,

  init: function () {
    $("#popups").html(this.html)
  },

  delete: function () {
    $("#popups").empty()
  }
}