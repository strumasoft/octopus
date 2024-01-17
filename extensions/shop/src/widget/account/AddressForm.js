Widget.AddressForm = function (data) {
  this.data = data
  this.html = parse(function(){/*!
    <form method="post" action="{{actionUrl}}">
      <div class="row uniform">
        <input type="hidden" name="id" id="id" value="{{address.id}}" />

        <div class="6u$ 8u$(medium) 12u$(small)">
          <input type="text" name="firstName" id="firstName" value="{{address.firstName}}" placeholder="First Name" />
        </div>
        <div class="6u$ 8u$(medium) 12u$(small)">
          <input type="text" name="middleName" id="middleName" value="{{address.middleName}}" placeholder="Middle Name" />
        </div>
        <div class="6u$ 8u$(medium) 12u$(small)">
          <input type="text" name="lastName" id="lastName" value="{{address.lastName}}" placeholder="Last Name" />
        </div>
        <div class="6u$ 8u$(medium) 12u$(small)">
          <input type="text" name="telephone" id="telephone" value="{{address.telephone}}" placeholder="Telephone" />
        </div>
        <div class="6u$ 8u$(medium) 12u$(small)">
          <input type="email" name="email" id="email" value="{{address.email}}" placeholder="Email" />
        </div>
        <div class="6u$ 8u$(medium) 12u$(small)">
          <input type="text" name="line1" id="line1" value="{{address.line1}}" placeholder="Address Line 1" />
        </div>
        <div class="6u$ 8u$(medium) 12u$(small)">
          <input type="text" name="line2" id="line2" value="{{address.line2}}" placeholder="Address Line 2" />
        </div>
        <div class="6u$ 8u$(medium) 12u$(small)">
          <input type="text" name="city" id="city" value="{{address.city}}" placeholder="City" />
        </div>
        <div class="6u$ 8u$(medium) 12u$(small)">
          <input type="text" name="postCode" id="postCode" value="{{address.postCode}}" placeholder="Post Code" />
        </div>
        <div class="6u$ 8u$(medium) 12u$(small)">
          <input type="text" name="country" id="country" value="{{address.country}}" placeholder="Country" />
        </div>

        <div class="12u$">
          <ul class="actions">
            <li><input class="special" type="submit" value="{{actionName}}" /></li>
          </ul>
        </div>
      </div>
    </form>
  */}, data)
}

Widget.AddressForm.prototype = {
  constructor: Widget.AddressForm
}