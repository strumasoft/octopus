Widget.InfoPopup = function (data) {
  var info = parse(function(){/*!
    <h1>{{info}}</h1>

    <button class="button special" 
      onclick='vars.infoPopup.delete()'>
      OK
    </button>
  */}, data)

  this.popup = new Widget.Popup({info: info})
  vars.infoPopup = this.popup
  this.popup.init()
}

Widget.InfoPopup.prototype = {
  constructor: Widget.InfoPopup
}