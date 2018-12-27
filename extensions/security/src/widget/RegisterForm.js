Widget.RegisterForm = function (data) {
	this.data = data
	this.html = parse(function(){/*!
		<h3>Register</h3>

		<form method="post" action="/security/registerUser">
			<div class="row uniform">
				<div class="6u$ 8u$(medium) 12u$(small)">
					<input type="email" name="email" id="email" value="" placeholder="Email" />
				</div>
				<div class="6u$ 8u$(medium) 12u$(small)">
					<input type="password" name="password" id="password" value="" placeholder="Password" />
				</div>
				<div class="6u$ 8u$(medium) 12u$(small)">
					<input type="password" name="repeatPassword" id="repeatPassword" value="" placeholder="Repeat Password" />
				</div>

				<div class="12u$">
					<ul class="actions">
						<li><input type="submit" value="Register" /></li>
					</ul>
				</div>
			</div>
		</form>
	*/}, data)
}

Widget.RegisterForm.prototype = {
	constructor: Widget.RegisterForm
}