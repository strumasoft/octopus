Widget.DatabaseHeader = function (data) {
  data.color = property.baseline_color2
  
  this.data = data
  this.html = parse(function(){/*!
    <header id="header" class="skel-layers-fixed">
      <h1><div id="dbmenu" class="hand">Database</div></h1>
      <nav id="nav">
        <ul>
          <!-- Login -->
          <li><div id="login" class="hand" 
            onclick='Widget.DatabaseHeader.login();'>
            <i class="fa fa-user-secret"></i></div>
          </li>

          <!-- Open New Window -->
          <li><a id="openNewWindowAction" class="hand" style="color: {{color}};"
            href="" target="_blank">
            <i class="fa fa-share"></i></a>
          </li>

          <!-- Search -->
          <li><div id="searchAction" class="hand" 
            onclick='Widget.DatabaseHeader.search();'>
            <i class="fa fa-search"></i></div>
          </li>

          <!-- Execute -->
          <li><div id="executeAction" class="hand" 
            onclick='Widget.DatabaseHeader.execute();'>
            <i class="fa fa-play"></i></div>
          </li>

          <!-- Add -->
          <li><div id="addAction" class="hand" 
            onclick='Widget.DatabaseHeader.add();'>
            <i class="fa fa-plus"></i></div>
          </li>

          <!-- Delete -->
          <li><div id="deleteAction" class="hand" 
            onclick='Widget.DatabaseHeader.delete();'>
            <i class="fa fa-minus"></i></div>
          </li>

          <!-- Edit -->
          <li><div id="editAction" class="hand" 
            onclick='Widget.DatabaseHeader.edit();'>
            <i class="fa fa-pencil-square-o"></i></div>
          </li>

          <!-- Save -->
          <li><div id="saveAction" class="hand" 
            onclick='Widget.DatabaseHeader.save();'>
            <i class="fa fa-floppy-o"></i></div>
          </li>

          <!-- Refresh -->
          <li><div id="refreshAction" class="hand" 
            onclick='Widget.DatabaseHeader.refresh();'>
            <i class="fa fa-refresh"></i></div>
          </li>


          <!-- Tabs -->

          {{# tabs[i]
            <li><div id="{{tabs[i].guid}}" class="button special databaseTabButton" 
              onclick='Widget.DatabaseHeader.showTab("{{tabs[i].id}}", "{{tabs[i].guid}}");'>
              {{tabs[i].name}}</div>
            </li>
          }}#
        </ul>
      </nav>
    </header>
  */}, data)
}

Widget.DatabaseHeader.prototype = {
  constructor: Widget.DatabaseHeader
}

Widget.DatabaseHeader.height = function () {
  return $('#header').height()
}


//
// login
//

Widget.DatabaseHeader.login = function () {
  var loginPopup = new Widget.TwoFieldsPopup({placeholder1: "Email", placeholder2: "Password", password: 2, proceed: function (emailGuid, passwordGuid) {
    var email = $("#" + emailGuid).val()
    var password = $("#" + passwordGuid).val()

    if (!isEmpty(email) && !isEmpty(password)) {
      $.post(property.securityLoginUserUrl, {email: email, password: password})
        .success(function (data) {
          Widget.successHandler(data)
        })
        .error(Widget.errorHandler)

      this.delete()
    } else {
      this.delete()
      var infoPopup = new Widget.InfoPopup({info: "Email and Password are required!"})
    }
  }})
}


//
// search
//

Widget.DatabaseHeader.search = function () {
  var type = Widget.DatabaseNavigation.type
  if (!isEmpty(type)) {
    var questionPopup = new Widget.QuestionPopup({question: "Search " + type + "?", proceed: function () {
      if (type.indexOf(".") > -1) {
        editor.setValue('return db:find({["' + type + '"] = {}})')
      } else {
        editor.setValue('return db:find({' + type + ' = {}})')
      }

      Widget.DatabaseHeader.showTab(vars.scriptTab.id, vars.scriptTab.guid)

      this.delete()
    }})
  } else {
    var infoPopup = new Widget.InfoPopup({info: "Select type!"})
  }
}

Widget.DatabaseHeader.setContentTo = function (tab, html) {
  $('#' + tab.id + " > .resultbox").html(html)
}

Widget.DatabaseHeader.setContentToEditTab = function (data) {
  var array = Widget.json(data)

  if (array instanceof Array) {
    var editObject = new Widget.DatabaseEditObject(array)
    Widget.DatabaseHeader.setContentTo(vars.editTab, editObject.html)
  } else {
    Widget.DatabaseHeader.setContentTo(vars.editTab, data)
  }

  Widget.DatabaseHeader.showTab(vars.editTab.id, vars.editTab.guid)
}


