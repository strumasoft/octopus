Widget.RepositoryFileHistoryNavigation = function (revisions) {
  revisions = revisions || []

  for (var i = 0; i < revisions.length; i++) {revisions[i].guid = Widget.guid()}

  var data = {revisions: revisions}

  this.data = data

  if (getURLParameter("repository") == "SVN") {
  this.html = parse(function(){/*!
    {{? revisions.length > 0
      <ul id="listbox" class="no-bullets">
        {{# revisions[i]
          <li class="directory">
            <div class="nowrap">
              <input type="checkbox" 
                id="{{revisions[i].guid}}" name="{{revisions[i].guid}}" class="compareRevision"
                revision="{{revisions[i].revision}}">
              <label for="{{revisions[i].guid}}"><pre class="repolog">{{revisions[i].info}}</pre></label>
            </div>
          </li>
        }}#
      </ul>
    }}?
  */}, data)
  } else if (getURLParameter("repository") == "GIT") {
  this.html = parse(function(){/*!
    {{? revisions.length > 0
      <ul id="listbox" class="no-bullets">
        {{# revisions[i]
          <li class="directory">
            <div class="nowrap">
              <input type="checkbox" 
                id="{{revisions[i].guid}}" name="{{revisions[i].guid}}" class="compareRevision"
                revision="{{revisions[i].revision}}"
                fromFile="{{revisions[i].a}}"
                toFile="{{revisions[i].b}}"
                date="{{revisions[i].date}}">
              <label for="{{revisions[i].guid}}"><pre class="repolog">{{revisions[i].info}}</pre></label>
            </div>
          </li>
        }}#
      </ul>
    }}?
  */}, data)
  }
}

Widget.RepositoryFileHistoryNavigation.prototype = {
  constructor: Widget.RepositoryFileHistoryNavigation
}