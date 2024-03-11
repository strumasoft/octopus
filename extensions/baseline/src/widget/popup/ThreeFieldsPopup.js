Widget.ThreeFieldsPopup = function (data) {
  data.guid1 = Widget.guid()
  data.guid2 = Widget.guid()
  data.guid3 = Widget.guid()

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
      id="{{guid1}}" placeholder="{{placeholder1}}" value="{{value1}}" />

    <input class="spaced-down"
      {{? password == 2
        type="password"
      }}?
      {{? password != 2
        type="text"
      }}? 
      id="{{guid2}}" placeholder="{{placeholder2}}" value="{{value2}}" />

    <input class="spaced-down"
      {{? password == 3
        type="password"
      }}?
      {{? password != 3
        type="text"
      }}?
      id="{{guid3}}" placeholder="{{placeholder3}}" value="{{value3}}" />

    <button class="button" 
      onclick='vars.threeFieldsPopup.delete()'>
      No
    </button>
    <button class="button special" 
      onclick='vars.threeFieldsPopup.proceed("{{guid1}}", "{{guid2}}", "{{guid3}}")'>
      Yes
    </button>
  */}, data)

  this.popup = new Widget.Popup({info: info})
  this.popup.proceed = data.proceed
  vars.threeFieldsPopup = this.popup
  this.popup.init()
}

Widget.ThreeFieldsPopup.prototype = {
  constructor: Widget.ThreeFieldsPopup
}