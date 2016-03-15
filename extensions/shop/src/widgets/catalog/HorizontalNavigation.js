Widget.HorizontalNavigation = function (categories) {
	if (categories) {
		for (var i = 0; i < categories.length; i++) {
			categories[i].url = property.shopUrl + property.categoryUrl + "/" + categories[i].code
		}
	}

	var data = {categories: categories}

	this.data = data
	this.html = parse(function(){/*!
		{{? categories.length > 0
			<ul class="menu2">
			{{# categories[i]
				<li class="menu2" ><a class="menu2" href="{{categories[i].url}}">{{categories[i].name[0].content}}</a></li>
			}}#
			</ul>
		}}?
	*/}, data)
}

Widget.HorizontalNavigation.prototype = {
	constructor: Widget.HorizontalNavigation
}