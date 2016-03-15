Widget.DatabaseEditObject = function (properties) {
	var type = properties.splice(properties.length - 1, 1)[0]

	var objectId // object id
	for (var i = 0; i < properties.length; i++) {
		var array = properties[i].value
		if (array instanceof Array) {
			var guid = []
			for (var j = 0; j < array.length; j++) {guid.push(Widget.guid())}
			properties[i].guid = guid
			properties[i].addId = Widget.guid()
		} else {
			properties[i].guid = Widget.guid()
			properties[i].addId = Widget.guid()
		}

		// get object id
		if (properties[i].name == "id") {objectId = properties[i].value}
	}

	var data = {type: type, properties: properties, objectId: objectId, booleanTrue: true, booleanFalse: false}

	this.data = data
	this.html = parse(function(){/*!
		<h3 
		id="databaseObjectSpec" 
		objectType="{{type}}" 
		objectId="{{objectId}}">
			{{type}}</h3>

		{{# properties[i]

		{{? properties[i].type.type != "id" && properties[i].type.type != "integer" && properties[i].type.type != "float" && properties[i].type.type != "boolean" && properties[i].type.type != "string"
		<div class="row uniform">
			<div class="2u 12u$(xsmall)">
				<label for="{{properties[i].name}}">{{properties[i].name}} [{{@Widget.extractStringUpTo(data.properties[i].type.type, ".")}}]</label>
			</div>

			<div class="6u">
				<input type="text"
					objectFrom="{{type}}.{{properties[i].name}}"
					objectTo="{{properties[i].type.type}}"
					objectParentId="{{objectId}}" 
					id="{{properties[i].addId}}" />
			</div>

			<div class="2u$">
				<div class="button special"
				onclick='Widget.DatabaseHeader.addReference("{{properties[i].addId}}");'>
				<i class="fa fa-plus"></i></div>

				<div class="button special"
				onclick='Widget.DatabaseHeader.deleteAllReferences("{{type}}.{{properties[i].name}}", "{{properties[i].type.type}}", "{{objectId}}");'>
				<i class="fa fa-bolt"></i></div>
			</div>
		</div>

		<div class="row uniform">
			<div class="-2u 12u(xsmall)">
				<div class="table-wrapper">
					<table class="alt">
						<tbody>
							{{??@ data.properties[i].value instanceof Array
							{{## properties[i].value[j]
							<tr class="hasManyReferences">
								<td>
									<input type="checkbox" 
										objectType="{{@Widget.extractStringUpTo(data.properties[i].type.type, ".")}}"
										objectId="{{properties[i].value[j].id}}"
										objectFrom="{{type}}.{{properties[i].name}}"
										objectTo="{{properties[i].type.type}}"
										objectParentId="{{objectId}}"
										id="{{properties[i].guid[j]}}" 
										name="{{properties[i].guid[j]}}" 
										class="databaseEdit">

									<label for="{{properties[i].guid[j]}}">{{@JSON.stringify(data.properties[i].value[j])}}</label>
								</td>
							</tr>
							}}##
							}}??

							{{??@ data.properties[i].value != null && !(data.properties[i].value instanceof Array)
							<tr class="hasOneReference">
								<td>
									<input type="checkbox" 
										objectType="{{@Widget.extractStringUpTo(data.properties[i].type.type, ".")}}"
										objectId="{{properties[i].value.id}}"
										objectFrom="{{type}}.{{properties[i].name}}"
										objectTo="{{properties[i].type.type}}"
										objectParentId="{{objectId}}"
										id="{{properties[i].guid}}" 
										name="{{properties[i].guid}}" 
										class="databaseEdit">

									<label for="{{properties[i].guid}}">{{@JSON.stringify(data.properties[i].value)}}</label>
								</td>
							</tr>
							}}??
						</tbody>
					</table>
				</div> <!-- end of table-wrapper -->
			</div>
		</div>
		}}?

		{{? properties[i].type.type == "integer" || properties[i].type.type == "float" || properties[i].type.type == "string"
		<div class="row uniform">
			<div class="2u 12u$(xsmall)">
				<label for="{{properties[i].name}}">{{properties[i].name}} [{{properties[i].type.type}}]</label>
			</div>

			<div class="10u$ 12u$(xsmall)">
				{{?? properties[i].type.type != "string"
				<input type="text" 
				name="{{properties[i].name}}" 
				id="{{properties[i].name}}" 
				value="{{properties[i].value}}" 
				class="databaseObjectProperty" />
				}}??

				{{?? properties[i].type.type == "string"
					{{??? properties[i].type.length <= 255
					<input type="text" 
					name="{{properties[i].name}}" 
					id="{{properties[i].name}}" 
					value="{{@ Widget.escapeHtml(data.properties[i].value)}}" 
					class="databaseObjectProperty" />
					}}???

					{{??? properties[i].type.length > 255
					<textarea rows="5"
					name="{{properties[i].name}}" 
					id="{{properties[i].name}}" 
					class="databaseObjectProperty">{{@ Widget.escapeHtml(data.properties[i].value)}}</textarea>
					}}???
				}}??
			</div>
		</div>
		}}?

		{{? properties[i].name == "id"
		<div class="row uniform">
			<div class="2u 12u$(xsmall)">
				<label for="{{properties[i].name}}">{{properties[i].name}}</label>
			</div>

			<div class="10u$ 12u$(xsmall)">
				{{properties[i].value}}
			</div>
		</div>
		}}?

		{{? properties[i].type.type == "boolean"
		<div class="row uniform">
			<div class="2u 12u$(xsmall)">
				<label for="{{properties[i].name}}">{{properties[i].name}}</label>
			</div>

			<div class="10u$ 12u$(xsmall)">
				<div class="4u 12u$(small)">
					<input type="radio"
					id="{{properties[i].name}}-true"
					name="{{properties[i].name}}"
					class="databaseObjectProperty"
					booleanValue="1"
					{{?? properties[i].value == booleanTrue
						checked
					}}??
					>
					<label for="{{properties[i].name}}-true">true</label>
				</div>
				<div class="4u 12u$(small)">
					<input type="radio"
					id="{{properties[i].name}}-false"
					name="{{properties[i].name}}"
					class="databaseObjectProperty"
					booleanValue="0"
					{{?? properties[i].value == booleanFalse
						checked
					}}??
					>
					<label for="{{properties[i].name}}-false">false</label>
				</div>
			</div>
		</div>
		}}?

		}}#
	*/}, data)
}

Widget.DatabaseEditObject.prototype = {
	constructor: Widget.DatabaseEditObject
}