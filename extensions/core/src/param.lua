local m = {} -- module


function string:trim()
	return (self:gsub("^%s*(.-)%s*$", "%1"))
end


function string:charAt(i)
	return self:sub(i, i)
end


function string:indexOf(s, i)
	return self:find(s, i, true)
end


function string:replace(x, y, isPlainString)
	local iteratorIndex = 1
	local substrings = {}

	repeat
		local from, to = self:find(x, iteratorIndex, isPlainString)

		if from then
			substrings[#substrings + 1] = self:sub(iteratorIndex, from - 1)
			substrings[#substrings + 1] = y
			iteratorIndex = to + 1
		else
			substrings[#substrings + 1] = self:sub(iteratorIndex, self:len())
		end
	until from == nil

	return table.concat(substrings) -- concatenate all substrings
end


function string:replaceQuery(x, y, isPlainString, isIgnoreCase)
	if isIgnoreCase then
		
		require "utf8"
		
		local lowerSelf, lowerX
		if string.isascii(x) then
			lowerSelf = string.lower(self)
			lowerX = string.lower(x)
		else
			lowerSelf = string.utf8lower(self)
			lowerX = string.utf8lower(x)
		end
		
		local iteratorIndex = 1
		local substrings = {}
	
		repeat
			local from, to = lowerSelf:find(lowerX, iteratorIndex, isPlainString)
	
			if from then
				substrings[#substrings + 1] = self:sub(iteratorIndex, from - 1)
				substrings[#substrings + 1] = y
				iteratorIndex = to + 1
			else
				substrings[#substrings + 1] = self:sub(iteratorIndex, self:len())
			end
		until from == nil
	
		return table.concat(substrings) -- concatenate all substrings
	else
		return self:replace(x, y, isPlainString)
	end
end


function string:findQuery(x, iteratorIndex, isPlainString, isIgnoreCase)
	if isIgnoreCase then
		
		require "utf8"
		
		local lowerSelf, lowerX
		if string.isascii(x) then
			lowerSelf = string.lower(self)
			lowerX = string.lower(x)
		else
			lowerSelf = string.utf8lower(self)
			lowerX = string.utf8lower(x)
		end
		
		local from, to = lowerSelf:find(lowerX, iteratorIndex, isPlainString)
		return from, to
	else
		local from, to = self:find(x, iteratorIndex, isPlainString)
		return from, to
	end
end


local hex_to_char = function (x)
	return string.char(tonumber(x, 16))
end


local unescape = function (url)
	return url:gsub("%%(%x%x)", hex_to_char)
end


local isNotEmpty = function (s)
	return s ~= nil and s ~= ''
end


local isEmpty = function (s)
	return s == nil or s == ''
end


local toboolean = function (s)
	if isNotEmpty(s) then
		if s == "true" then return true else return false end
	else
		return false
	end
end


local split = function (s, separator, isRegex)
	local isPlainText = not isRegex

	local index = 1
	local array = {}

	local firstIndex, lastIndex = s:find(separator, index, isPlainText)
	while firstIndex do
		array[#array + 1] = s:sub(index, firstIndex - 1)
		index = lastIndex + 1
		firstIndex, lastIndex = s:find(separator, index, isPlainText)
	end

	if index <= #s then
		array[#array + 1] = s:sub(index, #s)
	end

	return array
end


local function urlencode (str)
	if str then
		str = string.gsub(str, "\n", "\r\n")
		str = string.gsub(str, "([^%w ])",
			function (c) return string.format ("%%%02X", string.byte(c)) end)
		str = string.gsub(str, " ", "+")
	end
	return str    
end


local function urldecode (str)
	if str then
		str = string.gsub (str, "+", " ")
		str = string.gsub(str, '%%(%x%x)', 
			function (hex) return string.char(tonumber(hex, 16)) end)
	end
	return str
end


local function parseForm (form)
	if not form then return {} end

	local parameters = {}

	local listOfKeysAndValues = split(form, "&")
	for i=1, #listOfKeysAndValues do
		local keyAndValue = split(listOfKeysAndValues[i], "=")
		local key, value = keyAndValue[1], keyAndValue[2]
		if parameters[key] then
			if type(parameters[key]) == "string" then
				parameters[key] = {parameters[key]} -- copy old value
			end
			parameters[key][#parameters[key] + 1] = value
		else
			parameters[key] = value
		end
	end

	return parameters
end


local function requireSecureToken ()
	local https = ngx.var.https
	if https and https == "on" then
		return true
	else
		return false
	end
end


local function lengthOfObject (obj)
	local i = 0
	if obj then
		for k,v in pairs(obj) do
			i = i + 1
		end
	end
	return i
end


m.unescape = unescape
m.isNotEmpty = isNotEmpty
m.isEmpty = isEmpty
m.toboolean = toboolean
m.split = split
m.urlencode = urlencode
m.urldecode = urldecode
m.parseForm = parseForm
m.requireSecureToken = requireSecureToken
m.lengthOfObject = lengthOfObject

setmetatable(m, { 
	__index = function (table, key)
		local x = ngx.var["arg_" .. key]
		if x then
			return unescape(x)
		else
			return nil
		end
	end 
	}
)

return m -- return module