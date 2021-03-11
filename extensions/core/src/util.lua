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


local function hex_to_char (x)
	return string.char(tonumber(x, 16))
end


local function unescape (url)
	return url:gsub("%%(%x%x)", hex_to_char)
end


local function isNotEmpty (s)
	return s ~= nil and s ~= ''
end


local function isEmpty (s)
	return s == nil or s == ''
end


local function toboolean (s)
	if isNotEmpty(s) then
		if s == "true" then return true else return false end
	else
		return false
	end
end


local function split (s, separator, isRegex)
	local isPlainText = not isRegex

	local index = 1
	local array = {}

	local firstIndex, lastIndex = s:find(separator, index, isPlainText)
	while firstIndex do
		if firstIndex ~= 1 then
			array[#array + 1] = s:sub(index, firstIndex - 1)
		end
		index = lastIndex + 1
		firstIndex, lastIndex = s:find(separator, index, isPlainText)
	end

	if index <= #s then
		array[#array + 1] = s:sub(index, #s)
	end

	if #array == 1 then 
		return array, false
	else 
		return array, true
	end
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


local function isArray (array)
	if array and #array > 0 then return true end
	return false
end


local function escapePrintableChars (str)
	if str == nil then return "" end
	
	local newString = {}
	for i=1,#str do
		local number = string.byte(str, i)
		if number < 33 and number == 127 then 
			table.insert(newString, "&#32;")
		elseif number < 127 then
			table.insert(newString, "&#" .. number .. ";")
		else
			table.insert(newString, string.char(number))
		end
	end

	return table.concat(newString)
end


local function doGarbageCollection (counter, limit)
	if counter.count >= limit then
		counter.count = 0
		
		-- Because of resurrection, objects with finalizers are collected in two phases. 
		-- If we want to ensure that all garbage in your program has been actually released, we must call collectgarbage twice; 
		-- the second call will delete the objects that were finalized during the first call.
		collectgarbage()
		collectgarbage()
	else
		counter.count = counter.count + 1
	end
end


return {
	unescape = unescape,
	isNotEmpty = isNotEmpty,
	isEmpty = isEmpty,
	toboolean = toboolean,
	split = split,
	urlencode = urlencode,
	urldecode = urldecode,
	parseForm = parseForm,
	requireSecureToken = requireSecureToken,
	lengthOfObject = lengthOfObject,
	isArray = isArray,
	escapePrintableChars = escapePrintableChars,
	doGarbageCollection = doGarbageCollection,
}