Widget.DatabaseResult = function (results) {
  var type
  if (results.length > 0 && typeof(results[results.length - 1]) == "string") {
    type = results.splice(results.length - 1, 1)[0]
  } else {
    type = ""
  }

  var guid = []
  for (var i = 0; i < results.length; i++) {guid.push(Widget.guid())}

  var data = {type: type, results: results, guid: guid}

  this.data = data
  this.html = parse(function(){/*!
    {{? results.length > 0
      <h3>{{type}}</h3>

      <div class="table-wrapper">
        <table>
          <tbody>
            {{# results[i]
            <tr>
              <td>
                <input type="checkbox" 
                  objectType="{{type}}"
                  objectId="{{results[i].id}}"
                  id="{{guid[i]}}" 
                  name="{{guid[i]}}" 
                  class="databaseResult">
                <label for="{{guid[i]}}">{{@JSON.stringify(data.results[i])}}</label>
              </td>
            </tr>
            }}#
          </tbody>
        </table>
      </div>
    }}?
  */}, data)
}

Widget.DatabaseResult.prototype = {
  constructor: Widget.DatabaseResult
}