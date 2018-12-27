Widget.RepositoryTemplate = function (data) {
	this.data = data
	this.html = parse(function(){/*!
		<div id="main" class="container">
			<!-- Header -->
			{{header}}

			<div class="row">
				<div class="12u">
					{{navigation}}
				</div>
			</div>
			<div class="row">
				<div class="12u">
					{{diff}}
				</div>
			</div>
		</div>
	*/}, data)
}

Widget.RepositoryTemplate.prototype = {
	constructor: Widget.RepositoryTemplate
}