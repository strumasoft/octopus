local json = require "json"
local parse = require "parse"
local param = require "param"
local property = require "property"
local util = require "util"
local exception = require "exception"
local crypto = require "crypto"


if util.isNotEmpty(param.operation) then
	local form = util.parseForm(util.urldecode(ngx.req.get_body_data()))
	
	if param.operation == property.cryptographyEncrypt then
		local encrypted, key, iv = crypto.encrypt(form.cipher, form.plaintext)
		local decrypted = crypto.decrypt(form.cipher, encrypted, key, iv)
		if decrypted == form.plaintext then
			ngx.say(json.encode({encrypted = encrypted, key = key, iv = iv}))
			return
		end
	elseif param.operation == property.cryptographyDecrypt then
		local decrypted = crypto.decrypt(form.cipher, form.encrypted, form.key, form.iv)
		local encrypted, key, iv = crypto.encrypt(form.cipher, decrypted, form.key, form.iv)
		-- encrypted blocks may ends with variable '='
		-- search whether at least one of the string is containing the other
		if encrypted:find(form.encrypted, 1, true) or form.encrypted:find(encrypted, 1, true) then
			ngx.say(json.encode({plaintext = decrypted}))
			return
		end
	elseif param.operation == property.cryptographyHashPassword then
		local hash, salt = crypto.passwordKey(form.password)
		local _hash, _salt = crypto.passwordKey(form.password, salt)
		if hash == _hash then
			ngx.say(json.encode({hashcode = hash, salt = salt}))
			return
		end
	elseif param.operation == property.cryptographyHashPasswordWithSalt then
		local hash, salt = crypto.passwordKey(form.password, form.salt)
		ngx.say(json.encode({hashcode = hash}))
		return
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