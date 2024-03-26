-- Copyright (C) 2024, StrumaSoft


local function hasMany (type, property)
  if property then
    return {type = type .. "." .. property, has = "many"}
  else
    return {type = type, has = "many"}
  end
end

local function hasOne (type, property)
  if property then
    return {type = type .. "." .. property, has = "one"}
  else
    return {type = type, has = "one"}
  end
end

return { hasMany = hasMany, hasOne = hasOne }