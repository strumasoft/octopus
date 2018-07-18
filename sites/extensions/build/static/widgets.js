/* property */ 

var property = {"baseline_color5":"144, 144, 144","compareUrl":"/compare","checkoutReviewOrderUrl":"/checkout/reviewOrder","baseline_color06":"0, 0, 0","sourceCtxPath":"","editorSearchUrl":"/search","repositoryUrl":"/repository","baseline_color05":"#f2f2f2","databaseDeleteAllReferencesUrl":"/deleteAllReferences","databaseEditUrl":"/edit","databaseExecuteUrl":"/execute","baseline_color8":"#595959","repositoryFileRevisionContentUrl":"/fileRevisionContent","loginUrl":"/login","databaseAddUrl":"/add","databaseHomeUrl":"","failedLoginAttemptsTimeout":10800,"databaseAddReferenceUrl":"/addReference","repositoryLogHistoryUrl":"/logHistory","checkoutSetPaymentMethodUrl":"/checkout/setPaymentMethod","accountUrl":"/account","pictureHeight":"400px","repositoryCommitHistoryUrl":"/commitHistory","baseline_color4":"#666","repositoryFileHistoryUrl":"/fileHistory","accountOrderUrl":"/account/order","baseline_color2":"#444","testUrl":"/test","debugDB":false,"baseline_color03":"#cdede4","repositoryFileDiffUrl":"/fileDiff","editorHomeUrl":"","requireSecurity":false,"repositoryUpdateUrl":"/update","checkoutAddressesUrl":"/checkout/addresses","addToCartUrl":"/cart/add","checkoutPlaceOrderUrl":"/checkout/placeOrder","baseline_color1":"#fff","updateProductEntryUrl":"/cart/update","baseline_color07":"#555","baseline_font2":"\"Courier New\", monospace","registerUrl":"/register","thumbnailPictureWidth":"46px","repositoryCommitUrl":"/commit","thumbnailPictureHeight":"62px","accountAddUpdateAddressUrl":"/account/addUpdateAddress","checkoutAddAddressUrl":"/checkout/addAddress","accountOrdersUrl":"/account/orders","changeLocaleUrl":"/changeLocale","baseline_color3":"#49bf9d","editorCreateFileUrl":"/createFile","accountRemoveAddressUrl":"/account/removeAddress","pictureWidth":"300px","usePreparedStatement":true,"shopHomeUrl":"/home","accountAddressesUrl":"/account/addresses","sessionTimeout":3600,"failedLoginAttempts":7,"securityRegisterUserUrl":"/security/registerUser","editorDirectoryUrl":"/directory","editorCreateDirectoryUrl":"/createDirectory","shopUrl":"/shop","selectedColor":"#1e90ff","checkoutUrl":"/checkout","productUrl":"/product","editorFileContentUrl":"/fileContent","checkoutSetDeliveryMethodUrl":"/checkout/setDeliveryMethod","editorRenameUrl":"/rename","databaseDeleteReferenceUrl":"/deleteReference","accountAddressUrl":"/account/address","baseline_font1":"Arial, Helvetica, sans-serif","securityRegisterUrl":"/security/register","checkoutPaymentMethodUrl":"/checkout/paymentMethod","editorSaveUrl":"/save","cartUrl":"/cart","editorEditFileUrl":"/editFile","editorRemoveUrl":"/remove","octopusHostDir":"/data/Project/octopus_orig/bin/unix/../../sites/extensions","checkoutAddressUrl":"/checkout/address","checkoutDeliveryMethodUrl":"/checkout/deliveryMethod","categoryUrl":"/category","databaseUrl":"/database","repositoryStatusUrl":"/status","forbidDirectSqlQuery":true,"changeCountryUrl":"/changeCountry","baseline_color7":"#737373","baseline_color9":"#5cc6a7","repositoryAddUrl":"/add","baseline_color02":"#ccc","databaseDeleteUrl":"/delete","securityLoginUrl":"/security/login","editorUrl":"/editor","repositoryRefreshUrl":"/refresh","defaultCountryIsocode":"GB","baseline_color01":"#3eb08f","baseline_color6":"#bbb","securityLoginUserUrl":"/security/loginUser","fileUploadChunkSize":8196,"checkoutConfirmationUrl":"/checkout/confirmation","redirectErrorToOutputStream":" 2>&1","mainColor":"#49bf9d","baseline_color04":"#f6f6f6","editorUploadFileUrl":"/uploadFile","checkoutSetAddressUrl":"/checkout/setAddress","debugRepo":false,"repositoryRevertUrl":"/revert","repositoryDeleteUrl":"/delete","repositoryMergeUrl":"/merge","databaseSaveUrl":"/save"}


/* localization */ 

var localization = {"addToCart":{"en":"Buy","bg":"Купи"},"checkoutMessage":{"en":"Checkout","bg":"Поръчай"},"addAddress":{"en":"Add Address","bg":"Добави Адрес"},"continue":{"en":"Continue","bg":"Продължи"},"cancel":{"en":"Cancel","bg":"Откажи"},"viewOrder":{"en":"Veiw Order","bg":"Прегледай Поръчка"},"homeMessage":{"en":"Home","bg":"Начало"},"copyright":{"en":"&copy; cyberz.eu. All rights reserved.","bg":"&copy; cyberz.eu. Всички права запазени."},"placeOrder":{"en":"Place Order","bg":"Направи Поръчка"},"removeAddress":{"en":"Remove Address","bg":"Премахни Адрес"},"showError":{"en":"Show Error","bg":"Покажи Грешката"},"accountMessage":{"en":"Account","bg":"Профил"},"cartMessage":{"en":"Cart","bg":"Кошница"},"helloMessage":{"en":"Hello World","bg":"Здравейте!!!!"},"noErrors":{"en":"no errors","bg":"няма грешки"},"reload":{"en":"Reload","bg":"Презареди"},"updateAddress":{"en":"Update Address","bg":"Промени Адрес"},"index":{"en":"Index","bg":"начало"},"clickToClose":{"en":"click to close","bg":"натисни за да го скриеш"},"edit":{"en":"Edit","bg":"Редактирай"},"editAddress":{"en":"Edit Address","bg":"Редактирай Адрес"},"setAddress":{"en":"Set Addres","bg":"Избери Адрес"}}


/* [parse] /data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core/src/js/parse.js */ 

/* parse.js v1.0.0 | Copyright (C) 2015, Lazar Gyulev, cyberz.eu@gmail.com, www.cyberz.eu | MIT licensed */


/*
	* multiply string
	* 
	* str - string to multiply
	* n - number of times to multiply
	*
	*/
function multiplyString (str, n) {
	var s = ""

	for (var i = 0; i < n; i++) {
		s += str
	}

	return s
}


/*
	* transform template
	* 
	* text - text to be parsed
	* data - table of data
	* delimiter - {open: "{{", close: "}}", preserve: false}
	* nestedCycles - the number of nested cycles
	* iterators - table of iterators
	* nestedConditions - the number of nested conditions
	* 
	* nested cycles/conditions must have multiple #/? depending from the layer
	* 
	* 
	* REPLACE:
	* 
	* {{amount}} 
	* 
	* 
	* CYCLE:
	* 
	* {{# array[i]
	* }}#
	* 
	* cycle iterators must have different names
	* 
	* 
	* CONDITION:
	* 
	* {{? age > 10 || ( name == "ivan" )
	* }}?
	* 
	* always put space before property name
	* 
	*/
function transform (text, data, delimiter, nestedCycles, iterators, nestedConditions) {
	var substrings = []

	var iteratorIndex = 0
	do {
		var startDelimiterIndex = text.indexOf(delimiter.open, iteratorIndex)
		if (startDelimiterIndex >= 0) {
			if (delimiter.preserve) {
				substrings.push(text.substring(iteratorIndex, startDelimiterIndex + delimiter.open.length))
			} else {
				substrings.push(text.substring(iteratorIndex, startDelimiterIndex))
			}

			if (text.charAt(startDelimiterIndex + delimiter.open.length + nestedCycles) == "#") { // cycle
				var startExpressionIndex = startDelimiterIndex + delimiter.open.length + nestedCycles + 1 // one more because #

				// find array name and index name
				// array[i]
				var arrayExpressionEndIndex = text.indexOf("\n", startExpressionIndex)
				var arrayExpression = text.substring(startExpressionIndex, arrayExpressionEndIndex)

				var arrayStartBracketIndex = arrayExpression.lastIndexOf("[")
				var arrayEndBracketIndex = arrayExpression.lastIndexOf("]")

				var arrayName = arrayExpression.substring(0, arrayStartBracketIndex)
				var indexName = arrayExpression.substring(arrayStartBracketIndex + 1, arrayEndBracketIndex)

				// find element that will be repeated
				var endDelimiter = delimiter.close + "#" + multiplyString("#", nestedCycles)
				var endDelimiterIndex = text.indexOf(endDelimiter, arrayExpressionEndIndex + 1)
				while (text.charAt(endDelimiterIndex + endDelimiter.length) == "#") {
					endDelimiterIndex = text.indexOf(endDelimiter, endDelimiterIndex + 1)
				}

				// replace iterators
				var transformedArrayName = transform(arrayName.trim(), iterators, {open: "[", close: "]", preserve: true}, 0, {}, 0)

				// evaluate array
				var evaluationExpresion = "data." + transformedArrayName
				var evaluation = []
				try {
					evaluation = eval(evaluationExpresion)
				} catch (err) {
					console.log(err + " ==> " + evaluationExpresion)
				}

				var array = evaluation
				if (array instanceof Array && array.length > 0) { // do not iterate over non-existing or empty arrays
					var element = text.substring(arrayExpressionEndIndex + 1, endDelimiterIndex)
					for (var i = 0; i < array.length; i++) {
						iterators[indexName.trim()] = i
						substrings.push(transform(element, data, delimiter, nestedCycles + 1, iterators, nestedConditions))
					}
				}

				iteratorIndex = endDelimiterIndex + delimiter.close.length + nestedCycles + 1 // one more because #
			} else if (text.charAt(startDelimiterIndex + delimiter.open.length + nestedConditions) == "?") { // condition
				var startExpressionIndex = startDelimiterIndex + delimiter.open.length + nestedConditions + 1 // one more because ?

				// find conditional expression
				var conditionalExpressionEndIndex = text.indexOf("\n", startExpressionIndex)
				var conditionalExpression = text.substring(startExpressionIndex, conditionalExpressionEndIndex) // do not trim; always put space before propertyName

				// find element that will be conditioned
				var endDelimiter = delimiter.close + "?" + multiplyString("?", nestedConditions)
				var endDelimiterIndex = text.indexOf(endDelimiter, conditionalExpressionEndIndex + 1)
				while (text.charAt(endDelimiterIndex + endDelimiter.length) == "?") {
					endDelimiterIndex = text.indexOf(endDelimiter, endDelimiterIndex + 1)
				}

				var transformedConditionalExpression
				if (conditionalExpression.indexOf("@") == 0) { // @ expression
					transformedConditionalExpression = conditionalExpression.substring(1)
				} else {    
					// prepend properties with 'data.'
					transformedConditionalExpression = ""
					var regexIndex = 0
					var regex = /\s[A-Za-z]+/g;
					while ((match = regex.exec(conditionalExpression)) != null) {
						transformedConditionalExpression += conditionalExpression.substring(regexIndex, match.index + 1) + "data."
						regexIndex = match.index + 1
					}
					transformedConditionalExpression += conditionalExpression.substring(regexIndex, conditionalExpression.length)
				}

				// replace iterators
				transformedConditionalExpression = transform(transformedConditionalExpression.trim(), iterators, {open: "[", close: "]", preserve: true}, 0, {}, 0)

				// evaluate condition
				var evaluationExpresion = transformedConditionalExpression
				var evaluation = false
				try {
					evaluation = eval(evaluationExpresion)
				} catch (err) {
					console.log(err + " ==> " + evaluationExpresion)
				}

				if (evaluation) {
					var element = text.substring(conditionalExpressionEndIndex + 1, endDelimiterIndex)
					substrings.push(transform(element, data, delimiter, nestedCycles, iterators, nestedConditions + 1))
				}

				iteratorIndex = endDelimiterIndex + delimiter.close.length + nestedConditions + 1 // one more because ?
			} else { // replace
				var startExpressionIndex = startDelimiterIndex + delimiter.open.length
				var endDelimiterIndex = text.indexOf(delimiter.close, startExpressionIndex)

				var propertyName = text.substring(startExpressionIndex, endDelimiterIndex)

				if (isNaN(propertyName)) {
					var transformedPropertyName = transform(propertyName.trim(), iterators, {open: "[", close: "]", preserve: true}, 0, {}, 0)

					var evaluationExpresion
					if (transformedPropertyName.indexOf("@") == 0) { // @ expression
						evaluationExpresion = transformedPropertyName.substring(1)
					} else {
						evaluationExpresion = "data." + transformedPropertyName
					}

					var evaluation = ""
					try {
						evaluation = eval(evaluationExpresion)
					} catch (err) {
						console.log(err + " ==> " + evaluationExpresion)
					}

					substrings.push(evaluation)
				} else {
					substrings.push(propertyName.trim())
				}

				if (delimiter.preserve) {
					iteratorIndex = endDelimiterIndex
				} else {
					iteratorIndex = endDelimiterIndex + delimiter.close.length
				}
			}
		} else {
			substrings.push(text.substring(iteratorIndex, text.length))
		}
	} while (startDelimiterIndex >= 0)

	// concat substrings
	return substrings.join("")
}


/*
	* multi line string
	* 
	* f - multi line string function
	*
	*/
function multiLineString (f) {
	//return f.toString().slice(15,-3) // (14,-3) without ! // (15,-3) with !
	return f.toString().replace(/^[^\/]+\/\*!?/, '').replace(/\*\/[^\/]+$/, '')
}


/*
	* parse template
	* 
	* x - multi line string function OR text to be parsed
	* data - table of data
	* 
	*/
function parse(x, data) {
	var text
	if (typeof x === "function") {
		text = multiLineString(x)
	} else {
		text = x
	}

	return transform(text, data, {open: "{{", close: "}}", preserve: false}, 0, {}, 0)
}



/*
	Copyright (C) 2015, Lazar Gyulev, cyberz.eu@gmail.com, www.cyberz.eu

	Permission is hereby granted, free of charge, to any person obtaining a
	copy of this software and associated documentation files (the
	"Software"), to deal in the Software without restriction, including
	without limitation the rights to use, copy, modify, merge, publish,
	distribute, sublicense, and/or sell copies of the Software, and to
	permit persons to whom the Software is furnished to do so, subject to
	the following conditions:

	The above copyright notice and this permission notice shall be included
	in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
	CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
	TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
	SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/


/* [widget] /data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core/src/js/widget.js */ 

Widget = {id: '#widgets'} // namespace


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


// onclick='   ;Widget.stopPropagation(event);'
Widget.stopPropagation = function (e) {
	if (typeof e.stopPropagation != "undefined") {
		e.stopPropagation();
	} else {
		e.cancelBubble = true;
	}
}


Widget.json = function (data) {
	try {
		return eval("(function(){return " + data + ";})()");
	} catch (err) {
		return null
	}
}


function isEmpty(str) {
	return (!str || 0 === str.length);
}


function getURLParameter(name) {
	return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search)||[,""])[1].replace(/\+/g, '%20'))||null
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


function localize(key) {
	return localization[key][vars.locale]
}


Widget.validateRadioButton = function (name) {
	if ($('input[name=' + name + ']:checked').val()) {
		return true
	} else {
		return false
	}
}


function escapeRegExp(string) {
	return string.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
}