//
// execute
//

Widget.DatabaseHeader.execute = function () {
  if ($('#' + vars.scriptTab.id).is(':visible')) {
    var content = editor.getValue()
    if (!isEmpty(content)) {
      $.post(property.databaseUrl + property.databaseExecuteUrl, content)
        .success(function (data) {
          var array = Widget.json(data)
          if (array instanceof Array) {
            var databaseResults = new Widget.DatabaseResult(array)
            Widget.DatabaseHeader.setContentTo(vars.resultTab, databaseResults.html)
          } else {
            Widget.DatabaseHeader.setContentTo(vars.resultTab, data)
          }

          Widget.DatabaseHeader.showTab(vars.resultTab.id, vars.resultTab.guid)
        })
        .error(Widget.errorHandler)
    } else {
      var infoPopup = new Widget.InfoPopup({info: "Script is empty!"})
    }
  } else {
    var infoPopup = new Widget.InfoPopup({info: "Select script tab!"})
  }
}


//
// add
//

Widget.DatabaseHeader.add = function () {
  var type = Widget.DatabaseNavigation.type
  if (!isEmpty(type)) {
    var questionPopup = new Widget.QuestionPopup({question: "Create " + type + "?", proceed: function () {
      $.get(property.databaseUrl + property.databaseAddUrl, {type: type})
        .success(Widget.DatabaseHeader.setContentToEditTab)
        .error(Widget.errorHandler)

      this.delete()
    }})
  } else {
    var infoPopup = new Widget.InfoPopup({info: "Select type!"})
  }
}

Widget.DatabaseHeader.addReference = function (addId) {
  var input = $("#" + addId)

  if (!isEmpty(input.val())) {
    var questionPopup = new Widget.QuestionPopup({question: "Add reference?", proceed: function () {
      var addRequest = {
        id: input.val(), 
        parentId: input.attr("objectParentId"), 
        from: input.attr("objectFrom"),
        to: input.attr("objectTo")
      }

      $.get(property.databaseUrl + property.databaseAddReferenceUrl, addRequest)
        .success(function (data) {
          Widget.successHandler(data)
          Widget.DatabaseHeader.refresh()
        })
        .error(Widget.errorHandler)

      this.delete()
    }})
  } else {
    var infoPopup = new Widget.InfoPopup({info: "Write reference id!"})
  }
}


//
// delete
//

Widget.DatabaseHeader.delete = function () {
  if ($('#' + vars.resultTab.id).is(':visible')) {
    Widget.DatabaseHeader.deleteObject()
  } else if ($('#' + vars.editTab.id).is(':visible')) {
    Widget.DatabaseHeader.deleteReference()
  } else {
    var infoPopup = new Widget.InfoPopup({info: "Select result or edit tab!"})
  }
}

Widget.DatabaseHeader.deleteObject = function () {
  var results = []

  $(".databaseResult").each(function(index) {
    if ($(this).is(':checked')) {
      results.push({id: $(this).attr("objectId"), type: $(this).attr("objectType")})
    }
  })

  if (results.length > 0) {
    var questionPopup = new Widget.QuestionPopup({question: "Delete selected objects?", proceed: function () {
      $.post(property.databaseUrl + property.databaseDeleteUrl, JSON.stringify(results))
        .success(function (data) {
          Widget.successHandler(data)
        })
        .error(Widget.errorHandler)

      this.delete()
    }})
  } else {
    var infoPopup = new Widget.InfoPopup({info: "Select object to delete!"})
  }
}

Widget.DatabaseHeader.deleteReference = function () {
  var results = []

  $(".databaseEdit").each(function(index) {
    if ($(this).is(':checked')) {
      results.push({
        id: $(this).attr("objectId"), 
        parentId: $(this).attr("objectParentId"), 
        from: $(this).attr("objectFrom"),
        to: $(this).attr("objectTo")
      })
    }
  })

  if (results.length > 0) {
    var questionPopup = new Widget.QuestionPopup({question: "Delete selected references?", proceed: function () {
      $.post(property.databaseUrl + property.databaseDeleteReferenceUrl, JSON.stringify(results))
        .success(function (data) {
          Widget.successHandler(data)
          Widget.DatabaseHeader.refresh()
        })
        .error(Widget.errorHandler)

      this.delete()
    }})
  } else {
    var infoPopup = new Widget.InfoPopup({info: "Select reference to delete!"})
  }
}

