-- Copyright (C) 2024 StrumaSoft
-- Requires LuaSocket
-- Requires LuaSec
-- Requires OpenSSL
-- Requires Rocky Crypto package on top of OpenSSL


local socket = require "socket"
local ssl = require "ssl"
local crypto = require "rocky.crypto"
local unpack = table.unpack or unpack


----------
-- UTIL --
----------
local function flat (t)
  if type(t) == "string" then return t end
  if type(t) == "number" then return tostring(t) end
  if type(t) == "boolean" then return tostring(t) end
  if type(t) == "table" then
    local sum = {}
    for _,v in ipairs(t) do
      sum[#sum + 1] = flat(v)
    end
    return table.concat(sum)
  end
  return ""
end

local function dumpstr (str)
  if not str then return {0, ""} end 
  local res = ""
  for i = 1, #str do
    local char = string.sub(str, i, i)
    local code = string.byte(char)
    if code < 33 or code > 126 then
      res = res .. string.format("\\%02X", code)
    else
      res = res .. char
    end
  end
  return {#str, res}
end

local function dump (t)
  local traverse
  traverse = function (t, level)
    local lines = {}
    for key, value in pairs(t) do
      if type(value) == "table" then
        lines[#lines + 1] = string.rep("  ", level) .. key .. " = {"
        lines[#lines + 1] = traverse(value, level + 1)
        lines[#lines + 1] = string.rep("  ", level) .. "}"
      else
        lines[#lines + 1] = string.rep("  ", level) .. key .. " = " .. tostring(value)
      end
    end
    return table.concat(lines, "\n")
  end
  return table.concat({"{", traverse(t, 1), "}"}, "\n")
end


---------
-- NGX --
---------
local _socket = {} -- forward declaration

local ngx = {
  fake = true,
  config = {
    subsystem = "http",
    ngx_lua_version = 10000
  },
  null = "\0",
  sha1_bin = crypto.sha1,
  md5 = crypto.md5,
  say = print,
  log = function (level, ...)
    print(...)
  end,
  socket = {
    tcp = function ()
      local sock, err = socket.tcp()
      if not sock then
        print("error creating socket: " .. err)
        return nil, err
      end
      return _socket.new(sock)
    end
  },
  flat = flat,
  dumpstr = dumpstr,
  dump = dump,
}

package.loaded["ngx.base64"] = {
  encode_base64url = crypto.encode_base64,
  decode_base64url = crypto.decode_base64,
}


------------
-- SOCKET --
------------
function _socket.new(sock)
  local self = {sock = sock}
  setmetatable(self, { __index = _socket })
  return self
end

function _socket:send (data)
  local packet = data
  if type(data) == "table" then packet = flat(data) end
  --ngx.say(string.format("<= (%d) {%s}", unpack(dumpstr(packet))))
  return self.sock:send(packet)
end

function _socket:receive (len)
  local packet, err = self.sock:receive(len)
  --ngx.say(string.format("=> (%d) {%s}", unpack(dumpstr(packet))))
  return packet, err
end

function _socket:sslhandshake ()
  assert(ngx.ssl, "set luasec ssl params into ngx.ssl")
  local sslsocket, err = ssl.wrap(self.sock, ngx.ssl)
  if not sslsocket then return nil, err end
  self.luasec = true
  self.sock = sslsocket
  local ok, err = self.sock:dohandshake()
  return ok, err
end

function _socket:getpeercertificate ()
  return self.sock:getpeercertificate()
end

function _socket:settimeout (timeout)
  return self.sock:settimeout(timeout)
end

function _socket:connect (host, port, options)
  -- tcpsock:connect("unix:/path/to/unix-domain.socket", options_table?)
  return self.sock:connect(host, port)
end

function _socket:getreusedtimes ()
  return 0
end

function _socket:setkeepalive (...)
  return self.sock:setoption('keepalive', true)
end

function _socket:close ()
  if self.luasec then
    -- luasec does not return anything on success
    self.sock:close()
    return 1
  else
    return self.sock:close()
  end
end


return ngx