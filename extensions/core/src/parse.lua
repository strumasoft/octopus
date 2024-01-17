local eval = require "eval"
local util = require "util"


local function multiplyString (str, n)
  local s = ""
  for i=1,n do s = s .. str end
  return s
end

local function transform (text, data, delimiter, nestedCycles, nestedConditions)
  local substrings = {} -- array with substrings

  local iteratorIndex = 0
  repeat
    local startDelimiterIndex = text:indexOf(delimiter.open, iteratorIndex)
    if startDelimiterIndex then
      substrings[#substrings + 1] = text:sub(iteratorIndex, startDelimiterIndex - 1)
      
      if text:charAt(startDelimiterIndex + delimiter.open:len() + nestedCycles - 1) == "#" then  -- cycle
        local startExpressionIndex = startDelimiterIndex + delimiter.open:len() + nestedCycles + 1 -- one more because #

        -- find array name
        local arrayExpressionEndIndex = text:indexOf("\n", startExpressionIndex)
        local arrayExpression = text:sub(startExpressionIndex, arrayExpressionEndIndex - 1)
        local array = eval.code(arrayExpression, data, true)
        
        -- find element that will be repeated
        local endDelimiter = delimiter.close .. multiplyString("#", nestedCycles) .. "\n"
        local endDelimiterIndex = text:indexOf(endDelimiter, arrayExpressionEndIndex + 1)
        local element = text:sub(arrayExpressionEndIndex + 1, endDelimiterIndex - 1)
        
        -- iterate the array over the element
        if array then -- do not iterate over non-existing arrays
          local iterator = multiplyString("i", nestedCycles)
          if util.isArray(array) then
            for i=1,#array do
              data[iterator] = i
              substrings[#substrings + 1] = transform(element, data, delimiter, nestedCycles + 1, nestedConditions)
            end
          else -- array is object
            for i,_ in pairs(array) do
              data[iterator] = i
              substrings[#substrings + 1] = transform(element, data, delimiter, nestedCycles + 1, nestedConditions)
            end
          end
          data[iterator] = nil -- reset iterator
        end

        iteratorIndex = endDelimiterIndex + delimiter.close:len() + nestedCycles + 1 -- one more because #
      elseif text:charAt(startDelimiterIndex + delimiter.open:len() + nestedConditions - 1) == "?" then  -- condition
        local startExpressionIndex = startDelimiterIndex + delimiter.open:len() + nestedConditions + 1 -- one more because ?

        -- find condition name
        local conditionExpressionEndIndex = text:indexOf("\n", startExpressionIndex)
        local conditionExpression = text:sub(startExpressionIndex, conditionExpressionEndIndex - 1)
        local condition = eval.code(conditionExpression, data, true)
        
        -- find element that will be conditioned
        local endDelimiter = delimiter.close .. multiplyString("?", nestedConditions) .. "\n"
        local endDelimiterIndex = text:indexOf(endDelimiter, conditionExpressionEndIndex + 1)
        local element = text:sub(conditionExpressionEndIndex + 1, endDelimiterIndex - 1)
        
        -- condition over the element
        if condition then
          substrings[#substrings + 1] = transform(element, data, delimiter, nestedCycles, nestedConditions + 1)
        end
        
        iteratorIndex = endDelimiterIndex + delimiter.close:len() + nestedConditions + 1 -- one more because ?
      elseif text:charAt(startDelimiterIndex + delimiter.open:len()) == "=" then  -- set
        local startExpressionIndex = startDelimiterIndex + delimiter.open:len() + 1 -- one more because =
        local endDelimiterIndex = text:indexOf(delimiter.close .. "=", startExpressionIndex)
        
        -- find property name and value
        local propertyNameEndIndex = text:indexOf("=", startExpressionIndex)
        local propertyName = text:sub(startExpressionIndex, propertyNameEndIndex - 1)
        local propertyExpression = text:sub(propertyNameEndIndex + 1, endDelimiterIndex - 1)
        data[propertyName:trim()] = eval.code(propertyExpression, data, true)
        
        iteratorIndex = endDelimiterIndex + delimiter.close:len() + 1 -- one more because =
      elseif text:charAt(startDelimiterIndex + delimiter.open:len()) == "@" then  -- require
        local startExpressionIndex = startDelimiterIndex + delimiter.open:len() + 1 -- one more because @
        local endDelimiterIndex = text:indexOf(delimiter.close .. "@", startExpressionIndex)
        
        -- find required module
        local moduleName = text:sub(startExpressionIndex, endDelimiterIndex - 1)
        local names = util.split(moduleName:trim(), ".")
        data[names[#names]] = require(moduleName:trim()) -- set propertyName to be the last name after "."
        
        iteratorIndex = endDelimiterIndex + delimiter.close:len() + 1 -- one more because @
      else  -- replace
        local startExpressionIndex = startDelimiterIndex + delimiter.open:len()
        local endDelimiterIndex = text:indexOf(delimiter.close, startExpressionIndex)

        -- find property value
        local propertyExpression = text:sub(startExpressionIndex, endDelimiterIndex - 1)
        substrings[#substrings + 1] = eval.code(propertyExpression, data, true)

        iteratorIndex = endDelimiterIndex + delimiter.close:len()
      end
    else
      substrings[#substrings + 1] = text:sub(iteratorIndex, text:len())
    end  
  until startDelimiterIndex == nil

  return table.concat(substrings) -- concatenate all substrings
end


return function (text, data, parameters)
  local datapool = parameters or {}
  if data then setmetatable(datapool, {__index = data}) end
  return transform(text, datapool, {open = "{{", close = "}}"}, 1, 1)
end