function replaceAll(string, find, replace) {
	return string.replace(new RegExp(escapeRegExp(find), 'g'), replace);
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


/* [QuestionPopup] /data/Project/octopus_orig/bin/unix/../../sites/extensions/baseline/src/widgets/popup/QuestionPopup.js */ 

Widget.QuestionPopup = function (data) {
	var info = parse(function(){/*!
		<h1>{{question}}</h1>

		<button class="button" 
			onclick='vars.questionPopup.delete()'>
			No
		</button>
		<button class="button special" 
			onclick='vars.questionPopup.proceed()'>
			OK
		</button>
	*/}, data)

	this.popup = new Widget.Popup({info: info})
	this.popup.proceed = data.proceed
	vars.questionPopup = this.popup
	this.popup.init()
}

Widget.QuestionPopup.prototype = {
	constructor: Widget.QuestionPopup
}


/* [TwoFieldsPopup] /data/Project/octopus_orig/bin/unix/../../sites/extensions/baseline/src/widgets/popup/TwoFieldsPopup.js */ 

Widget.TwoFieldsPopup = function (data) {
	data.guid1 = Widget.guid()
	data.guid2 = Widget.guid()

	var info = parse(function(){/*!
		{{?@ !isEmpty(data.info)
			<h1>{{info}}</h1>
		}}?

		<input class="spaced-down"
			{{? password == 1
				type="password"
			}}?
			{{? password != 1
				type="text"
			}}?
			id="{{guid1}}" placeholder="{{placeholder1}}" value="" />

		<input class="spaced-down"
			{{? password == 2
				type="password"
			}}?
			{{? password != 2
				type="text"
			}}? 
			id="{{guid2}}" placeholder="{{placeholder2}}" value="" />

		<button class="button" 
			onclick='vars.twoFieldsPopup.delete()'>
			No
		</button>
		<button class="button special" 
			onclick='vars.twoFieldsPopup.proceed("{{guid1}}", "{{guid2}}")'>
			Yes
		</button>
	*/}, data)

	this.popup = new Widget.Popup({info: info})
	this.popup.proceed = data.proceed
	vars.twoFieldsPopup = this.popup
	this.popup.init()
}

Widget.TwoFieldsPopup.prototype = {
	constructor: Widget.TwoFieldsPopup
}


/* [InfoPopup] /data/Project/octopus_orig/bin/unix/../../sites/extensions/baseline/src/widgets/popup/InfoPopup.js */ 

Widget.InfoPopup = function (data) {
	var info = parse(function(){/*!
		<h1>{{info}}</h1>

		<button class="button special" 
			onclick='vars.infoPopup.delete()'>
			OK
		</button>
	*/}, data)

	this.popup = new Widget.Popup({info: info})
	vars.infoPopup = this.popup
	this.popup.init()
}

Widget.InfoPopup.prototype = {
	constructor: Widget.InfoPopup
}


/* [ThreeFieldsPopup] /data/Project/octopus_orig/bin/unix/../../sites/extensions/baseline/src/widgets/popup/ThreeFieldsPopup.js */ 

Widget.ThreeFieldsPopup = function (data) {
	data.guid1 = Widget.guid()
	data.guid2 = Widget.guid()
	data.guid3 = Widget.guid()

	var info = parse(function(){/*!
		{{?@ !isEmpty(data.info)
			<h1>{{info}}</h1>
		}}?

		<input class="spaced-down"
			{{? password == 1
				type="password"
			}}?
			{{? password != 1
				type="text"
			}}?
			id="{{guid1}}" placeholder="{{placeholder1}}" value="" />

		<input class="spaced-down"
			{{? password == 2
				type="password"
			}}?
			{{? password != 2
				type="text"
			}}? 
			id="{{guid2}}" placeholder="{{placeholder2}}" value="" />

		<input class="spaced-down"
			{{? password == 3
				type="password"
			}}?
			{{? password != 3
				type="text"
			}}?
			id="{{guid3}}" placeholder="{{placeholder3}}" value="" />

		<button class="button" 
			onclick='vars.threeFieldsPopup.delete()'>
			No
		</button>
		<button class="button special" 
			onclick='vars.threeFieldsPopup.proceed("{{guid1}}", "{{guid2}}", "{{guid3}}")'>
			Yes
		</button>
	*/}, data)

	this.popup = new Widget.Popup({info: info})
	this.popup.proceed = data.proceed
	vars.threeFieldsPopup = this.popup
	this.popup.init()
}

Widget.ThreeFieldsPopup.prototype = {
	constructor: Widget.ThreeFieldsPopup
}


/* [OneFieldPopup] /data/Project/octopus_orig/bin/unix/../../sites/extensions/baseline/src/widgets/popup/OneFieldPopup.js */ 

Widget.OneFieldPopup = function (data) {
	data.guid = Widget.guid()

	var info = parse(function(){/*!
		{{?@ !isEmpty(data.info)
			<h1>{{info}}</h1>
		}}?

		<input class="spaced-down"
			{{? password == 1
				type="password"
			}}?
			{{? password != 1
				type="text"
			}}?
			id="{{guid}}" placeholder="{{placeholder}}" value="{{value}}" />

		<button class="button" 
			onclick='vars.oneFieldPopup.delete()'>
			No
		</button>
		<button class="button special" 
			onclick='vars.oneFieldPopup.proceed("{{guid}}")'>
			Yes
		</button>
	*/}, data)

	this.popup = new Widget.Popup({info: info})
	this.popup.proceed = data.proceed
	vars.oneFieldPopup = this.popup
	this.popup.init()
}

Widget.OneFieldPopup.prototype = {
	constructor: Widget.OneFieldPopup
}


/* [Popup] /data/Project/octopus_orig/bin/unix/../../sites/extensions/baseline/src/widgets/popup/Popup.js */ 

Widget.Popup = function (data) {
	this.data = data
	this.html = parse(function(){/*!
		<div>
			<div class="overlay"></div>
			<div class="popup">{{info}}</div>
		</div>
	*/}, data)
}

Widget.Popup.prototype = {
	constructor: Widget.Popup,

	init: function () {
		$("#popups").html(this.html)
	},

	delete: function () {
		$("#popups").empty()
	}
}


/* [SecurityRegisterForm] /data/Project/octopus_orig/bin/unix/../../sites/extensions/security/src/widgets/RegisterForm.js */ 

Widget.RegisterForm = function (data) {
	this.data = data
	this.html = parse(function(){/*!
		<h3>Register</h3>

		<form method="post" action="/security/registerUser">
			<div class="row uniform">
				<div class="6u$ 8u$(medium) 12u$(small)">
					<input type="email" name="email" id="email" value="" placeholder="Email" />
				</div>
				<div class="6u$ 8u$(medium) 12u$(small)">
					<input type="password" name="password" id="password" value="" placeholder="Password" />
				</div>
				<div class="6u$ 8u$(medium) 12u$(small)">
					<input type="password" name="repeatPassword" id="repeatPassword" value="" placeholder="Repeat Password" />
				</div>

				<div class="12u$">
					<ul class="actions">
						<li><input type="submit" value="Register" /></li>
					</ul>
				</div>
			</div>
		</form>
	*/}, data)
}

Widget.RegisterForm.prototype = {
	constructor: Widget.RegisterForm
}


/* [SecurityLoginForm] /data/Project/octopus_orig/bin/unix/../../sites/extensions/security/src/widgets/LoginForm.js */ 

Widget.LoginForm = function (data) {
	this.data = data
	this.html = parse(function(){/*!
		<h3>Login</h3>

		<form method="post" action="/security/loginUser{{to}}">
			<div class="row uniform">
				<div class="6u 8u(medium) 12u$(small)">
					<input type="email" name="email" id="email" value="" placeholder="Email" />
				</div>
				<div class="6u$ 8u$(medium) 12u$(small)">
					<input type="password" name="password" id="password" value="" placeholder="Password" />
				</div>

				<div class="12u$">
					<ul class="actions">
						<li><input type="submit" value="Login" /></li>
					</ul>
				</div>
			</div>
		</form>
	*/}, data)
}

Widget.LoginForm.prototype = {
	constructor: Widget.LoginForm
}


/* [UploadResult] /data/Project/octopus_orig/bin/unix/../../sites/extensions/editor/src/widgets/UploadResult.js */ 

Widget.UploadResult = function (files) {
	var data = {files: files}

	this.data = data
	this.html = parse(function(){/*!
		{{? files.length > 0
			<ul class="no-bullets">
				{{# files[i]
					<li class="file">
						<div id="{{files[i]}}" class="nowrap">
							<i class="fa fa-file-o"></i>
							{{files[i]}}
						</div>
					</li>
				}}#
			</ul>
		}}?
	*/}, data)
}

Widget.UploadResult.prototype = {
	constructor: Widget.UploadResult
}


/* [CompareEditor] /data/Project/octopus_orig/bin/unix/../../sites/extensions/editor/src/widgets/CompareEditor.js */ 

Widget.CompareEditor = function (data) {
	var editor = new Widget.Editor(data)
	
	editor.html = parse(function(){/*!
		<h1 style="margin-left: 1em;">{{name}}</h1>
		<div id="{{id}}"></div>
	*/}, data)
	
	return editor
}

Widget.CompareEditor.prototype = {
	constructor: Widget.CompareEditor
}


/* [EditorHeader] /data/Project/octopus_orig/bin/unix/../../sites/extensions/editor/src/widgets/EditorHeader.js */ 

Widget.EditorHeader = function (title) {
	var data = {title: title}

	this.data = data
	this.html = parse(function(){/*!
		<header id="header" class="skel-layers-fixed">
			<h1><div id="menu" class="hand">{{title}}</div></h1>
			<nav id="nav">
				<ul>
					<!-- Login -->
					<li><div id="login" class="hand" 
						onclick='Widget.EditorHeader.login();'>
						<i class="fa fa-user-secret"></i></div>
					</li>

					<!-- Database -->
					<li><a id="database" class="hand" style="color: white;"
						href="{{@ property.databaseUrl + property.databaseHomeUrl}}" target="_blank">
						<i class="fa fa-database"></i></a>
					</li>
					
					<!-- Comapre -->
					<li><a id="compare" class="hand" style="color: white;"
						href="{{@ property.editorUrl + property.compareUrl}}" target="_blank">
						<i class="fa fa-files-o"></i></a>
					</li>

					<!-- Search -->
					<li><div id="search" class="hand" 
						onclick='Widget.EditorHeader.search();'>
						<i class="fa fa-question"></i></div>
					</li>

					<!-- Home Directory -->
					<li><div id="setHomeDirectoryAction" class="hand" 
						onclick='Widget.EditorHeader.setHomeDirectory();'>
						<i class="fa fa-home"></i></div>
					</li>

					<!-- Open New Window -->
					<li><a id="openNewWindowAction" class="hand" style="color: white;"
						href="javascript:;" target="_blank"
						onclick='Widget.EditorHeader.openNewWindow();'>
						<i class="fa fa-share"></i></a>
					</li>

					<!-- Repository -->
					<li><div id="setRepositoryAction" class="hand" 
						onclick='Widget.EditorHeader.setRepository();'>
						<i class="fa fa-eye"></i> <i class="fa fa-user"></i></div>
					</li>
					<li><a id="repositoryFileHistoryAction" class="hand" style="color: white;" 
						href="javascript:;" target="_blank"
						onclick='return Widget.EditorHeader.repositoryFileHistory();'>
						<i class="fa fa-eye"></i> <i class="fa fa-file-o"></i></a>
					</li>
					<li><a id="repositoryStatusAction" class="hand" style="color: white;" 
						href="javascript:;" target="_blank"
						onclick='return Widget.EditorHeader.repositoryStatus();'>
						<i class="fa fa-eye"></i> <i class="fa fa-folder-open"></i></a>
					</li>
					<li><div id="repositoryLogHistoryAction" class="hand"
						onclick='Widget.EditorHeader.repositoryLogHistory();'>
						<i class="fa fa-eye"></i> <i class="fa fa-bars"></i></div>
					</li>
					<li><div id="repositoryCommitHistoryAction" class="hand"
						onclick='Widget.EditorHeader.repositoryCommitHistory();'>
						<i class="fa fa-eye"></i> <i class="fa fa-random"></i></div>
					</li>

					<!-- Upload -->
					<li><div id="openUploaderAction" class="hand"
						onclick='Widget.EditorHeader.openUploader();'>
						<i class="fa fa-university"></i></div>
					</li>
					<li><div id="uploadFileAction" class="hand" 
						onclick='Widget.EditorHeader.uploadFile();'>
						<i class="fa fa-cloud-upload"></i></div>
						<form action="" method="post" id="uploadFileForm" target="_blank"
							enctype="multipart/form-data" style="display: none;">
							<input type="file" name="file" id="uploadFileInput" multiple=""/>
						<form/>
					</li>
					
					<!-- Create -->
					<li><div id="createFileAction" class="hand" 
						onclick='Widget.EditorHeader.createFileName();'>
						<i class="fa fa-plus"></i> <i class="fa fa-file-o"></i></div>
					</li>
					<li><div id="createDirectoryAction" class="hand" 
						onclick='Widget.EditorHeader.createDirectoryName();'>
						<i class="fa fa-plus"></i> <i class="fa fa-folder-open"></i></div>
					</li>

					<!-- Remove -->
					<li><div id="removeFileAction" class="hand" 
						onclick='Widget.EditorHeader.removeFileName();'>
						<i class="fa fa-minus"></i> <i class="fa fa-file-o"></i></div>
					</li>
					<li><div id="removeDirectoryAction" class="hand" 
						onclick='Widget.EditorHeader.removeDirectoryName();'>
						<i class="fa fa-minus"></i> <i class="fa fa-folder-open"></i></div>
					</li>

					<!-- Rename -->
					<li><div id="renameFileAction" class="hand" 
						onclick='Widget.EditorHeader.renameFileName();'>
						<i class="fa fa-wrench"></i> <i class="fa fa-file-o"></i></div>
					</li>
					<li><div id="renameDirectoryAction" class="hand" 
						onclick='Widget.EditorHeader.renameDirectoryName();'>
						<i class="fa fa-wrench"></i> <i class="fa fa-folder-open"></i></div>
					</li>

					<!-- Edit -->
					<li><div id="editFileAction" class="hand" 
						onclick='Widget.EditorHeader.editFile();'>
						<i class="fa fa-pencil-square-o"></i></div>
					</li>

					<!-- Save -->
					<li><div id="saveAction" class="button special" 
						onclick='Widget.EditorHeader.save();'>
						Save</div>
					</li>
				</ul>
			</nav>
		</header>
	*/}, data)
}

Widget.EditorHeader.prototype = {
	constructor: Widget.EditorHeader
}

Widget.EditorHeader.height = function () {
	return $('#header').height()
}


//
// login
//

Widget.EditorHeader.login = function () {
	var loginPopup = new Widget.TwoFieldsPopup({
		info:"Set login credentials.", 
		placeholder1: "Email", 
		placeholder2: "Password", 
		password: 2, 
		proceed: function (emailGuid, passwordGuid) {
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

Widget.EditorHeader.search = function () {
	var directoryName = editor.homeDirectory || editor.directoryName

	if (isEmpty(directoryName)) {
		var infoPopup = new Widget.InfoPopup({info: "directory is required!"})
		return false
	}

	var searchPopup = new Widget.EditorSearchPopup({
		info:"Search.", 
		proceed: function (proceedButtonGuid, queryGuid, replaceGuid, filterGuid, isRegexGuid, isFileNameGuid, isIgnoreCaseGuid) {
			var query = $("#" + queryGuid).val()
			var replace = $("#" + replaceGuid).val()
			var filter = $("#" + filterGuid).val()
			var isRegex = $("#" + isRegexGuid).is(':checked')
			var isFileName = $("#" + isFileNameGuid).is(':checked')
			var isIgnoreCase = $("#" + isIgnoreCaseGuid).is(':checked')

			if (!isEmpty(query)) {
				if (isEmpty(replace)) {
					$("#" + proceedButtonGuid).attr("href", Widget.EditorHeader.newSessionUrl(
						property.editorUrl + property.editorSearchUrl, 
						{directoryName: encodeURIComponent(directoryName), 
							query: encodeURIComponent(query), 
							filter: encodeURIComponent(filter), 
							isRegex: isRegex, 
							isFileName: isFileName, 
							isIgnoreCase: isIgnoreCase}))
				} else {
					$("#" + proceedButtonGuid).attr("href", Widget.EditorHeader.newSessionUrl(
						property.editorUrl + property.editorSearchUrl, 
						{directoryName: encodeURIComponent(directoryName), 
							query: encodeURIComponent(query), 
							replace: encodeURIComponent(replace), 
							filter: encodeURIComponent(filter), 
							isRegex: isRegex, 
							isFileName: isFileName, 
							isIgnoreCase: isIgnoreCase}))
				}
			} else {
				this.delete()

				var infoPopup = new Widget.InfoPopup({info: "query is required!"})
				return false
			}
	}})
}


//
// homeDirectory
//

Widget.EditorHeader.setHomeDirectory = function () {
	if (!isEmpty(editor.directoryName)) {

		var paths = editor.directoryName.split('/');
		var simpleDirectoryName = paths[paths.length - 1]

		var questionPopup = new Widget.QuestionPopup({
			question: "Set " + simpleDirectoryName + " as home directory?", 
			proceed: function () {
				var newSessionUrl = Widget.EditorHeader.newSessionUrl(
					property.editorUrl + property.editorDirectoryUrl, 
					{d: encodeURIComponent(editor.directoryName)}, true)

				$.get(newSessionUrl)
					.success(function (dirs) {
						var subdirs = new Widget.EditorNavigation(Widget.json(dirs), 
							{path: editor.directoryName, name: simpleDirectoryName})

						editorTemplate.setDirectoryNavigation(subdirs.html)
						editor.homeDirectory = editor.directoryName

						$("#title").html(simpleDirectoryName)
						$("#menu").html(simpleDirectoryName)
					})
					.error(Widget.errorHandler)

				this.delete()
		}})
	} else {
		var infoPopup = new Widget.InfoPopup({info: "Select directory!"})
	}
}


//
// newWindow
//

Widget.EditorHeader.openNewWindow = function () {
	var directoryName = editor.homeDirectory || editor.directoryName

	if (!isEmpty(directoryName)) {
		var newSessionUrl = Widget.EditorHeader.newSessionUrl(
			property.editorUrl + property.editorHomeUrl, 
			{directoryName: encodeURIComponent(directoryName)})

		$("#openNewWindowAction").attr("href", newSessionUrl)
	} else {
		var infoPopup = new Widget.InfoPopup({info: "directory is required!"})
		return false
	}
}


//
// repository
//

Widget.EditorHeader.setRepository = function () {
	var repositoryPopup = new Widget.ThreeFieldsPopup({
		info:"Set repository credentials.", 
		placeholder1: "Repository Name", 
		placeholder2: "User Name", 
		placeholder3: "Password", 
		password: 3,
		proceed: function (guid1, guid2, guid3) {
			var repository = $("#" + guid1).val()
			var username = $("#" + guid2).val()
			var password = $("#" + guid3).val()

			this.delete()

			if (!isEmpty(repository) && !isEmpty(username) && !isEmpty(password)) {
				vars.repository = {
					repository: repository,
					username: username,
					password: password
				}

				var infoPopup = new Widget.InfoPopup({info: "repository set!"})
			} else {
				var infoPopup = new Widget.InfoPopup({info: "repository, username and password are required!"})
			}
	}}) 
}

Widget.EditorHeader.getRepository = function () {
	var repository
	if (vars.repository) {
		repository = vars.repository
	} else {
		repository = {
			repository: getURLParameter("repository") || "",
			username: getURLParameter("username") || "",
			password: getURLParameter("password") || ""
		}
	}

	return repository
}

Widget.EditorHeader.isRepositorySet = function () {
	var repository = Widget.EditorHeader.getRepository()

	return (!isEmpty(repository.repository) && !isEmpty(repository.username) && !isEmpty(repository.password))
}

Widget.EditorHeader.newSessionUrl = function (controller, data, noHiddenData) {
	var url = controller + "?session=new"

	if (noHiddenData) {
		// do not include hidden data
	} else {
		// include repository
		var repository = Widget.EditorHeader.getRepository() 
		for (var key in repository) {
			url += "&" + key + "=" + repository[key]
		}
	}

	for (var key in data) {
		url += "&" + key + "=" + data[key]
	}

	return url
}

Widget.EditorHeader.repositoryFileHistory = function () {
	var directoryName = editor.homeDirectory || editor.directoryName

	if (isEmpty(directoryName)) {
		directoryName = getURLParameter("directoryName")
	}

	var fileName = editor.fileName

	if (Widget.EditorHeader.isRepositorySet() && !isEmpty(fileName)) {
		var newSessionUrl = Widget.EditorHeader.newSessionUrl(
			property.repositoryUrl + property.repositoryFileHistoryUrl, 
			{fileName: encodeURIComponent(fileName), 
				directoryName: encodeURIComponent(directoryName)})

		$("#repositoryFileHistoryAction").attr("href", newSessionUrl)
	} else {
		var infoPopup = new Widget.InfoPopup({info: "repository and file are required!"})
		return false
	}
}

Widget.EditorHeader.repositoryStatus = function () {
	var directoryName = editor.homeDirectory || editor.directoryName

	if (Widget.EditorHeader.isRepositorySet() && !isEmpty(directoryName)) {
		var newSessionUrl = Widget.EditorHeader.newSessionUrl(
			property.repositoryUrl + property.repositoryStatusUrl, 
			{directoryName: encodeURIComponent(directoryName)})

		$("#repositoryStatusAction").attr("href", newSessionUrl)
	} else {
		var infoPopup = new Widget.InfoPopup({info: "repository and directory are required!"})
		return false
	}
}

Widget.EditorHeader.repositoryLogHistory = function () {
	var directoryName = editor.homeDirectory || editor.directoryName

	if (Widget.EditorHeader.isRepositorySet() && !isEmpty(directoryName)) {
		var limitLogHistoryPopup = new Widget.OneFieldPopup({
			info:"Repository log history.", 
			placeholder: "Number of revisions", 
			proceed: function (guid) {
				var limit = $("#" + guid).val()

				this.delete()

				var newSessionUrl = Widget.EditorHeader.newSessionUrl(
					property.repositoryUrl + property.repositoryLogHistoryUrl, 
					{directoryName: encodeURIComponent(directoryName), limit: limit})

				window.open(newSessionUrl)
		}})
	} else {
		var infoPopup = new Widget.InfoPopup({info: "repository and directory are required!"})
		return false
	}
}

Widget.EditorHeader.repositoryCommitHistory = function () {
	if (getURLParameter("repository") == "SVN") {
		Widget.EditorHeader.repositoryCommitHistorySVN()
	} else if (getURLParameter("repository") == "GIT") {
		Widget.EditorHeader.repositoryCommitHistoryGIT()
	}
}

Widget.EditorHeader.repositoryCommitHistorySVN = function () {
	var directoryName = editor.homeDirectory || editor.directoryName

	if (Widget.EditorHeader.isRepositorySet() && !isEmpty(directoryName)) {
		var commitHistoryPopup = new Widget.TwoFieldsPopup({
			info:"Repository commit history.", 
			placeholder1: "New revision", 
			placeholder2: "Old revision", 
			proceed: function (newRevisionGuid, oldRevisionGuid) {
				var newRevision = $("#" + newRevisionGuid).val()
				var oldRevision = $("#" + oldRevisionGuid).val()

				this.delete()

				if (!isEmpty(newRevision) && !isEmpty(oldRevision)) {
					var newSessionUrl = Widget.EditorHeader.newSessionUrl(
						property.repositoryUrl + property.repositoryCommitHistoryUrl, 
						{directoryName: encodeURIComponent(directoryName), 
							newRevision: newRevision, oldRevision: oldRevision})

					window.open(newSessionUrl)
				} else {
					var infoPopup = new Widget.InfoPopup({info: "new and old revisions is required!"})
				}
		}})
	} else {
		var infoPopup = new Widget.InfoPopup({info: "repository and directory are required!"})
		return false
	}
}

Widget.EditorHeader.repositoryCommitHistoryGIT = function () {
	var directoryName = editor.homeDirectory || editor.directoryName

	if (Widget.EditorHeader.isRepositorySet() && !isEmpty(directoryName)) {
		var commitHistoryPopup = new Widget.TwoFieldsPopup({
			info:"Repository commit history.", 
			placeholder1: "New commit", 
			placeholder2: "Old commit", 
			proceed: function (newRevisionGuid, oldRevisionGuid) {
				var newRevision = $("#" + newRevisionGuid).val()
				var oldRevision = $("#" + oldRevisionGuid).val()

				this.delete()

				if (!isEmpty(newRevision)) {
					var newSessionUrl = Widget.EditorHeader.newSessionUrl(
						property.repositoryUrl + property.repositoryCommitHistoryUrl, 
						{directoryName: encodeURIComponent(directoryName), 
							newRevision: newRevision, oldRevision: oldRevision})

					window.open(newSessionUrl)
				} else {
					var infoPopup = new Widget.InfoPopup({info: "commit number is required!"})
				}
		}})
	} else {
		var infoPopup = new Widget.InfoPopup({info: "repository and directory are required!"})
		return false
	}
}


//
// upload
//

Widget.EditorHeader.openUploader = function () {
	$('#uploadFileInput').trigger('click')
}

Widget.EditorHeader.uploadFile = function () {
	if (!isEmpty(editor.directoryName) && !isEmpty($("#uploadFileInput").val())) {
		var directoryName = editor.directoryName

		var paths = editor.directoryName.split('/');
		var simpleDirectoryName = paths[paths.length - 1]
		
		var questionPopup = new Widget.QuestionPopup({
			question: "Upload file(s) to " + simpleDirectoryName + "?", 
			proceed: function () {
				$("#uploadFileForm").attr("action", 
					property.editorUrl + property.editorUploadFileUrl + "?directoryName=" + encodeURIComponent(directoryName))
				$("#uploadFileForm").trigger("submit")
				
				this.delete()
		}})
	} else {
		var infoPopup = new Widget.InfoPopup({info: "Select parent directory and file(s) to upload!"})
	}
}


//
// create/add
//

Widget.EditorHeader.createFileName = function () {
	if (!isEmpty(editor.directoryName)) {
		var createFileNamePopup = new Widget.OneFieldPopup({
			info:"Create file.",
			placeholder: "File Name", 
			proceed: function (guid) {
				var name = $("#" + guid).val()
				if (!isEmpty(name)) {
					var paths = editor.directoryName.split('/');
					paths.push(name)
					$.get(Widget.EditorHeader.newSessionUrl(
						property.editorUrl + property.editorCreateFileUrl, 
						{fileName: encodeURIComponent(paths.join('/'))}))
						.success(function (data) {
							Widget.successHandler(data, name + " created!")
						})
						.error(Widget.errorHandler)
				}

				this.delete()
		}})
	} else {
		var infoPopup = new Widget.InfoPopup({info: "Select parent directory!"})
	}
}

Widget.EditorHeader.createDirectoryName = function () {
	if (!isEmpty(editor.directoryName)) {
		var createDirectoryNamePopup = new Widget.OneFieldPopup({
			info:"Create directory.", 
			placeholder: "Directory Name", 
			proceed: function (guid) {
				var name = $("#" + guid).val()
				if (!isEmpty(name)) {
					var paths = editor.directoryName.split('/');
					paths.push(name)
					$.get(Widget.EditorHeader.newSessionUrl(
						property.editorUrl + property.editorCreateDirectoryUrl, 
						{directoryName: encodeURIComponent(paths.join('/'))})) 
						.success(function (data) {
							Widget.successHandler(data, name + " created!")
						})
						.error(Widget.errorHandler)
				}

				this.delete()
		}})
	} else {
		var infoPopup = new Widget.InfoPopup({info: "Select parent directory!"})
	}
}


//
// remove/delete
//

Widget.EditorHeader.removeFileName = function () {
	if (!isEmpty(editor.fileName)) {
		var fileName = editor.fileName

		var paths = editor.fileName.split('/');
		var simpleFileName = paths[paths.length - 1]

		var questionPopup = new Widget.QuestionPopup({
			question: "Delete " + simpleFileName + "?", 
			proceed: function () {
				$.get(Widget.EditorHeader.newSessionUrl(
					property.editorUrl + property.editorRemoveUrl, 
					{path: encodeURIComponent(fileName), isFile: "true"}))
					.success(function (data) {
						Widget.successHandler(data, simpleFileName + " deleted!")

						$("#" + editor.fileGuid).hide()
						editor.fileName = null
						editor.fileGuid = null
					})
					.error(Widget.errorHandler)

				this.delete()
		}})
	} else {
		var infoPopup = new Widget.InfoPopup({info: "Select file to delete!"})
	}
}

Widget.EditorHeader.removeDirectoryName = function () {
	if (!isEmpty(editor.directoryName)) {
		var directoryName = editor.directoryName

		var paths = editor.directoryName.split('/');
		var simpleDirectoryName = paths[paths.length - 1]

		var questionPopup = new Widget.QuestionPopup({
			question: "Delete " + simpleDirectoryName + "?", 
			proceed: function () {
				$.get(Widget.EditorHeader.newSessionUrl(
					property.editorUrl + property.editorRemoveUrl, 
					{path: encodeURIComponent(directoryName), isFile: "false"}))
					.success(function (data) {
						Widget.successHandler(data, simpleDirectoryName + " deleted!")

						$("#" + editor.directoryGuid).parent().hide() // hide directory list element
						editor.directoryName = null
						editor.directoryGuid = null
					})
					.error(Widget.errorHandler)

				this.delete()
		}})
	} else {
		var infoPopup = new Widget.InfoPopup({info: "Select directory to delete!"})
	}
}


//
// rename/move
//

Widget.EditorHeader.renameFileName = function () {
	if (!isEmpty(editor.fileName)) {

		var paths = editor.fileName.split('/');
		var simpleFileName = paths[paths.length - 1]

		var renameFileNamePopup = new Widget.OneFieldPopup({
			info:"Rename.", 
			placeholder: "", value: simpleFileName, 
			proceed: function (guid) {
				var name = $("#" + guid).val()
				if (!isEmpty(name)) {

					paths[paths.length - 1] = name

					$.get(Widget.EditorHeader.newSessionUrl(property.editorUrl + property.editorRenameUrl, {
						oldName: encodeURIComponent(editor.fileName), 
						newName: encodeURIComponent(paths.join('/')), 
						directoryName: encodeURIComponent(editor.homeDirectory)
					}))
						.success(function (data) {
							Widget.successHandler(data, simpleFileName + " renamed to " + name)
						})
						.error(Widget.errorHandler)
				}

				this.delete()
		}})
	} else {
		var infoPopup = new Widget.InfoPopup({info: "Select file!"})
	}
}

Widget.EditorHeader.renameDirectoryName = function () {
	if (!isEmpty(editor.directoryName)) {

		var paths = editor.directoryName.split('/');
		var simpleDirectoryName = paths[paths.length - 1]

		var renameDirectoryNamePopup = new Widget.OneFieldPopup({
			info:"Rename.",
			placeholder: "", 
			value: simpleDirectoryName, 
			proceed: function (guid) {
				var name = $("#" + guid).val()
				if (!isEmpty(name)) {

					paths[paths.length - 1] = name

					$.get(Widget.EditorHeader.newSessionUrl(
						property.editorUrl + property.editorRenameUrl, 
						{oldName: encodeURIComponent(editor.directoryName), 
							newName: encodeURIComponent(paths.join('/')),
							directoryName: encodeURIComponent(editor.homeDirectory)}))
						.success(function (data) {
							Widget.successHandler(data, simpleDirectoryName + " renamed to " + name)
						})
						.error(Widget.errorHandler)
				}

				this.delete()
		}})
	} else {
		var infoPopup = new Widget.InfoPopup({info: "Select directory!"})
	}
}


//
// edit
//

Widget.EditorHeader.editFile = function () {
	var directoryName = editor.homeDirectory || editor.directoryName

	if (isEmpty(directoryName)) {
		var infoPopup = new Widget.InfoPopup({info: "Select directory!"})
	} else if (isEmpty(editor.fileName)) {
		var infoPopup = new Widget.InfoPopup({info: "Select file!"})
	} else {
		var newSessionUrl = Widget.EditorHeader.newSessionUrl(
			property.editorUrl + property.editorEditFileUrl, 
			{directoryName: encodeURIComponent(directoryName), 
				fileName: encodeURIComponent(editor.fileName)})

		window.open(newSessionUrl)
	}
}


//
// save
//

Widget.EditorHeader.save = function () {
	if (!isEmpty(editor.fileName)) {
		var fileName = editor.fileName

		$.post(property.editorUrl + property.editorSaveUrl + "?f=" + encodeURIComponent(fileName), editor.getValue())
			.success(function () {
				Widget.EditorHeader.saved(true)
			})
			.error(Widget.errorHandler)
	}
}

Widget.EditorHeader.saved = function (isSaved) {
	if (isSaved) {
		$("#saveAction").css("background-color", property.mainColor);
	} else {
		$("#saveAction").css("background-color", "red");
	}
}


/* [Editor] /data/Project/octopus_orig/bin/unix/../../sites/extensions/editor/src/widgets/Editor.js */ 

Widget.Editor = function (data) {
	this.data = data
	this.html = parse(function(){/*!
		<div id="{{id}}"></div>
	*/}, data)
}

Widget.Editor.prototype = {
	constructor: Widget.Editor,

	init: function () {
		var aceEditor = ace.edit(this.data.id)
		aceEditor.setTheme("ace/theme/chrome")
		aceEditor.getSession().setMode("ace/mode/text")

		aceEditor.setShowPrintMargin(false)
		aceEditor.getSession().setTabSize(4)
		aceEditor.getSession().setUseSoftTabs(false)
		//aceEditor.getSession().setUseWorker(false) // disable syntax checker and information

		this.setFontSize("14px")
		this.setHeight(Widget.EditorTemplate.maxHeight())

		aceEditor.on('change', function (e) {
			// e.data.action - insertLines|insertText|removeLines|removeText
			Widget.EditorHeader.saved(false)
		})

		this.aceEditor = aceEditor
	},

	setValue: function (content) {
		// delete previous and set new content
		this.aceEditor.removeLines()
		this.aceEditor.setValue(content, -1)

		// remove last new line (added by ace)
		this.aceEditor.navigateFileEnd()
		this.aceEditor.navigateLeft(1)
		this.aceEditor.removeToLineEnd()
		this.aceEditor.navigateFileStart()

		// mark saved
		Widget.EditorHeader.saved(true)
	},

	getValue: function () {
		return this.aceEditor.getValue()
	},

	setMode: function (e) {
		var mode

		if (e == "js") {
			mode = "ace/mode/javascript"
		} else if (e == "json") {
			mode = "ace/mode/json"
		} else if (e == "css") {
			mode = "ace/mode/css"
		} else if (e == "html") {
			mode = "ace/mode/html"
		} else if (e == "xhtml") {
			mode = "ace/mode/html"
		} else if (e == "xml") {
			mode = "ace/mode/xml"
		} else if (e == "jsp") {
			mode = "ace/mode/html"
		} else if (e == "tag") {
			mode = "ace/mode/html"
		} else if (e == "c") {
			mode = "ace/mode/c_cpp"
		} else if (e == "cpp") {
			mode = "ace/mode/c_cpp"
		} else if (e == "h") {
			mode = "ace/mode/c_cpp"
		} else if (e == "hpp") {
			mode = "ace/mode/c_cpp"
		} else if (e == "ino") {
			mode = "ace/mode/c_cpp"
		} else if (e == "cs") {
			mode = "ace/mode/csharp"
		} else if (e == "java") {
			mode = "ace/mode/java"
		} else if (e == "scala") {
			mode = "ace/mode/scala"
		} else if (e == "sbt") {
			mode = "ace/mode/scala"
		} else if (e == "groovy") {
			mode = "ace/mode/groovy"
		} else if (e == "hs") {
			mode = "ace/mode/haskel"
		} else if (e == "lhs") {
			mode = "ace/mode/haskel"
		} else if (e == "lua") {
			mode = "ace/mode/lua"
		} else if (!isEmpty(e) && e.split("/")[e.split("/").length-1].toLowerCase().indexOf("makefile") >= 0) {
			mode = "ace/mode/makefile"
		} else if (e == "md") {
			mode = "ace/mode/markdown"
		} else if (e == "markdown") {
			mode = "ace/mode/markdown"
		} else if (e == "m") {
			mode = "ace/mode/matlab"
		} else if (e == "pl") {
			mode = "ace/mode/perl"
		} else if (e == "php") {
			mode = "ace/mode/php"
		} else if (e == "ps1") {
			mode = "ace/mode/powershell"
		} else if (e == "pro") {
			mode = "ace/mode/prolog"
		} else if (e == "py") {
			mode = "ace/mode/python"
		} else if (e == "rb") {
			mode = "ace/mode/ruby"
		} else if (e == "rbw") {
			mode = "ace/mode/ruby"
		} else if (e == "scad") {
			mode = "ace/mode/scad"
		} else if (e == "sh") {
			mode = "ace/mode/sh"
		} else if (e == "sql") {
			mode = "ace/mode/sql"
		} else if (e == "tcl") {
			mode = "ace/mode/tcl"
		} else if (e == "yaml") {
			mode = "ace/mode/yaml"
		} else {
			mode = "ace/mode/text"
		}

		this.aceEditor.getSession().setMode(mode)
	}, 
	
	setFontSize: function (x) {
		document.getElementById(this.data.id).style.fontSize = x
	},
	
	setHeight: function (x) {
		document.getElementById(this.data.id).style.height = x
	}
}


/* [EditorSearchTemplate] /data/Project/octopus_orig/bin/unix/../../sites/extensions/editor/src/controllers/EditorSearchTemplate.js */ 

Widget.EditorSearchTemplate = function (data) {
	this.data = data
	this.html = parse(function(){/*!
		<div id="main" class="container">
			<!-- Header -->
			{{header}}

			<div class="row">
				<div class="3u 12u(medium)" id="editorSearchTemplateNavigation">
					<div id="directoryNavigation">
						{{searchResult}}
					</div>
				</div>
				<div class="9u 12u(medium)" id="editorSearchTemplateEditor">
					{{editor}}
				</div>
			</div>
		</div>
	*/}, data)
}

Widget.EditorSearchTemplate.prototype = {
	constructor: Widget.EditorSearchTemplate
}


/* [EditorNavigation] /data/Project/octopus_orig/bin/unix/../../sites/extensions/editor/src/widgets/EditorNavigation.js */ 

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
								{{dirs[i].name}}
							</div>
							<div id="{{dirs[i].childrenGuid}}"></div>
						</li>
					}}??

					{{?? dirs[i].mode == "file"
						<li class="{{dirs[i].mode}}">
							<div id="{{dirs[i].guid}}" class="nowrap" 
							onclick='Widget.EditorNavigation.openFile("{{dirs[i].path}}", "{{dirs[i].guid}}")'>
								<i class="fa fa-file-o"></i>
								{{dirs[i].name}}
							</div>
						</li>
					}}??

					{{?? dirs[i].mode == "unknown"
						<li class="{{dirs[i].mode}}">
							<div id="{{dirs[i].guid}}" class="nowrap">
								<i class="fa fa-exclamation-circle"></i>
								{{dirs[i].name}}
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
						{{parent.name}}
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

			var paths = fileName.split('/');
			var simpleFileName = paths[paths.length - 1]
			$("#menu").html(simpleFileName)
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
		$("#" + editor.fileGuid).css("color", property.mainColor)
	}

	editor.fileGuid = guid
	$("#" + editor.fileGuid).css("font-weight", "900")
	$("#" + editor.fileGuid).css("color", property.selectedColor)
}

Widget.EditorNavigation.selectDirectoryName = function (guid) {
	if (!isEmpty(editor.directoryGuid)) {
		$("#" + editor.directoryGuid).css("font-weight", "normal")
		$("#" + editor.directoryGuid).css("color", "black")
	}

	editor.directoryGuid = guid
	$("#" + editor.directoryGuid).css("font-weight", "900")
	$("#" + editor.directoryGuid).css("color", property.selectedColor)
}


/* [EditorSearchHeader] /data/Project/octopus_orig/bin/unix/../../sites/extensions/editor/src/widgets/EditorSearchHeader.js */ 

Widget.EditorSearchHeader = function (title) {
	var data = {title: title}

	this.data = data
	this.html = parse(function(){/*!
		<header id="header" class="skel-layers-fixed">
			<h1><div id="menu" class="hand">{{title}}</div></h1>
			<nav id="nav">
				<ul>
					<!-- View History -->
					<li><a id="repositoryFileHistoryAction" class="hand" style="color: white;" 
						href="javascript:;" target="_blank"
						onclick='return Widget.EditorHeader.repositoryFileHistory();'>
						<i class="fa fa-eye"></i> <i class="fa fa-file-o"></i></a>
					</li>
					
					<!-- Remove -->
					<li><div id="removeFileAction" class="hand" 
						onclick='Widget.EditorHeader.removeFileName();'>
						<i class="fa fa-minus"></i> <i class="fa fa-file-o"></i></div>
					</li>
					
					<!-- Edit -->
					<li><div id="editFileAction" class="hand" 
						onclick='Widget.EditorSearchHeader.editFile();'>
						<i class="fa fa-pencil-square-o"></i></div>
					</li>

					<!-- Save -->
					<li><div id="saveAction" class="button special" 
						onclick='Widget.EditorHeader.save();'>
						Save</div>
					</li>

					<!-- Toggle -->
					<li><div id="toggleAction" class="button special" 
						onclick='Widget.EditorSearchHeader.toggle();'>
						<i class="fa fa-expand"></i></div>
					</li>
				</ul>
			</nav>
		</header>
	*/}, data)
}

Widget.EditorSearchHeader.prototype = {
	constructor: Widget.EditorSearchHeader
}

Widget.EditorSearchHeader.toggleNavigation = "12u"
Widget.EditorSearchHeader.toggleEditor = "12u"
Widget.EditorSearchHeader.toggleName = '<i class="fa fa-compress"></i>'

Widget.EditorSearchHeader.toggle = function () {
	var navigationClass = $("#editorSearchTemplateNavigation").attr("class")
	$("#editorSearchTemplateNavigation").attr("class", Widget.EditorSearchHeader.toggleNavigation)
	Widget.EditorSearchHeader.toggleNavigation = navigationClass

	var editorClass = $("#editorSearchTemplateEditor").attr("class")
	$("#editorSearchTemplateEditor").attr("class", Widget.EditorSearchHeader.toggleEditor)
	Widget.EditorSearchHeader.toggleEditor = editorClass

	var toggleName = $("#toggleAction").html()
	$("#toggleAction").html(Widget.EditorSearchHeader.toggleName)
	Widget.EditorSearchHeader.toggleName = toggleName
}

Widget.EditorSearchHeader.editFile = function () {
	var directoryName = getURLParameter("directoryName")

	if (isEmpty(directoryName)) {
		var infoPopup = new Widget.InfoPopup({info: "directory is required!"})
	} else if (isEmpty(editor.fileName)) {
		var infoPopup = new Widget.InfoPopup({info: "Select file!"})
	} else {
		var newSessionUrl = Widget.EditorHeader.newSessionUrl(
			property.editorUrl + property.editorEditFileUrl, 
			{directoryName: encodeURIComponent(directoryName), 
				fileName: encodeURIComponent(editor.fileName)})

		window.open(newSessionUrl)
	}
}


/* [EditorSearchResult] /data/Project/octopus_orig/bin/unix/../../sites/extensions/editor/src/widgets/EditorSearchResult.js */ 

Widget.EditorSearchResult = function (filePaths) {
	var files = []

	if (filePaths != null) {
		for (var i = 0; i < filePaths.length; i++) {
			files[i] = {}
			files[i].guid = Widget.guid()
			files[i].path = filePaths[i]
		}
	}

	var data = {files: files}

	this.data = data
	this.html = parse(function(){/*!
		{{? files.length > 0
			<ul class="no-bullets">
				{{# files[i]
					<li class="file">
						<div id="{{files[i].guid}}" class="nowrap"
							onclick='Widget.EditorNavigation.openFile("{{files[i].path}}", "{{files[i].guid}}")'>
							<i class="fa fa-file-o"></i>
							{{files[i].path}}
						</div>
					</li>
				}}#
			</ul>
		}}?
	*/}, data)
}

Widget.EditorSearchResult.prototype = {
	constructor: Widget.EditorSearchResult
}


/* [EditorTemplate] /data/Project/octopus_orig/bin/unix/../../sites/extensions/editor/src/controllers/EditorTemplate.js */ 

Widget.EditorTemplate = function (data) {
	this.data = data
	this.html = parse(function(){/*!
		<div id="main" class="container">
			<!-- Header -->
			{{header}}

			<div class="row">
				<div class="3u 12u(medium)">
					<div id="directoryNavigation">
						{{navigation}}
					</div>
				</div>
				<div class="9u 12u(medium)">
					{{editor}}
				</div>
			</div>
		</div>
	*/}, data)
}

Widget.EditorTemplate.prototype = {
	constructor: Widget.EditorTemplate,

	setDirectoryNavigation: function (html) {
		$("#directoryNavigation").html(html)
	}
}

Widget.EditorTemplate.maxHeight = function () {
	return window.innerHeight - Widget.EditorHeader.height() - 80 + "px"
}


/* [CompareTabs] /data/Project/octopus_orig/bin/unix/../../sites/extensions/editor/src/widgets/CompareTabs.js */ 

Widget.CompareTabs = function () {
	var tabs = [
		{   
			guid: Widget.guid(),
			id: "oldfilecontent",
			name: "old",
			html: '<pre class="diffbox"></pre>'
		}, 
		{   
			guid: Widget.guid(),
			id: "newfilecontent",
			name: "new",
			html: '<pre class="diffbox"></pre>'
		}, 
		{   
			guid: Widget.guid(),
			id: "diffoutput",
			name: "diff",
			html: ''
		}, 
		{
			guid: Widget.guid(),
			id: "comparator",
			name: "match",
			html: '<pre class="diffbox"></pre>'
		}
	]
	var data = {tabs: tabs}

	this.data = data
	this.html = parse(function(){/*!
		<div id="diffComparatorTabs">
			{{# tabs[i]
				<button class="button special diffComparatorButton"
					id="{{tabs[i].guid}}"
					onclick='Widget.CompareTabs.show("{{tabs[i].id}}", "{{tabs[i].guid}}")'>
					{{tabs[i].name}}
				</button>
			}}#
		</div>

		<div>
			{{# tabs[i]
				<div class="diffComparator" style="display: none"
					id="{{tabs[i].id}}">
					{{tabs[i].html}}
				</div>
			}}#
		</div>
	*/}, data)
}

Widget.CompareTabs.prototype = {
	constructor: Widget.CompareTabs
}

Widget.CompareTabs.show = function (id, guid) {
	$(".diffComparator").hide()
	$(".diffComparatorButton").css("background-color", property.mainColor)

	$("#" + id).show()
	$("#" + guid).css("background-color", property.selectedColor)
}


/* [EditorSearchPopup] /data/Project/octopus_orig/bin/unix/../../sites/extensions/editor/src/widgets/EditorSearchPopup.js */ 

Widget.EditorSearchPopup = function (data) {
	data.proceedButtonGuid = Widget.guid()
	data.queryGuid = Widget.guid()
	data.replaceGuid = Widget.guid()
	data.filterGuid = Widget.guid()
	data.isRegexGuid = Widget.guid()
	data.isFileNameGuid = Widget.guid()
	data.isIgnoreCaseGuid = Widget.guid()

	var info = parse(function(){/*!
		{{?@ !isEmpty(data.info)
			<h1>{{info}}</h1>
		}}?

		<input class="spaced-down" type="text" id="{{queryGuid}}" placeholder="Query" />
		
		<input type="radio" id="{{isRegexGuid}}" name="queryOptions" >
		<label for="{{isRegexGuid}}">Regex</label>

		<input type="radio" id="{{isIgnoreCaseGuid}}" name="queryOptions" >
		<label for="{{isIgnoreCaseGuid}}">Ignore Case</label>
		
		<br/>

		<input type="checkbox" id="{{isFileNameGuid}}" name="{{isFileNameGuid}}" >
		<label for="{{isFileNameGuid}}">File Name</label>

		<input class="spaced-down" type="text" id="{{replaceGuid}}" placeholder="Replace" />

		<input class="spaced-down" type="text" id="{{filterGuid}}" placeholder="Filter" />

		<br/>

		<a class="button" 
			onclick='vars.editorSearchPopup.delete()'>
			Close
		</a>
		<a class="button special"
			id="{{proceedButtonGuid}}"
			href="javascript:;" target="_blank"
			onclick='return vars.editorSearchPopup.proceed("{{proceedButtonGuid}}", "{{queryGuid}}", "{{replaceGuid}}", "{{filterGuid}}", "{{isRegexGuid}}", "{{isFileNameGuid}}", "{{isIgnoreCaseGuid}}")'>
			Search / Replace
		</a>
	*/}, data)

	this.popup = new Widget.Popup({info: info})
	this.popup.proceed = data.proceed
	vars.editorSearchPopup = this.popup
	this.popup.init()
}

Widget.EditorSearchPopup.prototype = {
	constructor: Widget.EditorSearchPopup
}


/* [CompareHeader] /data/Project/octopus_orig/bin/unix/../../sites/extensions/editor/src/widgets/CompareHeader.js */ 

Widget.CompareHeader = function () {
	var data = {}

	this.data = data
	this.html = parse(function(){/*!
		<header id="header" class="skel-layers-fixed">
			<nav id="nav">
				<ul>
					<!-- Compare -->
					<li><div id="compareAction" class="button special" 
						onclick='Widget.CompareHeader.compare();'>
						Compare</div>
					</li>
				</ul>
			</nav>
		</header>
	*/}, data)
}

Widget.CompareHeader.prototype = {
	constructor: Widget.CompareHeader
}

Widget.CompareHeader.compare = function () {
	var originalContent = vars.originalEditor.getValue()
	var changedContent = vars.changedEditor.getValue()

	$("#oldfilecontent .diffbox").html(Widget.createHTML(originalContent))
	$("#newfilecontent .diffbox").html(Widget.createHTML(changedContent))

	diffUsingJS(0, originalContent, changedContent)

	$("#comparator").prettyTextDiff({
		cleanup: $("#cleanup").is(":checked"),
		originalContent: originalContent,
		changedContent: changedContent,
		diffContainer: ".diffbox"
	});
}


/* [RepositoryStatusHeader] /data/Project/octopus_orig/bin/unix/../../sites/extensions/repository/src/widgets/RepositoryStatusHeader.js */ 

Widget.RepositoryStatusHeader = function (directoryName) {
	var data = {directoryName: directoryName}

	this.data = data
	this.html = parse(function(){/*!
		<header id="header" class="skel-layers-fixed">
			<h1><div id="menu" class="hand">{{directoryName}}</div></h1>
			<nav id="nav">
				<ul>
					<!-- Commit -->
					<li><div id="commitAction" class="hand" 
						onclick='Widget.RepositoryStatusHeader.commit();'>
						<i class="fa fa-chevron-circle-up"></i></div>
					</li>

					<!-- Update -->
					{{?@ getURLParameter("repository") == "SVN"
					<li><div id="updateAction" class="hand" 
						onclick='Widget.RepositoryStatusHeader.update();'>
						<i class="fa fa-chevron-circle-down"></i></div>
					</li>
					}}?

					<!-- Revert/Reset -->
					<li><div id="revertAction" class="hand" 
						onclick='Widget.RepositoryStatusHeader.revert();'>
						<i class="fa fa-chevron-circle-left"></i></div>
					</li>

					<!-- Merge -->
					{{?@ getURLParameter("repository") == "SVN"
					<li><div id="mergeAction" class="hand" 
						onclick='Widget.RepositoryStatusHeader.merge();'>
						<i class="fa fa-sitemap"></i></div>
					</li>
					}}?

					<!-- Refresh/Clean -->
					{{?@ getURLParameter("repository") == "SVN"
					<li><div id="refreshAction" class="hand" 
						onclick='Widget.RepositoryStatusHeader.refresh();'>
						<i class="fa fa-refresh"></i></div>
					</li>
					}}?
					{{?@ getURLParameter("repository") == "GIT"
					<li><div id="refreshAction" class="hand" 
						onclick='Widget.RepositoryStatusHeader.refresh();'>
						<i class="fa fa-eraser"></i></div>
					</li>
					}}?

					<!-- Create/Add -->
					<li><div id="addPathAction" class="hand" 
						onclick='Widget.RepositoryStatusHeader.addPath();'>
						<i class="fa fa-plus"></i></div>
					</li>

					<!-- Remove/Delete -->
					<li><div id="deletePathAction" class="hand" 
						onclick='Widget.RepositoryStatusHeader.deletePath();'>
						<i class="fa fa-minus"></i></div>
					</li>

					<!-- Edit -->
					<li><div id="editFileAction" class="hand" 
						onclick='Widget.RepositoryStatusHeader.editFile();'>
						<i class="fa fa-pencil-square-o"></i></div>
					</li>

					<!-- Compare -->
					<li><div id="compareAction" class="button special" 
						onclick='Widget.RepositoryStatusHeader.compare();'>
						Compare</div>
					</li>
				</ul>
			</nav>
		</header>
	*/}, data)
}

Widget.RepositoryStatusHeader.prototype = {
	constructor: Widget.RepositoryStatusHeader
}


//
// ifFileIsChecked
//

Widget.RepositoryStatusHeader.ifCheckboxIsChecked = function (f) {
	$(".compareRevision").each(function(index) {
		if ($(this).is(':checked')) {
			f($(this))
		}
	})
}


//
// commit
//

Widget.RepositoryStatusHeader.commit = function () {
	var params = {}
	params.directoryName = getURLParameter("directoryName")

	var i = 0
	Widget.RepositoryStatusHeader.ifCheckboxIsChecked(function (checkbox) {
		if (isEmpty(checkbox.attr("newFileName"))) {
			params["f" + i] = encodeURIComponent(checkbox.attr("fileName"))
		} else {
			params["f" + i] = encodeURIComponent(checkbox.attr("newFileName"))
		}

		i++
	})

	if (i < 1) {
		var infoPopup = new Widget.InfoPopup({info: "Select at least 1 file to commit!"})
		return
	}

	var commitPopup = new Widget.OneFieldPopup({info:"Commit code.", placeholder: "Message", proceed: function (guid) {
		var message = $("#" + guid).val()
		if (!isEmpty(message)) {
			params.message = encodeURIComponent(message)

			$.get(Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryCommitUrl, params))
				.success(function (data) {
					Widget.successHandler(data)
				})
				.error(Widget.errorHandler)

			this.delete()
		} else {
			var infoPopup = new Widget.InfoPopup({info: "Message required!"})
		}
	}})
}


//
// update
//

Widget.RepositoryStatusHeader.update = function () {
	var paths = []
	Widget.RepositoryStatusHeader.ifCheckboxIsChecked(function (checkbox) {
		paths.push(checkbox.attr("fileName"))
	})

	var directoryName = getURLParameter("directoryName")
	if (paths.length > 1) {
		var infoPopup = new Widget.InfoPopup({info: "Select 1 file/directory to update!"})
		return
	} else if (paths.length == 1) {
		directoryName = paths[0]
	}

	if (!isEmpty(directoryName)) {
		var updatePopup = new Widget.OneFieldPopup({info:"Update to revision.", placeholder: "Revision", proceed: function (guid) {
			var params = {}
			params.path = encodeURIComponent(directoryName)

			var revision = $("#" + guid).val()
			if (!isEmpty(revision)) {
				params.revision = revision
			}

			$.get(Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryUpdateUrl, params))
				.success(function (data) {
					Widget.successHandler(data)
				})
				.error(Widget.errorHandler)

			this.delete()
		}})
	} else {
		var infoPopup = new Widget.InfoPopup({info: "directory is required!"})
	}
}


//
// revert/reset
//

Widget.RepositoryStatusHeader.revert = function () {
	var directoryName = getURLParameter("directoryName")

	var paths = []
	Widget.RepositoryStatusHeader.ifCheckboxIsChecked(function (checkbox) {
		paths.push(checkbox.attr("fileName"))
	})

	if (paths.length > 1) {
		var infoPopup = new Widget.InfoPopup({info: "Select 1 file to revert!"})
	} else {
		var path
		var params = {}
		if (paths.length == 0) {
			path = getURLParameter("directoryName")
			params.path = encodeURIComponent(path)
			params.recursively = "true"
			params.directoryName = encodeURIComponent(directoryName)
		} else {
			path = paths[0]
			params.path = encodeURIComponent(path)
			params.directoryName = encodeURIComponent(directoryName)
		}

		var revertPopup = new Widget.QuestionPopup({question: "Revert " + path + "?", proceed: function () {
			$.get(Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryRevertUrl, params))
				.success(function (data) {
					Widget.successHandler(data)
				})
				.error(Widget.errorHandler)

			this.delete()
		}})
	}
}


