Widget.CryptographyTabs = function () {
	var tabs = [
		{   
			guid: Widget.guid(),
			id: "encrypt",
			name: "Encrypt",
			html: parse(function(){/*!
				<div class="row">
					<div class="6u 12u(medium)">
					<label class="spaced-up">Plain Text</label>
					<textarea id="{{id}}Plaintext" placeholder="plain text" rows="8" />
					<label class="spaced-up">Password</label>
					<input type="text" id="{{id}}Password" placeholder="password" />
					<select class="spaced-up" id="{{id}}Cipher">
						<option value="AES256" selected="selected">AES256</option>
						<option value="AES192">AES192</option>
						<option value="AES128">AES128</option>
					</select>
					<button class="button special spaced-up" 
						onclick='Widget.CryptographyTabs.encrypt()'>
						Encrypt
					</button>
					</div>
					
					<div class="6u 12u(medium)">
					<label class="spaced-up">Encrypted Text</label>
					<textarea id="{{id}}Encrypted" placeholder="encrypted text" rows="8" />
					<label class="spaced-up">IV</label>
					<input type="text" id="{{id}}Iv" placeholder="iv" />
					<label class="spaced-up">Salt</label>
					<input type="text" id="{{id}}Salt" placeholder="salt" />
					</div>
				</div>
			*/}, {id: "encrypt"})
		}, 
		{   
			guid: Widget.guid(),
			id: "decrypt",
			name: "Decrypt",
			html: parse(function(){/*!
				<div class="row">
					<div class="6u 12u(medium)">
					<label class="spaced-up">Encrypted Text</label>
					<textarea id="{{id}}Encrypted" placeholder="encrypted text" rows="8" />
					<label class="spaced-up">IV</label>
					<input type="text" id="{{id}}Iv" placeholder="iv" />
					<label class="spaced-up">Salt</label>
					<input type="text" id="{{id}}Salt" placeholder="salt" />
					<label class="spaced-up">Password</label>
					<input type="text" id="{{id}}Password" placeholder="password" />
					<select class="spaced-up" id="{{id}}Cipher">
						<option value="AES256" selected="selected">AES256</option>
						<option value="AES192">AES192</option>
						<option value="AES128">AES128</option>
					</select>
					<button class="button special spaced-up" 
						onclick='Widget.CryptographyTabs.decrypt()'>
						Decrypt
					</button>
					</div>
					
					<div class="6u 12u(medium)">
					<label class="spaced-up">Plain Text</label>
					<textarea id="{{id}}Plaintext" placeholder="plain text" rows="8" />
					</div>
				</div>
			*/}, {id: "decrypt"})
		}, 
		{   
			guid: Widget.guid(),
			id: "hashPassword",
			name: "Hash Password",
			html: parse(function(){/*!
				<div class="row">
					<div class="6u 12u(medium)">
					<label class="spaced-up">Password</label>
					<input type="text" id="{{id}}Password" placeholder="password" />
					<label class="spaced-up">[Salt]</label>
					<input  type="text" id="{{id}}_Salt" placeholder="[salt]" />
					<select class="spaced-up" id="{{id}}Length">
						<option value="32" selected="selected">32B</option>
						<option value="24">24B</option>
						<option value="16">16B</option>
					</select>
					<button class="button special spaced-up" 
						onclick='Widget.CryptographyTabs.hashPassword()'>
						Hash
					</button>
					</div>
					
					<div class="6u 12u(medium)">
					<label class="spaced-up">Hash:Base64</label>
					<input type="text" id="{{id}}Hash" placeholder="hash" />
					<label class="spaced-up">Salt</label>
					<input type="text" id="{{id}}Salt" placeholder="salt" />
					</div>
				</div>
			*/}, {id: "hashPassword"})
		}
	]
	var data = {tabs: tabs}

	this.data = data
	this.html = parse(function(){/*!
		<div class="cryptographyTabs">
			{{# tabs[i]
				<button class="button special cryptographyButton"
					id="{{tabs[i].guid}}"
					onclick='Widget.CryptographyTabs.show("{{tabs[i].id}}", "{{tabs[i].guid}}")'>
					{{tabs[i].name}}
				</button>
			}}#
		</div>

		<div class="cryptographyTabs">
			{{# tabs[i]
				<div class="cryptography" style="display: none"
					id="{{tabs[i].id}}">
					{{tabs[i].html}}
				</div>
			}}#
		</div>
	*/}, data)
}

Widget.CryptographyTabs.prototype = {
	constructor: Widget.CryptographyTabs
}

Widget.CryptographyTabs.show = function (id, guid) {
	$(".cryptography").hide()
	$(".cryptographyButton").css('text-decoration', 'none')

	$("#" + id).show()
	$("#" + guid).css('text-decoration', 'underline')
}

Widget.CryptographyTabs.encrypt = function () {
	var id = "encrypt"
	$.post(property.editorUrl + property.cryptographyUrl + "?operation=" + property.cryptographyEncrypt, 
		{
			plaintext: $("#" + id + "Plaintext").val(),
			password: $("#" + id + "Password").val(),
			cipher: $("#" + id + "Cipher").val(),
		})
		.success(function (data) {
			var json = Widget.json(data)
			$("#" + id + "Encrypted").val(json.encrypted)
			$("#" + id + "Iv").val(json.iv)
			$("#" + id + "Salt").val(json.salt)
		})
		.error(Widget.errorHandler)
}

Widget.CryptographyTabs.decrypt = function () {
	var id = "decrypt"
	$.post(property.editorUrl + property.cryptographyUrl + "?operation=" + property.cryptographyDecrypt, 
		{
			encrypted: $("#" + id + "Encrypted").val(),
			password: $("#" + id + "Password").val(),
			iv: $("#" + id + "Iv").val(),
			salt: $("#" + id + "Salt").val(),
			cipher: $("#" + id + "Cipher").val(),
		})
		.success(function (data) {
			var json = Widget.json(data)
			$("#" + id + "Plaintext").val(json.plaintext)
		})
		.error(Widget.errorHandler)
}

Widget.CryptographyTabs.hashPassword = function () {
	var id = "hashPassword"
	$.post(property.editorUrl + property.cryptographyUrl + "?operation=" + property.cryptographyHashPassword, 
		{
			password: $("#" + id + "Password").val(),
			salt: $("#" + id + "_Salt").val(),
			length: $("#" + id + "Length").val()
		})
		.success(function (data) {
			var json = Widget.json(data)
			$("#" + id + "Hash").val(json.hashcode)
			$("#" + id + "Salt").val(json.salt)
		})
		.error(Widget.errorHandler)
}