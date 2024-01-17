Widget.DatabaseNavigation = function (types) {
  types = types || []

  for (var i = 0; i < types.length; i++) {types[i].guid = Widget.guid()}

  var filteredTypes = []
  for (var i = 0; i < types.length; i++) {
    if (types[i].name.indexOf("-") < 0) {filteredTypes.push(types[i])}
  }

  var data = {types: filteredTypes}

  this.data = data
  this.html = parse(function(){/*!
    {{? types.length > 0
      <ul class="no-bullets">
        {{# types[i]
          <li class="database">
            <div id="{{types[i].guid}}" class="nowrap" 
            onclick='Widget.DatabaseNavigation.selectType("{{types[i].name}}", "{{types[i].guid}}")'>
              <i class="fa fa-database"></i>
              <span class="navigationName">{{types[i].name}}</span>
            </div>
          </li>
        }}#
      </ul>
    }}?
  */}, data)
}

Widget.DatabaseNavigation.prototype = {
  constructor: Widget.DatabaseNavigation,

  init: function () {
    $("#databaseNavigation").css("max-height", Widget.DatabaseTemplate.maxHeight())
  }
}

Widget.DatabaseNavigation.selectType = function (type, guid) {
  Widget.DatabaseNavigation.selectDatabaseGuid(guid)
  Widget.DatabaseNavigation.type = type
}

Widget.DatabaseNavigation.selectDatabaseGuid = function (guid) {
  if (!isEmpty(vars.databaseGuid)) {
    $("#" + vars.databaseGuid).css("font-weight", "normal")
    $("#" + vars.databaseGuid + " span.navigationName").css('text-decoration', 'none')
  }

  vars.databaseGuid = guid
  $("#" + vars.databaseGuid).css("font-weight", "900")
  $("#" + vars.databaseGuid + " span.navigationName").css('text-decoration', 'underline')
}