//
// merge
//

Widget.RepositoryStatusHeader.merge = function () {
	var directoryName = getURLParameter("directoryName")

	if (!isEmpty(directoryName)) {
		var updatePopup = new Widget.TwoFieldsPopup({info:"Merge revisions.", placeholder1: "From Revision", placeholder2: "To Revision", proceed: function (fromRevisionGuid, toRevisionGuid) {
			var fromRevision = $("#" + fromRevisionGuid).val()
			var toRevision = $("#" + toRevisionGuid).val()

			if (!isEmpty(fromRevision) && !isEmpty(toRevision)) {
				var params = {}
				params.path = encodeURIComponent(directoryName)
				params.fromRevision = fromRevision
				params.toRevision = toRevision

				$.get(Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryMergeUrl, params))
					.success(function (data) {
						Widget.successHandler(data)
					})
					.error(Widget.errorHandler)

				this.delete()
			} else {
				this.delete()
				var infoPopup = new Widget.InfoPopup({info: "Both revisions are required!"})
			}
		}})
	} else {
		var infoPopup = new Widget.InfoPopup({info: "directory is required!"})
	}
}


//
// refresh/clean
//

Widget.RepositoryStatusHeader.refresh = function () {
	var directoryName = getURLParameter("directoryName")

	var path
	var isDir

	var paths = []
	Widget.RepositoryStatusHeader.ifCheckboxIsChecked(function (checkbox) {
		paths.push(checkbox.attr("fileName"))
	})

	if (paths.length > 1) {
		var infoPopup = new Widget.InfoPopup({info: "Select 1 file/directory to refresh!"})
		return
	} else if (paths.length == 1) {
		path = paths[0]
		isDir = false
	} else {
		path = directoryName
		isDir = true
	}

	if (!isEmpty(path)) {
		var refreshOrClean
		if (getURLParameter("repository") == "SVN") {
			refreshOrClean = "Refresh "
		} else if (getURLParameter("repository") == "GIT") {
			if (isDir) {
				refreshOrClean = "Remove untracked files in "
			} else {
				refreshOrClean = "Remove untracked "
			}
		}

		var refreshPopup = new Widget.QuestionPopup({question: refreshOrClean + path + "?", proceed: function () {
			var params = {}
			params.path = encodeURIComponent(path)
			params.directoryName = encodeURIComponent(directoryName)

			$.get(Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryRefreshUrl, params))
				.success(function (data) {
					Widget.successHandler(data)
				})
				.error(Widget.errorHandler)

			this.delete()
		}})
	} else {
		var infoPopup = new Widget.InfoPopup({info: "directory is refreshed!"})
	}
}


