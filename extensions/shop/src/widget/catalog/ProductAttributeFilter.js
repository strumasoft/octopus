Widget.ProductAttributeFilter = function (productAttributes) {
	if (productAttributes && productAttributes instanceof Array) {
		for (var j = 0; j < productAttributes.length; j++) {
			for (var i = 0; i < productAttributes[j].values.length; i++) {productAttributes[j].values[i].guid = Widget.guid()}
		}
	}

	var data = {productAttributes: productAttributes}

	this.data = data
	this.html = parse(function(){/*!
		{{# productAttributes[j]
			{{? productAttributes[j].values.length > 0
				<h3>{{productAttributes[j].name[0].content}}</h3>
				<ul class="no-bullets">
					{{## productAttributes[j].values[i]
						<li>
							<input type="checkbox" 
								id="{{productAttributes[j].values[i].guid}}"
								name="{{productAttributes[j].values[i].guid}}"
								class="filterProductAttribute"
								productAttributeValueId="{{productAttributes[j].values[i].id}}">
							<label for="{{productAttributes[j].values[i].guid}}">{{productAttributes[j].values[i].name[0].content}}</label>
						</li>
					}}##
				</ul>
			}}?
		}}#
	*/}, data)
}

Widget.ProductAttributeFilter.prototype = {
	constructor: Widget.ProductAttributeFilter
}