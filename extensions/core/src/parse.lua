local eval = require "eval"


local function transform (text, data, delimiter, nestedCycles, iterators, nestedConditions)
	local substrings = {} -- array with substrings

	local iteratorIndex = 0
	repeat
		local startDelimiterIndex = text:indexOf(delimiter.open, iteratorIndex)
		if startDelimiterIndex then
			if delimiter.preserve then
				substrings[#substrings + 1] = text:sub(iteratorIndex, startDelimiterIndex + delimiter.open:len() + 1)
			else
				substrings[#substrings + 1] = text:sub(iteratorIndex, startDelimiterIndex - 1)
			end

			if text:charAt(startDelimiterIndex + delimiter.open:len() + nestedCycles) == "#" then  -- cycle

			elseif text:charAt(startDelimiterIndex + delimiter.open:len() + nestedConditions) == "?" then  -- condition

			else  -- replace
				local startExpressionIndex = startDelimiterIndex + delimiter.open:len()
				local endDelimiterIndex = text:indexOf(delimiter.close, startExpressionIndex)

				local propertyName = text:sub(startExpressionIndex, endDelimiterIndex - 1)
				local transformedPropertyName = transform(propertyName:trim(), iterators, {open = "[", close = "]", preserve = true}, 0, {}, 0)
				substrings[#substrings + 1] = eval.code(transformedPropertyName, data, true)

				if delimiter.preserve then
					iteratorIndex = endDelimiterIndex
				else
					iteratorIndex = endDelimiterIndex + delimiter.close:len()
				end
			end
		else
			substrings[#substrings + 1] = text:sub(iteratorIndex, text:len())
		end	
	until startDelimiterIndex == nil

	return table.concat(substrings) -- concatenate all substrings
end


return function (text, data)
	return transform(text, data, {open = "{{", close = "}}", preserve = false}, 0, {}, 0)
end