//
// create/add
//

Widget.RepositoryStatusHeader.addPath = function () {
	var directoryName = getURLParameter("directoryName")

	var paths = []
	Widget.RepositoryStatusHeader.ifCheckboxIsChecked(function (checkbox) {
		if (isEmpty(checkbox.attr("newFileName"))) {
			paths.push(checkbox.attr("fileName"))
		} else {
			paths.push(checkbox.attr("newFileName"))
		}
	})

	if (paths.length != 1) {
		var infoPopup = new Widget.InfoPopup({info: "Select 1 file to add!"})
	} else {
		var path = paths[0]

		var addPopup = new Widget.QuestionPopup({question: "Add " + path + "?", proceed: function () {
			$.get(Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryAddUrl, {path: encodeURIComponent(path), directoryName: encodeURIComponent(directoryName)}))
				.success(function (data) {
					Widget.successHandler(data)
				})
				.error(Widget.errorHandler)

			this.delete()
		}})
	}
}


//
// remove/delete
//

Widget.RepositoryStatusHeader.deletePath = function () {
	var directoryName = getURLParameter("directoryName")

	var paths = []
	Widget.RepositoryStatusHeader.ifCheckboxIsChecked(function (checkbox) {
		if (isEmpty(checkbox.attr("newFileName"))) {
			paths.push(checkbox.attr("fileName"))
		} else {
			paths.push(checkbox.attr("newFileName"))
		}
	})

	if (paths.length != 1) {
		var infoPopup = new Widget.InfoPopup({info: "Select 1 file to delete!"})
	} else {
		var path = paths[0]

		var deletePopup = new Widget.QuestionPopup({question: "Delete " + path + "?", proceed: function () {
			$.get(Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryDeleteUrl, {path: encodeURIComponent(path), directoryName: encodeURIComponent(directoryName)}))
				.success(function (data) {
					Widget.successHandler(data)
				})
				.error(Widget.errorHandler)

			this.delete()
		}})
	}
}

