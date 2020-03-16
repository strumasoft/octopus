local json = require "json"
local parse = require "parse"
local param = require "param"
local property = require "property"
local util = require "util"
local exception = require "exception"
local crypto = require "crypto"



local function cipherLength(cipher)
	if cipher == "AES256" then
		return 32
	elseif cipher == "AES192" then
		return 24
	elseif cipher == "AES128" then
		return 16
	end
	
	exception("unknown cryptography cipher")
end


if util.isNotEmpty(param.operation) then
	local form = util.parseForm(util.urldecode(ngx.req.get_body_data()))
	
	if param.operation == property.cryptographyEncrypt then
		local hash, salt = crypto.passwordKey(form.password, nil, cipherLength(form.cipher))
		local encrypted, key, iv = crypto.encrypt(form.cipher, form.plaintext, hash)
		ngx.say(json.encode({encrypted = crypto.encodeBase64(encrypted), iv = crypto.encodeBase64(iv), salt = crypto.encodeBase64(salt)}))
		return
	elseif param.operation == property.cryptographyDecrypt then
		local hash, salt = crypto.passwordKey(form.password, crypto.decodeBase64(form.salt), cipherLength(form.cipher))
		local plaintext = crypto.decrypt(form.cipher, crypto.decodeBase64(form.encrypted), hash, crypto.decodeBase64(form.iv))
		ngx.say(json.encode({plaintext = plaintext}))
		return
	elseif param.operation == property.cryptographyHashPassword then
		if util.isNotEmpty(form.salt) then
			local hash, salt = crypto.passwordKey(form.password, crypto.decodeBase64(form.salt), tonumber(form.length))
			ngx.say(json.encode({hashcode = crypto.encodeBase64(hash), salt = crypto.encodeBase64(salt)}))
			return
		else
			local hash, salt = crypto.passwordKey(form.password, nil, tonumber(form.length))
			ngx.say(json.encode({hashcode = crypto.encodeBase64(hash), salt = crypto.encodeBase64(salt)}))
			return
		end
	else
		exception("unknown cryptography cipher")
	end
	
	exception("cryptography failed")
else
	ngx.say(parse(require("BaselineHtmlTemplate"), {
		title = "Cryptography",
		externalJS = [[
			<script src="/baseline/static/js/init-baseline.js" type="text/javascript"></script>
		]],
		externalCSS = [[
			<link href="/editor/static/editor-favicon.ico" rel="shortcut icon" type="image/vnd.microsoft.icon" />
		]],
		customCSS = [[
			.cryptographyTabs {
				margin: 3px;
			}
			#skel-layers-wrapper {
				padding-top: 0;
			}
		]],
		initJS = [[
			var vars = {}
	
			Widget.setContainerToPage([
				[
					{size: "12u", widget: new Widget.CryptographyTabs()}
				]
			])
		]]
	}))
end