Widget.EditorNavigation = function (dirs, parent) {
  dirs = dirs || []

  for (var i = 0; i < dirs.length; i++) {dirs[i].guid = Widget.guid();dirs[i].childrenGuid = Widget.guid()}

  var data = {dirs: dirs}

  this.data = data
  this.html = parse(function(){/*!
    {{? dirs.length > 0
      <ul class="no-bullets">
        {{# dirs[i]
          {{?? dirs[i].mode == "directory"
            <li class="{{dirs[i].mode}}">
              <div id="{{dirs[i].guid}}" class="nowrap" 
              onclick='Widget.EditorNavigation.directoryEntries("{{dirs[i].path}}", "{{dirs[i].guid}}", "{{dirs[i].childrenGuid}}")'>
                <i class="fa fa-folder-open"></i>
                <span class="navigationName">{{dirs[i].name}}</span>
              </div>
              <div id="{{dirs[i].childrenGuid}}"></div>
            </li>
          }}??

          {{?? dirs[i].mode == "file"
            <li class="{{dirs[i].mode}}">
              <div id="{{dirs[i].guid}}" class="nowrap" 
              onclick='Widget.EditorNavigation.openFile("{{dirs[i].path}}", "{{dirs[i].guid}}")'
              ondblclick='Widget.EditorHeader.editFile()'>
                <i class="fa fa-file-o"></i>
                <span class="navigationName">{{dirs[i].name}}</span>
              </div>
            </li>
          }}??

          {{?? dirs[i].mode == "unknown"
            <li class="{{dirs[i].mode}}">
              <div id="{{dirs[i].guid}}" class="nowrap">
                <i class="fa fa-exclamation-circle"></i>
                <span class="navigationName">{{dirs[i].name}}</span>
              </div>
            </li>
          }}??
        }}#
      </ul>
    }}?
  */}, data)

  if (parent) {
    this.html = parse(function(){/*!
      <ul class="no-bullets">
        <li class="directory">
          <div id="{{guid}}" class="nowrap" 
          onclick='Widget.EditorNavigation.directoryEntries("{{parent.path}}", "{{guid}}", "{{childrenGuid}}")'>
            <i class="fa fa-folder-open"></i>
            <span class="navigationName">{{parent.name}}</span>
          </div>
          <div id="{{childrenGuid}}">{{children}}</div>
        </li>
      </ul>
    */}, {parent: parent, guid: Widget.guid(), childrenGuid: Widget.guid(), children: this.html})

    // set home directory
    editor.homeDirectory = parent.path
  }
}

Widget.EditorNavigation.prototype = {
  constructor: Widget.EditorNavigation,

  init: function () {
    $("#directoryNavigation").css("max-height", Widget.EditorTemplate.maxHeight())
  }
}

Widget.EditorNavigation.openFile = function (fileName, guid) {
  var newSessionUrl = Widget.EditorHeader.newSessionUrl(property.editorUrl + property.editorFileContentUrl, {f: encodeURIComponent(fileName)}, true)

  $.get(newSessionUrl)
    .success(function (content) {
      editor.fileName = fileName
      Widget.EditorNavigation.selectFileName(guid)

      editor.setValue(content)
      editor.setMode(Widget.fileNameExtension(fileName))

      // var paths = fileName.split('/');
      // var simpleFileName = paths[paths.length - 1]
      // $("#menu").html(simpleFileName)
    })
    .error(Widget.errorHandler)
}

Widget.EditorNavigation.directoryEntries = function (directoryName, guid, childrenGuid) {
  var newSessionUrl = Widget.EditorHeader.newSessionUrl(property.editorUrl + property.editorDirectoryUrl, {d: encodeURIComponent(directoryName)}, true)

  $.get(newSessionUrl)
    .success(function (dirs) {
      editor.directoryName = directoryName
      Widget.EditorNavigation.selectDirectoryName(guid)

      var subdirs = new Widget.EditorNavigation(Widget.json(dirs))
      $('#' + childrenGuid).html(subdirs.html)
    })
    .error(Widget.errorHandler)
}

Widget.EditorNavigation.selectFileName = function (guid) {
  if (!isEmpty(editor.fileGuid)) {
    $("#" + editor.fileGuid).css("font-weight", "normal")
    $("#" + editor.fileGuid + " span.navigationName").css('text-decoration', 'none')
  }

  editor.fileGuid = guid
  $("#" + editor.fileGuid).css("font-weight", "900")
  $("#" + editor.fileGuid + " span.navigationName").css('text-decoration', 'underline')
}

Widget.EditorNavigation.selectDirectoryName = function (guid) {
  if (!isEmpty(editor.directoryGuid)) {
    $("#" + editor.directoryGuid).css("font-weight", "normal")
    $("#" + editor.directoryGuid + " span.navigationName").css('text-decoration', 'none')
  }

  editor.directoryGuid = guid
  $("#" + editor.directoryGuid).css("font-weight", "900")
  $("#" + editor.directoryGuid + " span.navigationName").css('text-decoration', 'underline')
}