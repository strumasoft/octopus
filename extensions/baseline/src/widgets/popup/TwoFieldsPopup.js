Widget.TwoFieldsPopup = function (data) {
	data.guid1 = Widget.guid()
	data.guid2 = Widget.guid()

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
			id="{{guid1}}" placeholder="{{placeholder1}}" value="" />

		<input class="spaced-down"
			{{? password == 2
				type="password"
			}}?
			{{? password != 2
				type="text"
			}}? 
			id="{{guid2}}" placeholder="{{placeholder2}}" value="" />

		<button class="button" 
			onclick='vars.twoFieldsPopup.delete()'>
			No
		</button>
		<button class="button special" 
			onclick='vars.twoFieldsPopup.proceed("{{guid1}}", "{{guid2}}")'>
			Yes
		</button>
	*/}, data)

	this.popup = new Widget.Popup({info: info})
	this.popup.proceed = data.proceed
	vars.twoFieldsPopup = this.popup
	this.popup.init()
}

Widget.TwoFieldsPopup.prototype = {
	constructor: Widget.TwoFieldsPopup
}