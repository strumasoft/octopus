Widget.OneFieldPopup = function (data) {
  data.guid = Widget.guid()

  var info = parse(function(){/*!
    {{?@ !isEmpty(data.info)
      <h1>{{info}}</h1>
    }}?

    <input class="spaced-down"
      {{? password == 1
        type="password"
      }}?
      {{? password != 1
        type="text"
      }}?
      id="{{guid}}" placeholder="{{placeholder}}" value="{{value}}" />

    <button class="button" 
      onclick='vars.oneFieldPopup.delete()'>
      No
    </button>
    <button class="button special" 
      onclick='vars.oneFieldPopup.proceed("{{guid}}")'>
      Yes
    </button>
  */}, data)

  this.popup = new Widget.Popup({info: info})
  this.popup.proceed = data.proceed
  vars.oneFieldPopup = this.popup
  this.popup.init()
}

Widget.OneFieldPopup.prototype = {
  constructor: Widget.OneFieldPopup
}