//
// edit
//

Widget.RepositoryStatusHeader.editFile = function () {
	var directoryName = getURLParameter("directoryName")

	var paths = []
	Widget.RepositoryStatusHeader.ifCheckboxIsChecked(function (checkbox) {
		if (isEmpty(checkbox.attr("newFileName"))) {
			paths.push(checkbox.attr("fileName"))
		} else {
			paths.push(checkbox.attr("newFileName"))
		}
	})

	if (paths.length != 1) {
		var infoPopup = new Widget.InfoPopup({info: "Select 1 file to edit!"})
	} else {
		var path = paths[0]

		var fileName
		if (getURLParameter("repository") == "SVN") {
			fileName = path
		} else if (getURLParameter("repository") == "GIT") {
			fileName = directoryName + "/" + path
		}

		var newSessionUrl = Widget.EditorHeader.newSessionUrl(
			property.editorUrl + property.editorEditFileUrl, 
			{directoryName: encodeURIComponent(directoryName), fileName: encodeURIComponent(fileName)})

		window.open(newSessionUrl)
	}
}


//
// compare
//

Widget.RepositoryStatusHeader.compare = function () {
	if (getURLParameter("repository") == "SVN") {
		Widget.RepositoryStatusHeader.compareSVN()
	} else if (getURLParameter("repository") == "GIT") {
		Widget.RepositoryStatusHeader.compareGIT()
	}
}

Widget.RepositoryStatusHeader.compareSVN = function () {
	var oldRevision, newRevision, fileName, revertRevisions
	var revisions = []

	Widget.RepositoryStatusHeader.ifCheckboxIsChecked(function (checkbox) {
		revisions.push(checkbox.attr("newRevision"))
		revisions.push(checkbox.attr("oldRevision"))
		fileName = checkbox.attr("fileName")
		revertRevisions = checkbox.attr("revertRevisions")
	})

	if (revisions.length == 2) {
		oldRevision = revisions[1]
		newRevision = revisions[0]

		Widget.compareSVNRepositoryFileHistory(oldRevision, newRevision, fileName, revertRevisions)
	} else {
		var infoPopup = new Widget.InfoPopup({info: "Select 1 file to compare!"})
	}
}

Widget.RepositoryStatusHeader.compareGIT = function () {
	var oldRevision, newRevision, oldFileName, newFileName
	var revisions = []

	Widget.RepositoryStatusHeader.ifCheckboxIsChecked(function (checkbox) {
		revisions.push(checkbox.attr("newRevision"))
		revisions.push(checkbox.attr("oldRevision"))
		fileName = checkbox.attr("fileName")
		newFileName = checkbox.attr("newFileName")
	})

	if (revisions.length == 2) {
		oldRevision = revisions[1]
		newRevision = revisions[0]

		oldFileName = fileName
		if (isEmpty(newFileName)) {
			newFileName = fileName
		} 

		Widget.compareGITRepositoryFileHistory(oldRevision, oldFileName, newRevision, newFileName)
	} else {
		var infoPopup = new Widget.InfoPopup({info: "Select 1 file to compare!"})
	}
}


/* [RepositoryDiff] /data/Project/octopus_orig/bin/unix/../../sites/extensions/repository/src/widgets/RepositoryDiff.js */ 

Widget.RepositoryDiff = function (data) {
	var tabs = [
		{   
			guid: Widget.guid(),
			id: "oldfilecontent",
			name: "old",
			html: '<pre class="diffbox"></pre>'
		}, 
		{   
			guid: Widget.guid(),
			id: "newfilecontent",
			name: "new",
			html: '<pre class="diffbox"></pre>'
		}, 
		{   
			guid: Widget.guid(),
			id: "diffoutput",
			name: "diff",
			html: ''
		}, 
		{
			guid: Widget.guid(),
			id: "comparator",
			name: "match",
			html: '<pre class="diffbox"></pre>'
		},
		{
			guid: Widget.guid(),
			id: "patch",
			name: "patch",
			html: '<pre class="diffbox"></pre>'
		}
	]
	data.tabs = tabs

	this.data = data
	this.html = parse(function(){/*!
		<div id="diffComparatorTabs">
			{{# tabs[i]
				<button class="button special diffComparatorButton"
					id="{{tabs[i].guid}}"
					onclick='Widget.RepositoryDiff.show("{{tabs[i].id}}", "{{tabs[i].guid}}")'>
					{{tabs[i].name}}
				</button>
			}}#
		</div>

		<div>
			{{# tabs[i]
				<div class="diffComparator" style="display: none"
					id="{{tabs[i].id}}">
					{{tabs[i].html}}
				</div>
			}}#
		</div>
	*/}, data)
}

Widget.RepositoryDiff.prototype = {
	constructor: Widget.RepositoryDiff
}

Widget.RepositoryDiff.show = function (id, guid) {
	$(".diffComparator").hide()
	$(".diffComparatorButton").css("background-color", property.mainColor)

	$("#" + id).show()
	$("#" + guid).css("background-color", property.selectedColor)
}


/* [RepositoryTemplate] /data/Project/octopus_orig/bin/unix/../../sites/extensions/repository/src/controllers/RepositoryTemplate.js */ 

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


/* [RepositoryFileHistoryHeader] /data/Project/octopus_orig/bin/unix/../../sites/extensions/repository/src/widgets/RepositoryFileHistoryHeader.js */ 

Widget.RepositoryFileHistoryHeader = function (fileName) {
	var data = {fileName: fileName}

	this.data = data
	this.html = parse(function(){/*!
		<header id="header" class="skel-layers-fixed">
			<h1><div id="menu" class="hand">{{fileName}}</div></h1>
			<nav id="nav">
				<ul>
					<!-- Compare -->
					<li><div id="compareAction" class="button special" 
						onclick='Widget.RepositoryFileHistoryHeader.compare();'>
						Compare</div>
					</li>
				</ul>
			</nav>
		</header>
	*/}, data)
}

Widget.RepositoryFileHistoryHeader.prototype = {
	constructor: Widget.RepositoryFileHistoryHeader
}

Widget.RepositoryFileHistoryHeader.compare = function () {
	if (getURLParameter("repository") == "SVN") {
		Widget.RepositoryFileHistoryHeader.compareSVN()
	} else if (getURLParameter("repository") == "GIT") {
		Widget.RepositoryFileHistoryHeader.compareGIT()
	}
}

Widget.RepositoryFileHistoryHeader.compareSVN = function () {
	var oldRevision, newRevision, fileName
	var revisions = []

	$(".compareRevision").each(function(index) {
		if ($(this).is(':checked')) {
			revisions.push($(this).attr("revision"))
		}
	})

	if (revisions.length == 2) {
		oldRevision = revisions[1]
		newRevision = revisions[0]
		fileName = getURLParameter("fileName")

		Widget.compareSVNRepositoryFileHistory(oldRevision, newRevision, fileName)
	} else {
		var infoPopup = new Widget.InfoPopup({info: "Select 2 revisions to compare!"})
	}
}

Widget.RepositoryFileHistoryHeader.compareGIT = function () {
	var oldRevision, oldFileName, newRevision, newFileName
	var revisions = []

	$(".compareRevision").each(function(index) {
		if ($(this).is(':checked')) {
			revisions.push($(this).attr("id"))
		}
	})

	if (revisions.length == 2) {
		oldRevision = $("#" + revisions[1]).attr("revision")
		oldFileName = $("#" + revisions[1]).attr("toFile")
		newRevision = $("#" + revisions[0]).attr("revision")
		newFileName = $("#" + revisions[0]).attr("toFile")

		Widget.compareGITRepositoryFileHistory(oldRevision, oldFileName, newRevision, newFileName)
	} else {
		var infoPopup = new Widget.InfoPopup({info: "Select 2 revisions to compare!"})
	}
}

Widget.compareSVNRepositoryFileHistory = function (oldRevision, newRevision, fileName, revertRevisions) {
	fileName = encodeURIComponent(fileName)

	$("#compareAction").html('<i class="fa fa-spinner"></i>')

	var oldRevisionContenUrl, newRevisionContenUrl

	oldRevisionContenUrl = Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryFileRevisionContentUrl, {revision: oldRevision, fileName: fileName})
	if (newRevision == "LOCAL") {
		newRevisionContenUrl = property.editorUrl + property.editorFileContentUrl + "?f=" + fileName
	} else {
		newRevisionContenUrl = Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryFileRevisionContentUrl, {revision: newRevision, fileName: fileName})
	}

	var fileDiffUrl
	if (!isEmpty(revertRevisions) && revertRevisions == "true") {
		fileDiffUrl = Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryFileDiffUrl, {oldRevision: "BASE", newRevision: "HEAD", fileName: fileName})
	} else {
		fileDiffUrl = Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryFileDiffUrl, {oldRevision: oldRevision, newRevision: newRevision, fileName: fileName})
	}

	var originalContent, changedContent
	$.get(oldRevisionContenUrl) // oldRevision
		.success(function (content) {
			originalContent = content

			$.get(newRevisionContenUrl) // newRevision
				.success(function (content) {
					changedContent = content

					if (!isEmpty(revertRevisions) && revertRevisions == "true") {
						var swap = originalContent
						originalContent = changedContent
						changedContent = swap
					}
					
					$("#oldfilecontent .diffbox").html(Widget.createHTML(originalContent))
					$("#newfilecontent .diffbox").html(Widget.createHTML(changedContent))

					diffUsingJS(0, originalContent, changedContent)

					$("#comparator").prettyTextDiff({
						cleanup: $("#cleanup").is(":checked"),
						originalContent: originalContent,
						changedContent: changedContent,
						diffContainer: ".diffbox"
					});

					$.get(fileDiffUrl)
						.success(function (content) {
							$("#patch .diffbox").html(Widget.decoratePatch(Widget.createHTML(content)))

							$("#compareAction").html('Compare')
						})
						.error(function(jqXHR, textStatus, errorThrown) {
							Widget.errorHandler(jqXHR, textStatus, errorThrown)
							$("#compareAction").html('Compare')
						})
				})
				.error(function(jqXHR, textStatus, errorThrown) {
					Widget.errorHandler(jqXHR, textStatus, errorThrown)
					$("#compareAction").html('Compare')
				})
		})
		.error(function(jqXHR, textStatus, errorThrown) {
			Widget.errorHandler(jqXHR, textStatus, errorThrown)
			$("#compareAction").html('Compare')
		})
}

