local property = require "property"
local luaorm = require "rocky.luaorm"
local types = require "type"

local opts = {types = types}
for k,v in pairs(property.databaseConnection) do opts[k] = v end

return {
  connect = function ()
    return luaorm.connect(opts)
  end
}