Widget.DatabaseHeader.deleteAllReferences = function (from ,to, parentId) {
  var questionPopup = new Widget.QuestionPopup({question: "Delete all " + from + " references?", proceed: function () {
    $.post(property.databaseUrl + property.databaseDeleteAllReferencesUrl, {from: from, to: to, parentId: parentId})
      .success(function (data) {
        Widget.successHandler(data)
        Widget.DatabaseHeader.refresh()
      })
      .error(Widget.errorHandler)
    this.delete()
  }})
}


//
// edit
//

Widget.DatabaseHeader.edit = function () {
  if ($('#' + vars.resultTab.id).is(':visible')) {
    Widget.DatabaseHeader.editObject(".databaseResult")
  } else if ($('#' + vars.editTab.id).is(':visible')) {
    Widget.DatabaseHeader.editObject(".databaseEdit")
  } else {
    var infoPopup = new Widget.InfoPopup({info: "Select result or edit tab!"})
  }
}

Widget.DatabaseHeader.editObject = function (objectSelector) {
  var results = []

  $(objectSelector).each(function(index) {
    if ($(this).is(':checked')) {
      results.push({id: $(this).attr("objectId"), type: $(this).attr("objectType")})
    }
  })

  if (results.length == 1) {
    var questionPopup = new Widget.QuestionPopup({question: "Edit object?", proceed: function () {
      $.get(property.databaseUrl + property.databaseEditUrl, {id: results[0].id, type: results[0].type})
        .success(Widget.DatabaseHeader.setContentToEditTab)
        .error(Widget.errorHandler)

      this.delete()
    }})
  } else {
    var infoPopup = new Widget.InfoPopup({info: "Select only 1 object to edit!"})
  }
}


//
// save
//

Widget.DatabaseHeader.save = function () {
  if ($('#' + vars.editTab.id).is(':visible')) {
    var spec = {}

    var objectSpec = $("#databaseObjectSpec")
    if (!isEmpty(objectSpec.attr("objectId"))) {spec.id = objectSpec.attr("objectId")}
    if (!isEmpty(objectSpec.attr("objectType"))) {spec.type = objectSpec.attr("objectType")}


    var properties = {}

    $(".databaseObjectProperty").each(function(index) {
      if ($(this).attr("type") == "radio") {
        if ($(this).is(':checked')) {
          properties[$(this).attr("name")] = $(this).attr("booleanValue")
        }
      } else {
        properties[$(this).attr("name")] = $(this).val()
      }
    })

    if (Object.keys(properties).length > 0) {
      var questionPopup = new Widget.QuestionPopup({question: "Save properties?", proceed: function () {
        $.post(property.databaseUrl + property.databaseSaveUrl, JSON.stringify({spec: spec, properties: properties}))
          .success(function (data) {
            var obj = Widget.json(data)
            if (obj) { // data is object, not plain error string
              if (isEmpty(spec.id)) {
                $.get(property.databaseUrl + property.databaseEditUrl, {id: obj.id, type: spec.type})
                  .success(Widget.DatabaseHeader.setContentToEditTab)
                  .error(Widget.errorHandler)
              }
              var infoPopup = new Widget.InfoPopup({info: obj.info})
            } else {
              var infoPopup = new Widget.InfoPopup({info: data})
            }
          })
          .error(Widget.errorHandler)

        this.delete()
      }})
    } else {
      var infoPopup = new Widget.InfoPopup({info: "No object to save!"})
    }
  } else {
    var infoPopup = new Widget.InfoPopup({info: "Select edit tab!"})
  }
}


//
// refresh
//

Widget.DatabaseHeader.refresh = function () {
  if ($('#' + vars.editTab.id).is(':visible')) {
    var spec = {}

    var objectSpec = $("#databaseObjectSpec")
    if (!isEmpty(objectSpec.attr("objectId"))) {spec.id = objectSpec.attr("objectId")}
    if (!isEmpty(objectSpec.attr("objectType"))) {spec.type = objectSpec.attr("objectType")}

    if (spec.id) {
      var questionPopup = new Widget.QuestionPopup({question: "Refresh object?", proceed: function () {
        $.get(property.databaseUrl + property.databaseEditUrl, {id: spec.id, type: spec.type})
          .success(Widget.DatabaseHeader.setContentToEditTab)
          .error(Widget.errorHandler)

        this.delete()
      }})
    } else {
      var infoPopup = new Widget.InfoPopup({info: "No object to refresh!"})
    }
  } else {
    var infoPopup = new Widget.InfoPopup({info: "Select edit tab!"})
  }
}

Widget.DatabaseHeader.showTab = function (tabGuid, tabButtonGuid) {
  $(".databaseTab").hide()
  $(".databaseTabButton").css('text-decoration', 'none')

  $("#" + tabGuid).show()
  $("#" + tabButtonGuid).css('text-decoration', 'underline')
}