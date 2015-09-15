Widget.Error = function (errors) {
	var data = {errors: errors}
	
	this.data = data
	this.html = parse(function(){/*!
	    {{?@ data.errors instanceof Array
	        <div id="errors">
		    <div class="button" title="{{@localize("clickToClose")}}" onclick='Widget.Error.hide();'>
		        <i class="fa fa-times"></i></div>
		    {{# errors[i]
		        <h2 class="hand" style="color: red;">{{errors[i]}}</h2>
		    }}#
		    </div>
	    }}?
	*/}, data)
}

Widget.Error.prototype = {
	constructor: Widget.Error
}

Widget.Error.hide = function (guid) {
    $("#errors").hide()
}