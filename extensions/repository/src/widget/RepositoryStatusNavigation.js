Widget.RepositoryStatusNavigation = function (statuses) {
	statuses = statuses || []

	for (var i = 0; i < statuses.length; i++) {statuses[i].guid = Widget.guid()}

	var data = {statuses: statuses}

	this.data = data
	if (getURLParameter("repository") == "SVN") {
	this.html = parse(function(){/*!
		{{? statuses.length > 0
			<ul id="listbox" class="no-bullets">
				{{# statuses[i]
					<li class="directory">
						<div class="nowrap">
							<input type="checkbox" 
							id="{{statuses[i].guid}}" name="{{statuses[i].guid}}" class="compareRevision"
							oldRevision="{{statuses[i].oldRevision}}"
							newRevision="{{statuses[i].newRevision}}"
							fileName="{{statuses[i].fileName}}"
							revertRevisions="{{statuses[i].revertRevisions}}">
							<label for="{{statuses[i].guid}}"><pre class="repolog">{{statuses[i].info}}</pre></label>
						</div>
					</li>
				}}#
			</ul>
		}}?
	*/}, data)
	} else if (getURLParameter("repository") == "GIT") {
	this.html = parse(function(){/*!
		{{? statuses.length > 0
			<ul id="listbox" class="no-bullets">
				{{# statuses[i]
					<li class="directory">
						<div class="nowrap">
							<input type="checkbox" 
							id="{{statuses[i].guid}}" name="{{statuses[i].guid}}" class="compareRevision"
							oldRevision="{{statuses[i].oldRevision}}"
							newRevision="{{statuses[i].newRevision}}"
							fileName="{{statuses[i].fileName}}"
							newFileName="{{statuses[i].newFileName}}">
							<label for="{{statuses[i].guid}}"><pre class="repolog">{{statuses[i].info}}</pre></label>
						</div>
					</li>
				}}#
			</ul>
		}}?
	*/}, data)
	}
}

Widget.RepositoryStatusNavigation.prototype = {
	constructor: Widget.RepositoryStatusNavigation
}