Widget.compareGITRepositoryFileHistory = function (oldRevision, oldFileName, newRevision, newFileName) {
	var directoryName = getURLParameter("directoryName")
	directoryName = encodeURIComponent(directoryName)

	oldFileName = encodeURIComponent(oldFileName)
	newFileName = encodeURIComponent(newFileName)

	$("#compareAction").html('<i class="fa fa-spinner"></i>')

	var oldRevisionContenUrl, newRevisionContenUrl

	oldRevisionContenUrl = Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryFileRevisionContentUrl, {revision: oldRevision, fileName: oldFileName, directoryName: directoryName})
	if (newRevision == "LOCAL") {
		newRevisionContenUrl = property.editorUrl + property.editorFileContentUrl + "?f=" + directoryName + "/" + newFileName
	} else {
		newRevisionContenUrl = Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryFileRevisionContentUrl, {revision: newRevision, fileName: newFileName, directoryName: directoryName})
	}

	var fileDiffUrl = Widget.EditorHeader.newSessionUrl(property.repositoryUrl + property.repositoryFileDiffUrl, {oldRevision: oldRevision, newRevision: newRevision, fileName: oldFileName, newFileName: newFileName, directoryName: directoryName})

	var originalContent, changedContent
	$.get(oldRevisionContenUrl) // oldRevision
		.success(function (content) {
			originalContent = content

			$.get(newRevisionContenUrl) // newRevision
				.success(function (content) {
					changedContent = content
					
					$("#oldfilecontent .diffbox").html(Widget.createHTML(originalContent))
					$("#newfilecontent .diffbox").html(Widget.createHTML(changedContent))

					diffUsingJS(0, originalContent, changedContent)

					$("#comparator").prettyTextDiff({
						cleanup: $("#cleanup").is(":checked"),
						originalContent: originalContent,
						changedContent: changedContent,
						diffContainer: ".diffbox"
					});

					$.get(fileDiffUrl)
						.success(function (content) {
							$("#patch .diffbox").html(Widget.decoratePatch(Widget.createHTML(content)))

							$("#compareAction").html('Compare')
						})
						.error(function(jqXHR, textStatus, errorThrown) {
							Widget.errorHandler(jqXHR, textStatus, errorThrown)
							$("#compareAction").html('Compare')
						})
				})
				.error(function(jqXHR, textStatus, errorThrown) {
					Widget.errorHandler(jqXHR, textStatus, errorThrown)
					$("#compareAction").html('Compare')
				})
		})
		.error(function(jqXHR, textStatus, errorThrown) {
			Widget.errorHandler(jqXHR, textStatus, errorThrown)
			$("#compareAction").html('Compare')
		})
}

Widget.decoratePatch = function (text) {
	// baseline/static/js/jquery.pretty-text-diff.js
	// core/src/js/widget.js
	var delimiters = [
		{open: "\n+", close: "\n", bypass: "\n+++"}, 
		{open: "\n-", close: "\n", bypass: "\n---"},
		{open: "\r+", close: "\r", bypass: "\r+++"}, 
		{open: "\r-", close: "\r", bypass: "\r---"}
	]
	var wrappers = [
		{open: "<ins>", close: "</ins>"}, 
		{open: "<del>", close: "</del>"}, 
		{open: "<ins>", close: "</ins>"}, 
		{open: "<del>", close: "</del>"}
	]

	var substrings = []

	var iteratorIndex = 0

	do {
		var startDelimiterIndex, index, delimiter, wrapper

		// find the closest delimiter index
		var closestDelimiterIndex = text.length
		for (var i = 0; i < delimiters.length; i++) {
			startDelimiterIndex = text.indexOf(delimiters[i].open, iteratorIndex)
			if (startDelimiterIndex >= 0 && startDelimiterIndex < closestDelimiterIndex) {
				closestDelimiterIndex = startDelimiterIndex
				index = i
			}
		}

		// get closest index, delimiter and wrapper
		startDelimiterIndex = closestDelimiterIndex
		delimiter = delimiters[index]
		wrapper = wrappers[index]

		// bypass beggining headers
		if (startDelimiterIndex < text.length && startDelimiterIndex == text.indexOf(delimiter.bypass, iteratorIndex)) {

			substrings.push(text.substring(iteratorIndex, startDelimiterIndex + delimiter.bypass.length))

			iteratorIndex = startDelimiterIndex + delimiter.bypass.length
		} else if (startDelimiterIndex >= 0 && startDelimiterIndex < text.length) {
			substrings.push(text.substring(iteratorIndex, startDelimiterIndex))

			var startExpressionIndex = startDelimiterIndex + delimiter.open.length
			var endDelimiterIndex = text.indexOf(delimiter.close, startExpressionIndex)

			if (endDelimiterIndex < 0) {
				endDelimiterIndex = text.length
			}

			// from beginning of delimiter.open (inclusive) to beginning of delimiter.close (exclusive)
			var line = text.substring(startDelimiterIndex, endDelimiterIndex)

			substrings.push(wrapper.open + line + wrapper.close)

			// continue from beginning of delimiter.close
			iteratorIndex = endDelimiterIndex
		} else {
			substrings.push(text.substring(iteratorIndex, text.length))
		}
	} while (startDelimiterIndex >= 0 && startDelimiterIndex < text.length)

	// concat substrings
	return substrings.join("")
}


/* [RepositoryStatusNavigation] /data/Project/octopus_orig/bin/unix/../../sites/extensions/repository/src/widgets/RepositoryStatusNavigation.js */ 

