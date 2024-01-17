Widget.LoginForm = function (data) {
  this.data = data
  this.html = parse(function(){/*!
    <h3>Login</h3>

    <form method="post" action="/security/loginUser{{to}}">
      <div class="row uniform">
        <div class="6u 8u(medium) 12u$(small)">
          <input type="email" name="email" id="email" value="" placeholder="Email" />
        </div>
        <div class="6u$ 8u$(medium) 12u$(small)">
          <input type="password" name="password" id="password" value="" placeholder="Password" />
        </div>

        <div class="12u$">
          <ul class="actions">
            <li><input type="submit" value="Login" /></li>
          </ul>
        </div>
      </div>
    </form>
  */}, data)
}

Widget.LoginForm.prototype = {
  constructor: Widget.LoginForm
}