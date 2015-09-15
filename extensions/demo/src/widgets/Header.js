Widget.Header = function (data) {
    data = data || {}
    
	this.data = data
	this.html = parse(function(){/*!
		<header id="header" class="skel-layers-fixed">
			<nav id="nav">
				<ul>
				    <li><a class="button special hand" style="color: white;"
				        href="/">{{@localize("index")}}</a>
				    </li>
				    <li><a class="button special hand" style="color: white;"
				        href="">{{@localize("reload")}}</a>
				    </li>
				    <li><a class="button special hand" style="color: white;"
				        onclick='Widget.Header.showError()'>{{@localize("showError")}}</a>
				    </li>
				</ul>
			</nav>
		</header>
	*/}, data)
}

Widget.Header.prototype = {
	constructor: Widget.Header
}

Widget.Header.showError = function () {
    if($("#errors").length == 0) {
        var infoPopup = new Widget.InfoPopup({info: localize("noErrors")})
    } else {
        $("#errors").show()
    }
}