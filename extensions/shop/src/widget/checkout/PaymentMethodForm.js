Widget.PaymentMethodForm = function (paymentMethods) {
  var data = {paymentMethods: paymentMethods, action: property.shopUrl + property.checkoutSetPaymentMethodUrl}

  this.data = data
  this.html = parse(function(){/*!
    <form method="get" action="{{action}}" onsubmit='return Widget.validateRadioButton("paymentMethod");'>
      <div class="row uniform">
        {{# paymentMethods[i]
          <div class="6u$ 8u$(medium) 12u$(small)">
            <input type="radio" id="paymentMethod-{{paymentMethods[i].id}}" name="paymentMethod" value="{{paymentMethods[i].id}}">
            <label for="paymentMethod-{{paymentMethods[i].id}}">{{paymentMethods[i].name[0].content}}</label>
          </div>
        }}#

        <div class="12u$">
          <ul class="actions">
            <li><input type="submit" value="{{@localize("continue")}}" /></li>
          </ul>
        </div>
      </div>
    </form>
  */}, data)
}

Widget.PaymentMethodForm.prototype = {
  constructor: Widget.PaymentMethodForm
}