// Util functions

function isEmpty(str) {
	return (!str || 0 === str.length);
}

function getURLParameter(name) {
	return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search)||[,""])[1].replace(/\+/g, '%20'))||null
}

function escapeRegExp(string) {
	return string.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
}

function replaceAll(string, find, replace) {
	return string.replace(new RegExp(escapeRegExp(find), 'g'), replace);
}

function encodeBase64(str) {
	return btoa(unescape(encodeURIComponent(str)));
}

function decodeBase64(str) {
	return decodeURIComponent(escape(atob(str)));
}

function b64Encode(str) {
	return btoa(encodeURIComponent(str).replace(/%([0-9A-F]{2})/g, function(match, p1) {
		return String.fromCharCode('0x' + p1);
	}));
}

function b64Decode(str) {
	return decodeURIComponent(Array.prototype.map.call(atob(str), function(c) {
		return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
	}).join(''));
}


// Widget functions

Widget = {id: '#widgets'} // namespace

function localize(key) {return localization[key][vars.locale]}

Widget.setHtmlToPage = function (html) {
	$(Widget.id).html(html)
}

Widget.guid = function () {
	return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
		var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
		return v.toString(16);
	});
}

Widget.fileNameExtension = function (filename) {
	var a = filename.split(".");
	if( a.length === 1 || ( a[0] === "" && a.length === 2 ) ) {
		return filename;
	}
	return a.pop().toLowerCase();
}

Widget.json = function (data) {
	try {
		return eval("(function(){return " + data + ";})()");
	} catch (err) {
		return null
	}
}

Widget.createHTML = function(text) {
	var pattern_amp = /&/g;
	var pattern_lt = /</g;
	var pattern_gt = />/g;
	var pattern_para = /\r\n/g;
	var html = text.replace(pattern_amp, '&amp;').replace(pattern_lt, '&lt;').replace(pattern_gt, '&gt;').replace(pattern_para, '\n');
	return html
}

Widget.filterArray = function (collection, obj) {
	var res = []
	for (var i = 0; i < collection.length; i++) {
		var success = true
		for (var k in obj) {
			if (success && collection[i][k] != obj[k]) { success = false }
		}
		if (success) { res.push(collection[i]) }
	}
	return res
}

Widget.extractStringUpTo = function (string, toDelimiter, fromIndex) {
	fromIndex = fromIndex || 0

	var toIndex = string.indexOf(toDelimiter, fromIndex)
	if (toIndex >= 0) {
		return string.substring(fromIndex, toIndex)
	} else {
		return string
	}
}

Widget.createContainerCell = function (cell) {
	var html = '<div' 
	if (!isEmpty(cell.id)) {html += ' id="' + cell.id + '"'}
	html += ' class="'
	if (!isEmpty(cell.clazz)) {html += " " + cell.clazz}
	if (!isEmpty(cell.size)) {html += " " + cell.size}
	for (var k in cell) {
		if (k != "rows" && k != "widget" && k != "id" && k != "clazz" && k != "size") {
			var breakPointAndOffset = cell[k].match(/\S+/g)
			for (var i = 0; i < breakPointAndOffset.length; i++) {
				html += " " + breakPointAndOffset[i] + '(' + k + ')'
			}
		}
	}
	html += '">'
	if (cell.widget) {
		html += cell.widget.html || cell.widget // widget or plain string
		html += '</div>'
	}

	return html
}

Widget.createContainerRow = function (row) {
	var html = '<div class="row">'
	for (var i = 0; i < row.length; i++) {
		var cell = row[i]
		if (cell.rows) {
			html += Widget.createContainerCell(cell)
			for (var j = 0; j < cell.rows.length; j++) {
				html += Widget.createContainerRow(cell.rows[j])
			}
			html += '</div>'
		} else {
			html += Widget.createContainerCell(cell)
		}
	}
	html += '</div>'

	return html
}

Widget.setContainerToPage = function (rows) {
	var html = '<div id="main" class="container">'
	for (var i = 0; i < rows.length; i++) {
		if (rows[i] instanceof Array) {
			html += Widget.createContainerRow(rows[i])
		} else {
			var widget = rows[i]
			html += widget.html || widget // widget or plain string
		}
	}
	html += '</div>'

	Widget.setHtmlToPage(html)
}

Widget.setHeader = function (widget) {
	var html = widget.html || widget // widget or plain string
	$(html).insertBefore(Widget.id)
}

Widget.setFooter = function (widget) {
	var html = widget.html || widget // widget or plain string
	$(html).insertAfter(Widget.id)
}

Widget.validateRadioButton = function (name) {
	if ($('input[name=' + name + ']:checked').val()) {
		return true
	} else {
		return false
	}
}

Widget.escapeHtml = function (str) {
	if (!isEmpty(str)) {
		//str = str.replace(/&lt;/g, "&amp;lt;")
		//str = str.replace(/&gt;/g, "&amp;gt;")

		// escape HTML tags
		str = replaceAll(str, "&lt;", "&amp;lt;")
		str = replaceAll(str, "&gt;", "&amp;gt;")

		// escape BD string
		str = replaceAll(str, "'", "''")
	}
	return str
}

Widget.successHandler = function (data, info) {
	if (!isEmpty(data)) {
		var infoPopup = new Widget.InfoPopup({info: "<pre>" + data + "</pre>"})
	} else if (!isEmpty(info)) {
		var infoPopup = new Widget.InfoPopup({info: "<pre>" + info + "</pre>"})
	} else {
		var infoPopup = new Widget.InfoPopup({info: "Done!"})
	}
}

Widget.errorHandler = function (jqXHR, textStatus, errorThrown) {
	if (!isEmpty(jqXHR.responseText)) {
		var infoPopup = new Widget.InfoPopup({info: jqXHR.responseText})
	} else if (!isEmpty(textStatus)) {
		var infoPopup = new Widget.InfoPopup({info: textStatus})
	} else {
		var infoPopup = new Widget.InfoPopup({info: "Error"})
	}
}