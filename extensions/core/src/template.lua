local m = {} -- module table

function m.parse(text)
	local wrapper = {} -- wrapper holding the interface to the array with substrings
	local substrings = {} -- array with substrings
	
	local iteratorIndex = 0
	repeat
		local dollarIndex, openBracketIndex = text:find("${", iteratorIndex)
		if dollarIndex then
			local closeBracketIndex = text:find("}", openBracketIndex)
			if closeBracketIndex then
				substrings[#substrings + 1] = text:sub(iteratorIndex + 1, dollarIndex - 1)
				--print(substrings[#substrings])

				local variableName = text:sub(openBracketIndex + 1, closeBracketIndex - 1)
				--print(variableName)				
				local variableIndex = #substrings + 1

				substrings[variableIndex] = "" -- default/initial value of variable is empty string
				if wrapper[variableName] then
					local previousSetter = wrapper[variableName]
					wrapper[variableName] = function (x) -- setter for variable
						substrings[variableIndex] = x
						return previousSetter(x)
					end
				else
					wrapper[variableName] = function (x) -- setter for variable
						substrings[variableIndex] = x
						return wrapper
					end
				end

				iteratorIndex = closeBracketIndex
			end
		else
			substrings[#substrings + 1] = text:sub(iteratorIndex + 1, text:len() - 1)
			--print(substrings[#substrings])
			break
		end
	until text:len() < iteratorIndex

	wrapper.print = function () -- concatenate all substrigs and print them
		return table.concat(substrings)
	end

	return wrapper
end

return m