Widget.RepositoryStatusNavigation = function (statuses) {
	statuses = statuses || []

	for (var i = 0; i < statuses.length; i++) {statuses[i].guid = Widget.guid()}

	var data = {statuses: statuses}

	this.data = data
	if (getURLParameter("repository") == "SVN") {
	this.html = parse(function(){/*!
		{{? statuses.length > 0
			<ul class="no-bullets">
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
			<ul class="no-bullets">
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


/* [RepositoryFileHistoryNavigation] /data/Project/octopus_orig/bin/unix/../../sites/extensions/repository/src/widgets/RepositoryFileHistoryNavigation.js */ 

Widget.RepositoryFileHistoryNavigation = function (revisions) {
	revisions = revisions || []

	for (var i = 0; i < revisions.length; i++) {revisions[i].guid = Widget.guid()}

	var data = {revisions: revisions}

	this.data = data

	if (getURLParameter("repository") == "SVN") {
	this.html = parse(function(){/*!
		{{? revisions.length > 0
			<ul class="no-bullets">
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
			<ul class="no-bullets">
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


/* [RepositoryPatch] /data/Project/octopus_orig/bin/unix/../../sites/extensions/repository/src/widgets/RepositoryPatch.js */ 

Widget.RepositoryPatch = function () {
	var data = {}

	this.data = data
	this.html = parse(function(){/*!
		<div id="patch"></div>
	*/}, data)
}

Widget.RepositoryPatch.prototype = {
	constructor: Widget.RepositoryPatch
}

Widget.RepositoryPatch.setContent = function (contents) {
	var html = ""

	for (var i = 0; i < contents.length; i++) {
		html = html 
			+ '<div class="diffComparator"><pre class="diffbox">' 
			+ Widget.decoratePatch(Widget.createHTML(contents[i])) 
			+ "</pre></div>"
	}

	$('#patch').html(html)
}


/* [RepositoryLog] /data/Project/octopus_orig/bin/unix/../../sites/extensions/repository/src/widgets/RepositoryLog.js */ 

Widget.RepositoryLog = function () {
	var data = {}

	this.data = data
	this.html = parse(function(){/*!
		<div>
			<div class="diffComparator">
				<pre id="repositoryLogContent" class="diffbox"></pre>
			</div>
		</div>
	*/}, data)
}

Widget.RepositoryLog.prototype = {
	constructor: Widget.RepositoryLog
}

Widget.RepositoryLog.setContent = function (content) {
	$('#repositoryLogContent').html(Widget.createHTML(content))
}


/* [DatabaseTemplate] /data/Project/octopus_orig/bin/unix/../../sites/extensions/database/src/controllers/DatabaseTemplate.js */ 

Widget.DatabaseTemplate = function (data) {
	this.data = data
	this.html = parse(function(){/*!
		<div id="main" class="container">
			<!-- Header -->
			{{header}}

			<div class="row">
				<div class="3u 12u(medium)">
					<div id="directoryNavigation">
						{{navigation}}
					</div>
				</div>
				<div class="9u 12u(medium)">
					{{tabs}}
				</div>
			</div>
		</div>
	*/}, data)
}

Widget.DatabaseTemplate.prototype = {
	constructor: Widget.DatabaseTemplate
}

Widget.DatabaseTemplate.maxHeight = function () {
	return window.innerHeight - Widget.DatabaseHeader.height() - 30 + "px"
}


/* [DatabaseHeader] /data/Project/octopus_orig/bin/unix/../../sites/extensions/database/src/widgets/DatabaseHeader.js */ 

Widget.DatabaseHeader = function (data) {
	this.data = data
	this.html = parse(function(){/*!
		<header id="header" class="skel-layers-fixed">
			<h1><div id="menu" class="hand">Database</div></h1>
			<nav id="nav">
				<ul>
					<!-- Login -->
					<li><div id="login" class="hand" 
						onclick='Widget.DatabaseHeader.login();'>
						<i class="fa fa-user-secret"></i></div>
					</li>

					<!-- Open New Window -->
					<li><a id="openNewWindowAction" class="hand" style="color: white;"
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
	$(".databaseTabButton").css("background-color", property.mainColor)

	$("#" + tabGuid).show()
	$("#" + tabButtonGuid).css("background-color", property.selectedColor)
}


/* [DatabaseNavigation] /data/Project/octopus_orig/bin/unix/../../sites/extensions/database/src/widgets/DatabaseNavigation.js */ 

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
					<li class="file">
						<div id="{{types[i].guid}}" class="nowrap" 
						onclick='Widget.DatabaseNavigation.selectType("{{types[i].name}}", "{{types[i].guid}}")'>
							<i class="fa fa-database"></i>
							{{types[i].name}}
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
		$("#directoryNavigation").css("max-height", Widget.DatabaseTemplate.maxHeight())
	}
}

Widget.DatabaseNavigation.selectType = function (type, guid) {
	Widget.DatabaseNavigation.selectFileName(guid)
	Widget.DatabaseNavigation.type = type
}

Widget.DatabaseNavigation.selectFileName = function (guid) {
	if (!isEmpty(editor.fileGuid)) {
		$("#" + editor.fileGuid).css("font-weight", "normal")
		$("#" + editor.fileGuid).css("color", property.mainColor)
	}

	editor.fileGuid = guid
	$("#" + editor.fileGuid).css("font-weight", "900")
	$("#" + editor.fileGuid).css("color", property.selectedColor)
}


/* [DatabaseEditObject] /data/Project/octopus_orig/bin/unix/../../sites/extensions/database/src/widgets/DatabaseEditObject.js */ 

Widget.DatabaseEditObject = function (properties) {
	var type = properties.splice(properties.length - 1, 1)[0]

	var objectId // object id
	for (var i = 0; i < properties.length; i++) {
		var array = properties[i].value
		if (array instanceof Array) {
			var guid = []
			for (var j = 0; j < array.length; j++) {guid.push(Widget.guid())}
			properties[i].guid = guid
			properties[i].addId = Widget.guid()
		} else {
			properties[i].guid = Widget.guid()
			properties[i].addId = Widget.guid()
		}

		// get object id
		if (properties[i].name == "id") {objectId = properties[i].value}
	}

	var data = {type: type, properties: properties, objectId: objectId, booleanTrue: true, booleanFalse: false}

	this.data = data
	this.html = parse(function(){/*!
		<h3 
		id="databaseObjectSpec" 
		objectType="{{type}}" 
		objectId="{{objectId}}">
			{{type}}</h3>

		{{# properties[i]

		{{? properties[i].type.type != "id" && properties[i].type.type != "integer" && properties[i].type.type != "float" && properties[i].type.type != "boolean" && properties[i].type.type != "string"
		<div class="row uniform">
			<div class="2u 12u$(xsmall)">
				<label for="{{properties[i].name}}">{{properties[i].name}} [{{@Widget.extractStringUpTo(data.properties[i].type.type, ".")}}]</label>
			</div>

			<div class="6u">
				<input type="text"
					objectFrom="{{type}}.{{properties[i].name}}"
					objectTo="{{properties[i].type.type}}"
					objectParentId="{{objectId}}" 
					id="{{properties[i].addId}}" />
			</div>

			<div class="2u$">
				<div class="button special"
				onclick='Widget.DatabaseHeader.addReference("{{properties[i].addId}}");'>
				<i class="fa fa-plus"></i></div>

				<div class="button special"
				onclick='Widget.DatabaseHeader.deleteAllReferences("{{type}}.{{properties[i].name}}", "{{properties[i].type.type}}", "{{objectId}}");'>
				<i class="fa fa-bolt"></i></div>
			</div>
		</div>

		<div class="row uniform">
			<div class="-2u 12u(xsmall)">
				<div class="table-wrapper">
					<table class="alt">
						<tbody>
							{{??@ data.properties[i].value instanceof Array
							{{## properties[i].value[j]
							<tr class="hasManyReferences">
								<td>
									<input type="checkbox" 
										objectType="{{@Widget.extractStringUpTo(data.properties[i].type.type, ".")}}"
										objectId="{{properties[i].value[j].id}}"
										objectFrom="{{type}}.{{properties[i].name}}"
										objectTo="{{properties[i].type.type}}"
										objectParentId="{{objectId}}"
										id="{{properties[i].guid[j]}}" 
										name="{{properties[i].guid[j]}}" 
										class="databaseEdit">

									<label for="{{properties[i].guid[j]}}">{{@JSON.stringify(data.properties[i].value[j])}}</label>
								</td>
							</tr>
							}}##
							}}??

							{{??@ data.properties[i].value != null && !(data.properties[i].value instanceof Array)
							<tr class="hasOneReference">
								<td>
									<input type="checkbox" 
										objectType="{{@Widget.extractStringUpTo(data.properties[i].type.type, ".")}}"
										objectId="{{properties[i].value.id}}"
										objectFrom="{{type}}.{{properties[i].name}}"
										objectTo="{{properties[i].type.type}}"
										objectParentId="{{objectId}}"
										id="{{properties[i].guid}}" 
										name="{{properties[i].guid}}" 
										class="databaseEdit">

									<label for="{{properties[i].guid}}">{{@JSON.stringify(data.properties[i].value)}}</label>
								</td>
							</tr>
							}}??
						</tbody>
					</table>
				</div> <!-- end of table-wrapper -->
			</div>
		</div>
		}}?

		{{? properties[i].type.type == "integer" || properties[i].type.type == "float" || properties[i].type.type == "string"
		<div class="row uniform">
			<div class="2u 12u$(xsmall)">
				<label for="{{properties[i].name}}">{{properties[i].name}} [{{properties[i].type.type}}]</label>
			</div>

			<div class="10u$ 12u$(xsmall)">
				{{?? properties[i].type.type != "string"
				<input type="text" 
				name="{{properties[i].name}}" 
				id="{{properties[i].name}}" 
				value="{{properties[i].value}}" 
				class="databaseObjectProperty" />
				}}??

				{{?? properties[i].type.type == "string"
					{{??? properties[i].type.length <= 255
					<input type="text" 
					name="{{properties[i].name}}" 
					id="{{properties[i].name}}" 
					value="{{@ Widget.escapeHtml(data.properties[i].value)}}" 
					class="databaseObjectProperty" />
					}}???

					{{??? properties[i].type.length > 255
					<textarea rows="5"
					name="{{properties[i].name}}" 
					id="{{properties[i].name}}" 
					class="databaseObjectProperty">{{@ Widget.escapeHtml(data.properties[i].value)}}</textarea>
					}}???
				}}??
			</div>
		</div>
		}}?

		{{? properties[i].name == "id"
		<div class="row uniform">
			<div class="2u 12u$(xsmall)">
				<label for="{{properties[i].name}}">{{properties[i].name}}</label>
			</div>

			<div class="10u$ 12u$(xsmall)">
				{{properties[i].value}}
			</div>
		</div>
		}}?

		{{? properties[i].type.type == "boolean"
		<div class="row uniform">
			<div class="2u 12u$(xsmall)">
				<label for="{{properties[i].name}}">{{properties[i].name}}</label>
			</div>

			<div class="10u$ 12u$(xsmall)">
				<div class="4u 12u$(small)">
					<input type="radio"
					id="{{properties[i].name}}-true"
					name="{{properties[i].name}}"
					class="databaseObjectProperty"
					booleanValue="1"
					{{?? properties[i].value == booleanTrue
						checked
					}}??
					>
					<label for="{{properties[i].name}}-true">true</label>
				</div>
				<div class="4u 12u$(small)">
					<input type="radio"
					id="{{properties[i].name}}-false"
					name="{{properties[i].name}}"
					class="databaseObjectProperty"
					booleanValue="0"
					{{?? properties[i].value == booleanFalse
						checked
					}}??
					>
					<label for="{{properties[i].name}}-false">false</label>
				</div>
			</div>
		</div>
		}}?

		}}#
	*/}, data)
}

Widget.DatabaseEditObject.prototype = {
	constructor: Widget.DatabaseEditObject
}


/* [DatabaseEditor] /data/Project/octopus_orig/bin/unix/../../sites/extensions/database/src/widgets/DatabaseEditor.js */ 

Widget.DatabaseEditor = function (data) {
	this.data = data
	this.html = parse(function(){/*!
		<div id="{{id}}"></div>
	*/}, data)
}

Widget.DatabaseEditor.prototype = {
	constructor: Widget.DatabaseEditor,

	init: function () {
		var aceEditor = ace.edit(this.data.id)
		aceEditor.setTheme("ace/theme/chrome")
		aceEditor.getSession().setMode("ace/mode/lua")

		aceEditor.setShowPrintMargin(false)
		aceEditor.getSession().setTabSize(4)
		aceEditor.getSession().setUseSoftTabs(true)
		//aceEditor.getSession().setUseWorker(false) // disable syntax checker and information

		document.getElementById(this.data.id).style.fontSize = "14px"
		document.getElementById(this.data.id).style.height = Widget.DatabaseTemplate.maxHeight()

		this.aceEditor = aceEditor
	},

	setValue: function (content) {
		// delete previous and set new content
		this.aceEditor.removeLines()
		this.aceEditor.setValue(content, -1)
		this.aceEditor.navigateFileStart()
	},

	getValue: function () {
		return this.aceEditor.getValue()
	}
}


/* [DatabaseResult] /data/Project/octopus_orig/bin/unix/../../sites/extensions/database/src/widgets/DatabaseResult.js */ 

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


/* [DatabaseTabs] /data/Project/octopus_orig/bin/unix/../../sites/extensions/database/src/widgets/DatabaseTabs.js */ 

Widget.DatabaseTabs = function (data) {
	this.data = data
	this.html = parse(function(){/*!
		<div>
			{{# tabs[i]
				<div class="databaseTab" style="display: none"
					id="{{tabs[i].id}}">
					{{tabs[i].html}}
				</div>
			}}#
		</div>
	*/}, data)
}

Widget.DatabaseTabs.prototype = {
	constructor: Widget.DatabaseTabs
}


/* [Background] /data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/widgets/header/Background.js */ 

Widget.Background = function () {
	$("body").css('height', $(window).height())

	var setBackgroundImage = function (imageUrl) {
		$("body").css('background', '#FFFFF1 url(' + imageUrl + ') center 0px no-repeat')
	}


	var imageUrl1 = "http://s1emagst.akamaized.net/layout/bg/images/db/5/7385.jpg"
	var imageUrl2 = "http://s1emagst.akamaized.net/layout/bg/images/db/5/7391.jpg"

	skel.on('change', function() {
		if (skel.isActive('small')) {
			setBackgroundImage(imageUrl1)
		} else {
			setBackgroundImage(imageUrl2) 
		}
	});
}

Widget.Background.prototype = {
	constructor: Widget.Background
}


/* [AddressForm] /data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/widgets/account/AddressForm.js */ 

Widget.AddressForm = function (data) {
	this.data = data
	this.html = parse(function(){/*!
		<form method="post" action="{{actionUrl}}">
			<div class="row uniform">
				<input type="hidden" name="id" id="id" value="{{address.id}}" />

				<div class="6u$ 8u$(medium) 12u$(small)">
					<input type="text" name="firstName" id="firstName" value="{{address.firstName}}" placeholder="First Name" />
				</div>
				<div class="6u$ 8u$(medium) 12u$(small)">
					<input type="text" name="middleName" id="middleName" value="{{address.middleName}}" placeholder="Middle Name" />
				</div>
				<div class="6u$ 8u$(medium) 12u$(small)">
					<input type="text" name="lastName" id="lastName" value="{{address.lastName}}" placeholder="Last Name" />
				</div>
				<div class="6u$ 8u$(medium) 12u$(small)">
					<input type="text" name="telephone" id="telephone" value="{{address.telephone}}" placeholder="Telephone" />
				</div>
				<div class="6u$ 8u$(medium) 12u$(small)">
					<input type="email" name="email" id="email" value="{{address.email}}" placeholder="Email" />
				</div>
				<div class="6u$ 8u$(medium) 12u$(small)">
					<input type="text" name="line1" id="line1" value="{{address.line1}}" placeholder="Address Line 1" />
				</div>
				<div class="6u$ 8u$(medium) 12u$(small)">
					<input type="text" name="line2" id="line2" value="{{address.line2}}" placeholder="Address Line 2" />
				</div>
				<div class="6u$ 8u$(medium) 12u$(small)">
					<input type="text" name="city" id="city" value="{{address.city}}" placeholder="City" />
				</div>
				<div class="6u$ 8u$(medium) 12u$(small)">
					<input type="text" name="postCode" id="postCode" value="{{address.postCode}}" placeholder="Post Code" />
				</div>
				<div class="6u$ 8u$(medium) 12u$(small)">
					<input type="text" name="country" id="country" value="{{address.country}}" placeholder="Country" />
				</div>

				<div class="12u$">
					<ul class="actions">
						<li><input class="special" type="submit" value="{{actionName}}" /></li>
					</ul>
				</div>
			</div>
		</form>
	*/}, data)
}

Widget.AddressForm.prototype = {
	constructor: Widget.AddressForm
}


/* [ProductAttributeFilter] /data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/widgets/catalog/ProductAttributeFilter.js */ 

Widget.ProductAttributeFilter = function (productAttributes) {
	if (productAttributes && productAttributes instanceof Array) {
		for (var j = 0; j < productAttributes.length; j++) {
			for (var i = 0; i < productAttributes[j].values.length; i++) {productAttributes[j].values[i].guid = Widget.guid()}
		}
	}

	var data = {productAttributes: productAttributes}

	this.data = data
	this.html = parse(function(){/*!
		{{# productAttributes[j]
			{{? productAttributes[j].values.length > 0
				<h3>{{productAttributes[j].name[0].content}}</h3>
				<ul class="no-bullets">
					{{## productAttributes[j].values[i]
						<li>
							<input type="checkbox" 
								id="{{productAttributes[j].values[i].guid}}"
								name="{{productAttributes[j].values[i].guid}}"
								class="filterProductAttribute"
								productAttributeValueId="{{productAttributes[j].values[i].id}}">
							<label for="{{productAttributes[j].values[i].guid}}">{{productAttributes[j].values[i].name[0].content}}</label>
						</li>
					}}##
				</ul>
			}}?
		}}#
	*/}, data)
}

Widget.ProductAttributeFilter.prototype = {
	constructor: Widget.ProductAttributeFilter
}


/* [Cart] /data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/widgets/checkout/Cart.js */ 

Widget.Cart = function (cart) {
	if (cart && cart.productEntries) {
		for (var i = 0; i < cart.productEntries.length; i++) {
			var product = cart.productEntries[i].product

			product.url = property.shopUrl + property.productUrl + "/" + product.code
			product.quantityId = Widget.guid()
		}
	}

	var data = {cart: cart, pictureWidth: property.thumbnailPictureWidth, pictureHeight: property.thumbnailPictureHeight}

	this.data = data
	this.html = parse(function(){/*!
		<div class="table-wrapper">
			<table class="alt">
				<thead>
					<tr>
						<th>Picture</th>
						<th>Name</th>
						<th>Unit Price</th>
						<th>Quantity</th>
						<th>Total Price</th>
					</tr>
				</thead>
				<tbody>
					{{# cart.productEntries[i]
					<tr>
						<td>
							<a href="{{cart.productEntries[i].product.url}}">
								<img src="{{cart.productEntries[i].product.pictures[0].content}}" width="{{pictureWidth}}" height="{{pictureHeight}}" />
							</a>
						</td>
						<td>{{cart.productEntries[i].product.name[0].content}}</td>
						<td>
							<strong><span>{{cart.productEntries[i].unitPrice}}</span></strong>
						</td>
						<td>
							<input type="text" class="quantity"
								id="{{cart.productEntries[i].product.quantityId}}"
								value="{{cart.productEntries[i].quantity}}" />

							<div class="hand inline" onclick='Widget.Cart.update("{{cart.productEntries[i].product.quantityId}}", "{{cart.productEntries[i].id}}");'>
								&nbsp;<i class="fa fa-refresh"></i>
							</div>
							<div class="hand inline" onclick='Widget.Cart.update("{{cart.productEntries[i].product.quantityId}}", "{{cart.productEntries[i].id}}", 0);'>
								&nbsp;<i class="fa fa-times"></i>
							</div>
						</td>
						<td>
							<strong><span>{{cart.productEntries[i].totalPrice}}</span></strong>
						</td>
					</tr>
					}}#
				</tbody>
				<tfoot>
					<tr>
						<td colspan="4"></td>
						<td>
							Net Price: <strong><span>{{cart.totalNetPrice}}</span></strong>
						</td>
					</tr>
					<tr>
						<td colspan="4"></td>
						<td>
							VAT: <strong><span>{{cart.totalVAT}}</span></strong>
						</td>
					</tr>
					<tr>
						<td colspan="4"></td>
						<td>
							Gross Price: <strong><span>{{cart.totalGrossPrice}}</span></strong>
						</td>
					</tr>
				</tfoot>
			</table>
		</div>
	*/}, data)
}

Widget.Cart.prototype = {
	constructor: Widget.Cart
}

Widget.Cart.add = function (code, quantity) {
	if (!isEmpty(code) && !isEmpty(quantity) && quantity >= 0) {
		$.get(property.shopUrl + property.addToCartUrl, {productCode: code, quantity: quantity})
			.success(function (info) {
				var infoPopup = new Widget.InfoPopup({info: info})
			})
			.error(function(jqXHR, textStatus, errorThrown) {
				var infoPopup = new Widget.InfoPopup({info: jqXHR.responseText})
			})

		//Widget.MiniCart.updateNumberOfProducts()
	}
}

Widget.Cart.update = function (quantityId, productEntryId, quantity) {
	if (quantity != null) {
		quantity = parseInt(quantity)
		if (isNaN(quantity)) {
			var infoPopup = new Widget.InfoPopup({info: "enter valid quantity"})
			return
		}
	} else {
		quantity = parseInt($("#" + quantityId).val())
		if (isNaN(quantity)) {
			var infoPopup = new Widget.InfoPopup({info: "enter valid quantity"})
			return
		}
	}

	if (quantity >= 0) {
		$.get(property.shopUrl + property.updateProductEntryUrl, {productEntryId: productEntryId, quantity: quantity})
			.success(function (info) {
				location.reload()
			})
			.error(function(jqXHR, textStatus, errorThrown) {
				var infoPopup = new Widget.InfoPopup({info: jqXHR.responseText})
			})
	} else {
		var infoPopup = new Widget.InfoPopup({info: "enter valid quantity"})
	}
}


/* [PaymentMethodForm] /data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/widgets/checkout/PaymentMethodForm.js */ 

Widget.PaymentMethodForm = function (paymentMethods) {
	var data = {paymentMethods: paymentMethods, action: property.shopUrl + property.checkoutSetPaymentMethodUrl}

	this.data = data
	this.html = parse(function(){/*!
		<form method="get" action="{{action}}" onsubmit='return Widget.validateRadioButton("paymentMethod");'>
			<div class="row uniform">
				{{# paymentMethods[i]
					<div class="6u$ 8u$(medium) 12u$(small)">
						<input type="radio" id="paymentMethod-{{paymentMethods[i].id}}" name="paymentMethod" value="{{paymentMethods[i].id}}">
						<label for="paymentMethod-{{paymentMethods[i].id}}">{{paymentMethods[i].name[0].content}}</label>
					</div>
				}}#

				<div class="12u$">
					<ul class="actions">
						<li><input type="submit" value="{{@localize("continue")}}" /></li>
					</ul>
				</div>
			</div>
		</form>
	*/}, data)
}

Widget.PaymentMethodForm.prototype = {
	constructor: Widget.PaymentMethodForm
}


/* [DeliveryMethodForm] /data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/widgets/checkout/DeliveryMethodForm.js */ 

Widget.DeliveryMethodForm = function (deliveryMethods) {
	var data = {deliveryMethods: deliveryMethods, action: property.shopUrl + property.checkoutSetDeliveryMethodUrl}

	this.data = data
	this.html = parse(function(){/*!
		<form method="get" action="{{action}}" onsubmit='return Widget.validateRadioButton("deliveryMethod");'>
			<div class="row uniform">
				{{# deliveryMethods[i]
					<div class="6u$ 8u$(medium) 12u$(small)">
						<input type="radio" id="deliveryMethod-{{deliveryMethods[i].id}}" name="deliveryMethod" value="{{deliveryMethods[i].id}}">
						<label for="deliveryMethod-{{deliveryMethods[i].id}}">{{deliveryMethods[i].description[0].content}}&nbsp;{{deliveryMethods[i].price}}</label>
					</div>
				}}#

				<div class="12u$">
					<ul class="actions">
						<li><input type="submit" value="{{@localize("continue")}}" /></li>
					</ul>
				</div>
			</div>
		</form>
	*/}, data)
}

Widget.DeliveryMethodForm.prototype = {
	constructor: Widget.DeliveryMethodForm
}


/* [Search] /data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/widgets/header/Search.js */ 

Widget.Search = function () {
	var data = {}

	this.data = data
	this.html = parse(function(){/*!
		<div class="row eshop-search">
			<div class="8u">
				<input class="search-field" type="text" name="keyword" value="" placeholder="Find a product...">
			</div>
			<div class="4u add-on">
				<i class="fa fa-question"></i>
			</div>
		</div>
	*/}, data)
}

Widget.Search.prototype = {
	constructor: Widget.Search
}


/* [Order] /data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/widgets/account/Order.js */ 

Widget.Order = function (cart) {
	if (cart && cart.productEntries) {
		for (var i = 0; i < cart.productEntries.length; i++) {
			var product = cart.productEntries[i].product

			product.url = property.shopUrl + property.productUrl + "/" + product.code
		}
	}

	var data = {cart: cart, pictureWidth: property.thumbnailPictureWidth, pictureHeight: property.thumbnailPictureHeight}

	this.data = data
	this.html = parse(function(){/*!
		<div class="table-wrapper">
			<table class="alt">
				<thead>
					<tr>
						<th>Picture</th>
						<th>Name</th>
						<th>Unit Price</th>
						<th>Quantity</th>
						<th>Total Price</th>
					</tr>
				</thead>
				<tbody>
					{{# cart.productEntries[i]
					<tr>
						<td>
							<a href="{{cart.productEntries[i].product.url}}">
								<img src="{{cart.productEntries[i].product.pictures[0].content}}" width="{{pictureWidth}}" height="{{pictureHeight}}" />
							</a>
						</td>
						<td>{{cart.productEntries[i].product.name[0].content}}</td>
						<td>
							<strong><span>{{cart.productEntries[i].unitPrice}}</span></strong>
						</td>
						<td>
							<strong><span>{{cart.productEntries[i].quantity}}</span></strong>
						</td>
						<td>
							<strong><span>{{cart.productEntries[i].totalPrice}}</span></strong>
						</td>
					</tr>
					}}#
				</tbody>
				<tfoot>
					<tr>
						<td colspan="4"></td>
						<td>
							Net Price: <strong><span>{{cart.totalNetPrice}}</span></strong>
						</td>
					</tr>
					<tr>
						<td colspan="4"></td>
						<td>
							VAT: <strong><span>{{cart.totalVAT}}</span></strong>
						</td>
					</tr>
					<tr>
						<td colspan="4"></td>
						<td>
							Gross Price: <strong><span>{{cart.totalGrossPrice}}</span></strong>
						</td>
					</tr>
				</tfoot>
			</table>
		</div>
	*/}, data)
}

Widget.Order.prototype = {
	constructor: Widget.Order
}


/* [HorizontalNavigation] /data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/widgets/catalog/HorizontalNavigation.js */ 

Widget.HorizontalNavigation = function (categories) {
	if (categories) {
		for (var i = 0; i < categories.length; i++) {
			categories[i].url = property.shopUrl + property.categoryUrl + "/" + categories[i].code
		}
	}

	var data = {categories: categories}

	this.data = data
	this.html = parse(function(){/*!
		{{? categories.length > 0
			<ul class="menu2">
			{{# categories[i]
				<li class="menu2" ><a class="menu2" href="{{categories[i].url}}">{{categories[i].name[0].content}}</a></li>
			}}#
			</ul>
		}}?
	*/}, data)
}

Widget.HorizontalNavigation.prototype = {
	constructor: Widget.HorizontalNavigation
}


/* [AccountOptions] /data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/widgets/account/AccountOptions.js */ 

Widget.AccountOptions = function (data) {
	this.data = data
	this.html = parse(function(){/*!
		<ul class="alt">
			<li><h4><a style="color: #49bf9d;" href="{{@ property.shopUrl + property.accountOrdersUrl}}">Orders</a></h4></li>
			<li><h4><a style="color: #49bf9d;" href="{{@ property.shopUrl + property.accountAddressesUrl}}">Addresses</a></h4></li>
			<li></li>
		</ul>
	*/}, data)
}

Widget.AccountOptions.prototype = {
	constructor: Widget.AccountOptions
}


/* [ProductDetail] /data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/widgets/catalog/ProductDetail.js */ 

Widget.ProductDetail = function (product) {
	var data = {product: product, pictureWidth: property.pictureWidth, pictureHeight: property.pictureHeight}

	this.data = data
	this.html = parse(function(){/*!
		<div class="row">
			<div class="5u 12u(medium)">
				<a href="{{product.pictures[0].content}}">
					<img src="{{product.pictures[0].content}}" title="{{product.name[0].content}}" alt="{{product.name[0].content}}" width="{{pictureWidth}}" height="{{pictureHeight}}" />
				</a>
			</div>

			<div class="7u 12u(medium)">
				<h1>{{product.name[0].content}}</h1>

				<p>
					<img src="/shop/static/stars-5.png" />
					<a href="#reviews" style="cursor: pointer;">1 Reviews</a> | 
					<a href="#reviews" style="cursor: pointer;">Write a review</a>
				</p>

				<address>
					<strong>Product Code:</strong>
					<span>{{product.code}}</span>
				</address>

				<h2>
					<strong><span>{{product.prices[0]}}</span></strong>
				</h2>

				<div class="product-cart">
					<i class="fa fa-plus-square"></i>
					<i class="fa fa-minus-square"></i>

					<button id="add-to-cart" class="button special" type="button"
						onclick='Widget.Cart.add("{{product.code}}", 1);'>{{@localize("addToCart")}}</button>

					<i class="fa fa-heart"></i>
					<i class="fa fa-refresh"></i>
					<i class="fa fa-question"></i>
				</div>    
			</div>
		</div>
		<!-- //row -->

		<div class="row">
			<div class="12u">
				<h3><span class="title-block">Description</span></h3>
				<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit</p>
			</div>
		</div>
		<!-- //row -->

		<div class="row">
			<div class="12u">
				<h3><span class="title-block">Reviews (1)</span></h3>
				<div class="rating">
					<img src="/shop/static/stars-5.png" alt="" />
				</div>
				<div class="text">Aliquam a malesuada lorem. Nunc in porta.</div>
			</div>
		</div>
		<!-- //row -->
	*/}, data)
}

Widget.ProductDetail.prototype = {
	constructor: Widget.ProductDetail
}


/* [Orders] /data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/widgets/account/Orders.js */ 

Widget.Orders = function (data) {
	this.data = data
	this.html = parse(function(){/*!
		<form method="get" action="{{actionUrl}}" onsubmit='return Widget.validateRadioButton("order");'>
			<div class="row uniform">
				{{# orders[i]
					<div class="6u$ 8u$(medium) 12u$(small)">
						<input type="radio" id="order-{{orders[i].id}}" name="order" value="{{orders[i].id}}">
						<label for="order-{{orders[i].id}}">{{orders[i].creationTime}}</label>
					</div>
				}}#

				<div class="12u$">
					<ul class="actions">
						<li><input type="submit" value="{{actionName}}" /></li>
					</ul>
				</div>
			</div>
		</form>
	*/}, data)
}

Widget.Orders.prototype = {
	constructor: Widget.Orders
}


/* [MiniCart] /data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/widgets/header/MiniCart.js */ 

Widget.MiniCart = function () {
	var data = {}

	this.data = data
	this.html = parse(function(){/*!
		<div id="eshop-cart" class="eshop-cart">
			<div class="eshop-items">
				<a>
					<i class="fa fa-shopping-cart">&nbsp;</i>
					<span>Shopping Cart</span>
					<span id="eshop-cart-total" oldNumberOfProducts="0">0</span>
				</a>
			</div>
			<div class="eshop-content">
				<div class="eshop-content-empty">
					Your shopping cart is empty!
				</div>
			</div>
		</div>
	*/}, data)
}

Widget.MiniCart.prototype = {
	constructor: Widget.MiniCart
}

Widget.MiniCart.updateNumberOfProducts = function () {
	var numberOfProducts = $("#eshop-cart-total")
	var oldNumber = parseInt(numberOfProducts.attr("oldNumberOfProducts"))
	numberOfProducts.attr("oldNumberOfProducts", oldNumber + 1)
	numberOfProducts.html(oldNumber + 1)
}


/* [ProductsGrid] /data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/widgets/catalog/ProductsGrid.js */ 

Widget.ProductsGrid = function (products) {
	if (products) {
		for (var i = 0; i < products.length; i++) {
			products[i].url = property.shopUrl + property.productUrl + "/" + products[i].code
		}
	}

	var data = {products: products, pictureWidth: property.pictureWidth, pictureHeight: property.pictureHeight}

	this.data = data
	this.html = parse(function(){/*!
		{{? products.length > 0
			<div class="row">
			{{# products[i]
				<div class="4u 6u(medium) 12u(small)">
					<a href="{{products[i].url}}">
						<img src="{{products[i].pictures[0].content}}" width="{{pictureWidth}}" height="{{pictureHeight}}" />
					</a>
					<div class="row">
						<div class="6u -2u">
							{{products[i].name[0].content}}
						</div>
						<div class="4u">
							<strong>{{products[i].prices[0]}}</strong>
						</div>
					</div>
					<div class="row">
						<div class="-4u">
							<button id="add-to-cart" class="button special addToCart" type="button"
								onclick='Widget.Cart.add("{{products[i].code}}", 1);'>{{@localize("addToCart")}}</button>
						</div>
					</div>
				</div>
			}}#
			</div>
		}}?
	*/}, data)
}

Widget.ProductsGrid.prototype = {
	constructor: Widget.ProductsGrid
}


/* [Error] /data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/widgets/header/Error.js */ 

Widget.Error = function (errors) {
	var data = {errors: errors, guid: Widget.guid()}

	this.data = data
	this.html = parse(function(){/*!
		{{?@ data.errors instanceof Array
			<div id="{{guid}}">
			<div class="button" title="{{@localize("clickToClose")}}" onclick='Widget.Error.hide("{{guid}}");'>
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
	$("#" + guid).hide()
}


/* [RegisterForm] /data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/widgets/account/RegisterForm.js */ 

Widget.RegisterForm = function (data) {
	this.data = data
	this.html = parse(function(){/*!
		<h3>Register</h3>

		<form method="post" action="/security/registerUser{{to}}">
			<div class="row uniform">
				<div class="6u$ 8u$(medium) 12u$(small)">
					<input type="text" name="name" id="name" value="" placeholder="Name" />
				</div>
				<div class="6u$ 8u$(medium) 12u$(small)">
					<input type="email" name="email" id="email" value="" placeholder="Email" />
				</div>
				<div class="6u$ 8u$(medium) 12u$(small)">
					<input type="password" name="password" id="password" value="" placeholder="Password" />
				</div>
				<div class="6u$ 8u$(medium) 12u$(small)">
					<input type="password" name="repeatPassword" id="repeatPassword" value="" placeholder="Repeat Password" />
				</div>
				<div class="12u$">
					<ul class="actions">
						<li><input type="submit" value="Register" /></li>
					</ul>
				</div>
			</div>
		</form>
	*/}, data)
}

Widget.RegisterForm.prototype = {
	constructor: Widget.RegisterForm
}


/* [CallUs] /data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/widgets/header/CallUs.js */ 

Widget.CallUs = function () {
	var data = {}

	this.data = data
	this.html = parse(function(){/*!
		<div class="row eshop-call-us">
			<div class="3u eshop-phone">
				<i class="fa fa-phone"></i>
			</div>
			<div class="9u">
				<h2>0123-456-789</h2>
				<p>free call orders 24/24h</p>
			</div>
		</div>
	*/}, data)
}

Widget.CallUs.prototype = {
	constructor: Widget.CallUs
}


/* [ShopHeader] /data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/widgets/header/ShopHeader.js */ 

Widget.ShopHeader = function (data) {
	data = data || {}

	data.homeUrl = property.shopUrl + property.shopHomeUrl
	data.accountUrl = property.shopUrl + property.accountUrl
	data.cartUrl = property.shopUrl + property.cartUrl
	data.checkoutUrl = property.shopUrl + property.checkoutUrl

	this.data = data
	this.html = parse(function(){/*!
		<header id="header" class="skel-layers-fixed">
			<nav id="nav">
				<ul>
					<li><a class="button special hand" style="color: white;"
						href="{{homeUrl}}">{{@localize("homeMessage")}}</a>
					</li>
					<li><a class="button special hand" style="color: white;"
						href="{{accountUrl}}">{{@localize("accountMessage")}}</a>
					</li>
					<li><a class="button special hand" style="color: white;"
						href="{{cartUrl}}">{{@localize("cartMessage")}}</a>
					</li>
					<li><a class="button special hand" style="color: white;"
						href="{{checkoutUrl}}">{{@localize("checkoutMessage")}}</a>
					</li>

					<li><img class="hand" border="0" 
						src="/shop/static/bg_flag.gif" alt="bg flag"
						onclick='Widget.ShopHeader.setCountry("BG");'>
					</li>
					<li><img class="hand" border="0" 
						src="/shop/static/uk_flag.gif" alt="bg flag"
						onclick='Widget.ShopHeader.setCountry("GB");'>
					</li>
				</ul>
			</nav>
		</header>
	*/}, data)
}

Widget.ShopHeader.prototype = {
	constructor: Widget.ShopHeader
}

Widget.ShopHeader.setCountry = function (country) {
	$.get(property.shopUrl + property.changeCountryUrl, {country: country}, function(data) {
		location.reload()
	})
}


/* [Logo] /data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/widgets/header/Logo.js */ 

Widget.Logo = function () {
	var data = {logoUrl: property.shopUrl + property.shopHomeUrl}

	this.data = data
	this.html = parse(function(){/*!
		<div class="logo-image">
			<a href="{{@ property.shopUrl + property.shopHomeUrl}}" title="Web Shop Template">
				<img class="logo-img" src="/shop/static/logo.png" height="60px" />
			</a>
		</div>
	*/}, data)
}

Widget.Logo.prototype = {
	constructor: Widget.Logo
}


/* [Addresses] /data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/widgets/account/Addresses.js */ 

Widget.Addresses = function (data) {
	data.formId = Widget.guid()

	this.data = data
	this.html = parse(function(){/*!
		<form id="{{formId}}" method="get" onsubmit='return Widget.validateRadioButton("address");'>
			<div class="row uniform">
				{{# addresses[i]
					<div class="6u$ 8u$(medium) 12u$(small)">
						<input type="radio" id="address-{{addresses[i].id}}" name="address" value="{{addresses[i].id}}">
						<label for="address-{{addresses[i].id}}">{{addresses[i].firstName}} {{addresses[i].middleName}} {{addresses[i].lastName}}, {{addresses[i].telephone}}, {{addresses[i].email}}, {{addresses[i].line1}} {{addresses[i].line2}} {{addresses[i].city}} {{addresses[i].postCode}} {{addresses[i].country}}</label>
					</div>
				}}#

				<div class="12u$">
					<ul class="actions">
						{{?@ !isEmpty(data.editAddressUrl)
						<li><input type="submit" value="{{editAddressName}}" 
							onclick='Widget.Addresses.setActionUrl("{{formId}}", "{{editAddressUrl}}")' /></li>
						}}?
						{{?@ !isEmpty(data.removeAddressUrl)
						<li><input type="submit" value="{{removeAddressName}}" 
							onclick='Widget.Addresses.setActionUrl("{{formId}}", "{{removeAddressUrl}}")' /></li>
						}}?
						{{?@ !isEmpty(data.setAddressUrl)
						<li><input type="submit" value="{{setAddressName}}" 
							onclick='Widget.Addresses.setActionUrl("{{formId}}", "{{setAddressUrl}}")' /></li>
						}}?
						<li><a class="button" href='{{addAddressUrl}}'>{{addAddressName}}</a></li>
					</ul>
				</div>
			</div>
		</form>
	*/}, data)
}

Widget.Addresses.prototype = {
	constructor: Widget.Addresses
}

Widget.Addresses.setActionUrl = function (formId, actionUrl) {
	$("#" + formId).attr("action", actionUrl)
}


/* [DemoProductDetail] /data/Project/octopus_orig/bin/unix/../../sites/extensions/demo/src/widgets/DemoProductDetail.js */ 

Widget.DemoProductDetail = function (product) {
	var data = {product: product, pictureWidth: property.pictureWidth, pictureHeight: property.pictureHeight}

	this.data = data
	this.html = parse(function(){/*!

	{{?@ data.product != null

		<div class="row">
			<div class="5u 12u(medium)">
				<a href="{{product.picture}}">
					<img src="{{product.picture}}" title="{{product.name}}" alt="{{product.name}}" width="{{product.width}}" height="{{product.height}}" />
				</a>
			</div>

			<div class="7u 12u(medium)">
				<h1>{{product.name}}</h1>

				<p>
					<img src="/demo/static/stars-5.png" />
					<a href="#reviews" style="cursor: pointer;">1 Reviews</a> | 
					<a href="#reviews" style="cursor: pointer;">Write a review</a>
				</p>

				<address>
					<strong>Product Code:</strong>
					<span>{{product.code}}</span>
				</address>

				<h2>
					<strong><span>{{product.price}}</span></strong>
				</h2>

				<div class="product-cart">
					<i class="fa fa-plus-square"></i>
					<i class="fa fa-minus-square"></i>

					<button id="add-to-cart" class="button special" type="button"
						onclick='Widget.DemoProductDetail.addToCart("{{product.code}}", "{{product.price}}");'>{{@localize("addToCart")}}</button>

					<i class="fa fa-heart"></i>
					<i class="fa fa-refresh"></i>
					<i class="fa fa-question"></i>
				</div>    
			</div>
		</div>
		<!-- //row -->

		<div class="row">
			<div class="12u">
				<h3><span class="title-block">Description</span></h3>
				<p>Lorem ipsum dolor sit amet, consectetur adipisicing elit</p>
			</div>
		</div>
		<!-- //row -->

		<div class="row">
			<div class="12u">
				<h3><span class="title-block">Reviews (1)</span></h3>
				<div class="rating">
					<img src="/demo/static/stars-5.png" alt="" />
				</div>
				<div class="text">Aliquam a malesuada lorem. Nunc in porta.</div>
			</div>
		</div>
		<!-- //row -->

	}}?

	*/}, data)
}

Widget.DemoProductDetail.prototype = {
	constructor: Widget.DemoProductDetail
}

Widget.DemoProductDetail.addToCart = function (productCode, price) {
	var infoPopup = new Widget.InfoPopup({info: "Buy product '" + productCode + "' for " + price})
}


/* [DemoFooter] /data/Project/octopus_orig/bin/unix/../../sites/extensions/demo/src/widgets/DemoFooter.js */ 

Widget.DemoFooter = function (data) {
	data = data || {}

	this.data = data
	this.html = parse(function(){/*!
		<footer id="footer">
			<div class="copyright">
				<strong class="main">{{@ localize("copyright")}}</strong>
			</div>
		</footer>
	*/}, data)
}

Widget.DemoFooter.prototype = {
	constructor: Widget.DemoFooter
}


/* [DemoError] /data/Project/octopus_orig/bin/unix/../../sites/extensions/demo/src/widgets/DemoError.js */ 

Widget.DemoError = function (errors) {
	var data = {errors: errors}

	this.data = data
	this.html = parse(function(){/*!
		{{?@ data.errors instanceof Array
			<div id="errors">
			<div class="button" title="{{@localize("clickToClose")}}" onclick='Widget.DemoError.hide();'>
				<i class="fa fa-times"></i></div>
			{{# errors[i]
				<h2 class="hand" style="color: red;">{{errors[i]}}</h2>
			}}#
			</div>
		}}?
	*/}, data)
}

Widget.DemoError.prototype = {
	constructor: Widget.DemoError
}

Widget.DemoError.hide = function (guid) {
	$("#errors").hide()
}


/* [DemoHeader] /data/Project/octopus_orig/bin/unix/../../sites/extensions/demo/src/widgets/DemoHeader.js */ 

Widget.DemoHeader = function (data) {
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
						onclick='Widget.DemoHeader.showError()'>{{@localize("showError")}}</a>
					</li>
				</ul>
			</nav>
		</header>
	*/}, data)
}

Widget.DemoHeader.prototype = {
	constructor: Widget.DemoHeader
}

Widget.DemoHeader.showError = function () {
	if($("#errors").length == 0) {
		var infoPopup = new Widget.InfoPopup({info: localize("noErrors")})
	} else {
		$("#errors").show()
	}
}


