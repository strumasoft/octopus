Widget.ThreeFieldsPopup = function (data) {
	data.guid1 = Widget.guid()
	data.guid2 = Widget.guid()
	data.guid3 = Widget.guid()

	var info = parse(function(){/*!
		{{?@ !isEmpty(data.info)
			<h1>{{info}}</h1>
		}}?

		<input class="space-down-popup-input"
			{{? password == 1
				type="password"
			}}?
			{{? password != 1
				type="text"
			}}?
			id="{{guid1}}" placeholder="{{placeholder1}}" value="" />

		<input class="space-down-popup-input"
			{{? password == 2
				type="password"
			}}?
			{{? password != 2
				type="text"
			}}? 
			id="{{guid2}}" placeholder="{{placeholder2}}" value="" />

		<input class="space-down-popup-input"
			{{? password == 3
				type="password"
			}}?
			{{? password != 3
				type="text"
			}}?
			id="{{guid3}}" placeholder="{{placeholder3}}" value="" />

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