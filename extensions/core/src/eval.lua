local param = require "param"


local function load_code(code, environment)
  if setfenv and loadstring then
    local f = assert(loadstring(code))
    setfenv(f,environment)
    return f
  else
    return assert(load(code, nil, "t", environment))
  end
end


local function load_file(fileName, environment)
  if setfenv and loadfile then
    local f = assert(loadfile(fileName))
    setfenv(f,environment)
    return f
  else
    return assert(loadfile(fileName, "t", environment))
  end
end


local function evalCode(code, environment, addReturn)
  if addReturn then
    local f = load_code("return " .. code, environment)
    local res, res2, res3, res4, res5 = f()
    return res, res2, res3, res4, res5
  else
    local f = load_code(code, environment)
    local res, res2, res3, res4, res5 = f()
    return res, res2, res3, res4, res5
  end
end


local function evalFile(fileName, environment)
  local f = load_file(fileName, environment)
  local res, res2, res3, res4, res5 = f()
  return res, res2, res3, res4, res5
end


return {
  code = evalCode,
  file = evalFile
}