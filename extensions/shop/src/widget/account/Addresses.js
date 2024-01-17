Widget.Addresses = function (data) {
  data.formId = Widget.guid()

  this.data = data
  this.html = parse(function(){/*!
    <form id="{{formId}}" method="get" onsubmit='return Widget.validateRadioButton("address");'>
      <div class="row uniform">
        {{# addresses[i]
          <div class="6u$ 8u$(medium) 12u$(small)">
            <input type="radio" id="address-{{addresses[i].id}}" name="address" value="{{addresses[i].id}}">
            <label for="address-{{addresses[i].id}}">{{addresses[i].firstName}} {{addresses[i].middleName}} {{addresses[i].lastName}}, {{addresses[i].telephone}}, {{addresses[i].email}}, {{addresses[i].line1}} {{addresses[i].line2}} {{addresses[i].city}} {{addresses[i].postCode}} {{addresses[i].country}}</label>
          </div>
        }}#

        <div class="12u$">
          <ul class="actions">
            {{?@ !isEmpty(data.editAddressUrl)
            <li><input type="submit" value="{{editAddressName}}" 
              onclick='Widget.Addresses.setActionUrl("{{formId}}", "{{editAddressUrl}}")' /></li>
            }}?
            {{?@ !isEmpty(data.removeAddressUrl)
            <li><input type="submit" value="{{removeAddressName}}" 
              onclick='Widget.Addresses.setActionUrl("{{formId}}", "{{removeAddressUrl}}")' /></li>
            }}?
            {{?@ !isEmpty(data.setAddressUrl)
            <li><input type="submit" value="{{setAddressName}}" 
              onclick='Widget.Addresses.setActionUrl("{{formId}}", "{{setAddressUrl}}")' /></li>
            }}?
            <li><a class="button" href='{{addAddressUrl}}'>{{addAddressName}}</a></li>
          </ul>
        </div>
      </div>
    </form>
  */}, data)
}

Widget.Addresses.prototype = {
  constructor: Widget.Addresses
}

Widget.Addresses.setActionUrl = function (formId, actionUrl) {
  $("#" + formId).attr("action", actionUrl)
}