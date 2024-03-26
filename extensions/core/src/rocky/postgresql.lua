-- Copyright (C) 2024, StrumaSoft
--
-- Credits:
--   pgmoon PostgreSQL driver https://github.com/leafo/pgmoon
--   resty PostgreSQL driver https://github.com/azurewang/lua-resty-postgres
--   resty MySQL driver https://github.com/openresty/lua-resty-mysql
--
-- Requires:
--   OpenSSL
--   Rocky Crypto
--   Rocky NGX SSL


local bit = require "bit"
local band = bit.band
local lshift = bit.lshift
local rshift = bit.rshift
local tcp = ngx.socket.tcp
local crypto = require "rocky.crypto"
local b64 = crypto.encode_base64
local _b64 = crypto.decode_base64
local xor = crypto.xor
local random_string = crypto.random_string
local pbkdf2_sha256 = crypto.pbkdf2_sha256
local hmac_sha256 = crypto.hmac_sha256
local sha256 = crypto.sha256
local md5 = crypto.md5
local hash_pem = crypto.hash_pem
local get_peer_pem = crypto.get_peer_pem
local get_peer_signature_name = crypto.get_peer_signature_name
local parse_hash = crypto.parse_hash
local NULL = "\0"
local ffffffff = string.char(255, 255, 255, 255)


local function _len (input, inputType)
  inputType = inputType or type(input)
  if inputType == "string" then
    return #input
  elseif inputType == "table" then
    local length = 0
    for _, innerElement in ipairs(input) do
      length = length + _len(innerElement)
    end
    return length
  else
    error("Don't know how to calculate length of " .. tostring(inputType))
  end
end

local function flipped (inputTable)
  local keysList = {}
  for key in pairs(inputTable) do
    keysList[#keysList + 1] = key
  end
  for _, originalKey in ipairs(keysList) do
    local value = inputTable[originalKey]
    inputTable[value] = originalKey
  end
  return inputTable
end

local MSG_TYPE_F = flipped({
  password = "p",
  query = "Q",
  parse = "P",
  bind = "B",
  describe = "D",
  execute = "E",
  close = "C",
  sync = "S",
  terminate = "X"
})

local MSG_TYPE_B = flipped({
  auth = "R",
  parameter_status = "S",
  backend_key = "K",
  ready_for_query = "Z",
  parse_complete = "1",
  bind_complete = "2",
  close_complete = "3",
  row_description = "T",
  data_row = "D",
  command_complete = "C",
  error = "E",
  notice = "N",
  notification = "A"
})

local ERROR_TYPES = flipped({
  severity = "S",
  code = "C",
  message = "M",
  position = "P",
  detail = "D",
  schema = "s",
  table = "t",
  constraint = "n"
})

local PG_TYPES = {
  [16] = "boolean",
  [20] = "number",
  [21] = "number",
  [23] = "number",
  [700] = "number",
  [701] = "number",
  [1700] = "number",
}


local function select_hash (signature_name) 
  local hash = parse_hash(signature_name)
  if not hash then return nil, "Not parsable hash function from " .. signature_name end
  if hash == "md5" or hash == "sha1" then hash = "sha256" end
  return hash
end

local function parse_error (err_msg)
  local severity, message, detail, position
  local error_data = { }
  local offset = 1
  while offset <= #err_msg do
    local t = err_msg:sub(offset, offset)
    local str = err_msg:match("[^%z]+", offset + 1)
    if not str then
      break
    end
    offset = offset + (2 + #str)
    local field = ERROR_TYPES[t]
    if field then
      error_data[field] = str
    end
    if ERROR_TYPES.severity == t then
      severity = str
    elseif ERROR_TYPES.message == t then
      message = str
    elseif ERROR_TYPES.position == t then
      position = str
    elseif ERROR_TYPES.detail == t then
      detail = str
    end
  end
  local msg = tostring(severity) .. ": " .. tostring(message)
  if position then
    msg = tostring(msg) .. " (" .. tostring(position) .. ")"
  end
  if detail then
    msg = tostring(msg) .. "\n" .. tostring(detail)
  end
  return msg, error_data
end

local function encode_int (n, bytes)
  if bytes == nil then
    bytes = 4
  end
  if n == 0 then
    if bytes == 2 then
      return "\0\0"
    end
    if bytes == 4 then
      return "\0\0\0\0"
    end
  end
  if 4 == bytes then
    local a = band(n, 0xff)
    local b = band(rshift(n, 8), 0xff)
    local c = band(rshift(n, 16), 0xff)
    local d = band(rshift(n, 24), 0xff)
    return string.char(d, c, b, a)
  elseif 2 == bytes then
    local a = band(n, 0xff)
    local b = band(rshift(n, 8), 0xff)
    return string.char(b, a)
  else
    return error("don't know how to encode " .. tostring(bytes) .. " byte(s)")
  end
end

local function decode_int (str, bytes)
  if bytes == nil then
    bytes = #str
  end
  if "\0\0" == str or "\0\0\0\0" == str then
    return 0
  end
  if 4 == bytes then
    local d, c, b, a = str:byte(1, 4)
    return a + lshift(b, 8) + lshift(c, 16) + lshift(d, 24)
  elseif 2 == bytes then
    local b, a = str:byte(1, 2)
    return a + lshift(b, 8)
  else
    return error("don't know how to decode " .. tostring(bytes) .. " byte(s)")
  end
end

local function receive_message (self)
  local prefix, err = self.sock:receive(5)
  if not prefix then
    return nil, "receive_message: failed to get type: " .. tostring(err)
  end
  local t = prefix:sub(1, 1)
  local len = prefix:sub(2)
  len = decode_int(len)
  len = len - 4
  local msg = self.sock:receive(len)
  return t, msg
end

local function send_message (self, t, data, len)
  if len == nil then
    len = _len(data)
  end
  len = len + 4
  return self.sock:send({
    t,
    encode_int(len),
    data
  })
end

local function send_ssl_message (self)
  local ok, err = self.sock:send({
    encode_int(8),
    encode_int(80877103)
  })
  if not ok then
    return nil, err
  end
  local t
  t, err = self.sock:receive(1)
  if not t then
    return nil, err
  end
  if t == MSG_TYPE_B.parameter_status then
    return self.sock:sslhandshake(false, nil, self.config.ssl_verify)
  elseif t == MSG_TYPE_B.error or self.config.ssl_required then
    return nil, "the server does not support SSL connections"
  else
    return true
  end
end

local function send_startup_message (self)
  assert(self.config.user, "missing user for connect")
  assert(self.config.database, "missing database for connect")
  local data = {
    encode_int(196608),
    "user",
    NULL,
    self.config.user,
    NULL,
    "database",
    NULL,
    self.config.database,
    NULL,
    "application_name",
    NULL,
    self.config.application_name or "lua",
    NULL,
    NULL
  }
  return self.sock:send({
    encode_int(_len(data) + 4),
    data
  })
end

local function wait_until_ready (self)
  while true do
    local t, msg = receive_message(self)
    if not t then
      return nil, msg
    end
    if MSG_TYPE_B.error == t then
      return nil, parse_error(msg)
    end
    if MSG_TYPE_B.ready_for_query == t then
      break
    end
  end
  return true
end

local function check_auth (self)
  local t, msg = receive_message(self)
  if not t then
    return nil, msg
  end
  if MSG_TYPE_B.error == t then
    return nil, parse_error(msg)
  elseif MSG_TYPE_B.auth == t then
    return true
  else
    return error("unknown response from auth")
  end
end

local function cleartext_auth (self, msg)
  assert(self.config.password, "the database is requesting a password for authentication but you did not provide a password")
  send_message(self, MSG_TYPE_F.password, {
    self.config.password,
    NULL
  })
  return check_auth(self)
end

local function md5_auth (self, msg)
  local salt = msg:sub(5, 8)
  assert(self.config.password, "missing password, required for connect")
  send_message(self, MSG_TYPE_F.password, {
    "md5",
    md5(md5(self.config.password .. self.config.user) .. salt),
    NULL
  })
  return check_auth(self)
end


local function scram_sha_256_auth (self, msg)
  assert(self.config.password, "the database is requesting a password for authentication but you did not provide a password")
  local c_nonce = random_string(18)
  local nonce = "r=" .. c_nonce
  local username = "n=" .. self.config.user
  local client_first_message_bare = username .. "," .. nonce
  local plus = false
  local bare = false
  if msg:match("SCRAM%-SHA%-256%-PLUS") then
    plus = true
  elseif msg:match("SCRAM%-SHA%-256") then
    bare = true
  else
    error("unsupported SCRAM mechanism name: " .. tostring(msg))
  end
  local gs2_cbind_flag
  local gs2_header
  local cbind_input
  local mechanism_name
  if bare then
    gs2_cbind_flag = "n"
    gs2_header = gs2_cbind_flag .. ",,"
    cbind_input = gs2_header
    mechanism_name = "SCRAM-SHA-256" .. NULL
  elseif plus then
    local cb_name = "tls-server-end-point"
    gs2_cbind_flag = "p=" .. cb_name
    gs2_header = gs2_cbind_flag .. ",,"
    mechanism_name = "SCRAM-SHA-256-PLUS" .. NULL
    local cbind_data, pem, hash, err
    if self.sock.getpeercertificate then
      local server_cert, errmsg = self.sock:getpeercertificate()
      if not server_cert then return nil, errmsg or "Error gtting server certificate" end
      pem, err = server_cert:pem()
      if not pem then return nil, err or "Error getting peer pem" end
      hash, err = select_hash(server_cert:getsignaturename())
      if not hash then return nil, err end
    else
      local ssl, errmsg = require("rocky.ngxssl").get_socket_ssl(self.sock)
      if ssl == nil then return nil, errmsg end
      pem, err = get_peer_pem(ssl)
      if not pem then return nil, err end
      hash, err = select_hash(get_peer_signature_name(ssl))
      if not hash then return nil, err end
    end
    cbind_data, err = hash_pem(pem, hash)
    if not cbind_data then return nil, err end
    cbind_input = gs2_header .. cbind_data
  end
  local client_first_message = gs2_header .. client_first_message_bare
  send_message(self, MSG_TYPE_F.password, {
    mechanism_name,
    encode_int(#client_first_message),
    client_first_message
  })
  local t
  t, msg = receive_message(self)
  if not t then 
    return nil, msg
  end
  local server_first_message = msg:sub(5)
  local int32 = decode_int(msg, 4)
  if int32 == nil or int32 ~= 11 then
    return nil, "server_first_message error: " .. msg
  end
  local channel_binding = "c=" .. b64(cbind_input)
  nonce = server_first_message:match("([^,]+)")
  if not nonce then
    return nil, "malformed server message (nonce)"
  end
  local client_final_message_without_proof = channel_binding .. "," .. nonce
  local salt = server_first_message:match(",s=([^,]+)")
  if not salt then
    return nil, "malformed server message (salt)"
  end
  local i = server_first_message:match(",i=(.+)")
  if not i then
    return nil, "malformed server message (iteraton count)"
  end
  if tonumber(i) < 4096 then
    return nil, "the iteration-count sent by the server is less than 4096"
  end
  local salted_password, err = pbkdf2_sha256(self.config.password, _b64(salt), tonumber(i))
  if not salted_password then
    return nil, err
  end
  local client_key
  client_key, err = hmac_sha256(salted_password, "Client Key")
  if not client_key then
    return nil, err
  end
  local stored_key
  stored_key, err = sha256(client_key)
  if not stored_key then
    return nil, err
  end
  local auth_message = tostring(client_first_message_bare) .. "," .. tostring(server_first_message) .. "," .. tostring(client_final_message_without_proof)
  local client_signature
  client_signature, err = hmac_sha256(stored_key, auth_message)
  if not client_signature then
    return nil, err
  end
  local proof = xor(client_key, client_signature)
  if not proof then
    return nil, "failed to generate the client proof"
  end
  local client_final_message = tostring(client_final_message_without_proof) .. ",p=" .. tostring(b64(proof))
  send_message(self, MSG_TYPE_F.password, {
    client_final_message
  })
  t, msg = receive_message(self)
  if not t then
    return nil, msg
  end
  local server_key
  server_key, err = hmac_sha256(salted_password, "Server Key")
  if not server_key then
    return nil, err
  end
  local server_signature
  server_signature, err = hmac_sha256(server_key, auth_message)
  if not server_signature then
    return nil, err
  end
  server_signature = b64(server_signature)
  local sent_server_signature = msg:match("v=([^,]+)")
  if server_signature ~= sent_server_signature then
    return nil, "authentication exchange unsuccessful"
  end
  return check_auth(self)
end

local function auth (self)
  local t, msg = receive_message(self)
  if not t then 
    return nil, msg 
  end
  if not (MSG_TYPE_B.auth == t) then
    if MSG_TYPE_B.error == t then
      return nil, parse_error(msg)
    end
    error("unexpected message during auth: " .. tostring(t))
  end
  local auth_type = decode_int(msg, 4)
  if 0 == auth_type then
    return true
  elseif 3 == auth_type then
    return cleartext_auth(self, msg)
  elseif 5 == auth_type then
    return md5_auth(self, msg)
  elseif 10 == auth_type then
    return scram_sha_256_auth(self, msg)
  else
    return error("don't know how to auth: " .. tostring(auth_type))
  end
end

local function parse_header (row)
  local num_fields = decode_int(row:sub(1, 2))
  local offset = 3
  local header = {}
  for i = 1, num_fields do
    local name = row:match("[^%z]+", offset)
    offset = offset + #name - 1 -- last char of the name

    local data_type = decode_int(row:sub(offset + 8, offset + 11))
    data_type = PG_TYPES[data_type] or "string"

    local format = decode_int(row:sub(offset + 18, offset + 19))
    assert(format == 0, "Unsupported format")

    header[i] = {name = name, type = data_type}
    offset = offset + 20 -- first char of the next name
  end
  return header
end

local function parse_data (row, fields)
  local num_fields = decode_int(row:sub(1, 2))
  local offset = 3
  local obj = {}
  for i = 1, num_fields do
    local field = fields[i]
    if not field then break end

    if row:find(ffffffff, offset, true) == offset then
      obj[field.name] = ""
      offset = offset + 4
    else
      local len = decode_int(row:sub(offset, offset + 3))
      offset = offset + 4
  
      if len < 0 then break end

      local value = row:sub(offset, offset + len - 1)
      offset = offset + len

      if field.type == "number" then
        value = tonumber(value)
      elseif field.type == "boolean" then
        value = value == "t"
      end
      obj[field.name] = value
    end
  end
  return obj
end

local function read_query_result (self)
  local err_msg, list, header
  local set = {}
  while true do
    local t, msg = receive_message(self)
    if not t then
      return nil, msg
    end
    if MSG_TYPE_B.row_description == t then
      header = parse_header(msg)
      list = {}
    elseif MSG_TYPE_B.data_row == t then
      list[#list + 1] = parse_data(msg, header)
    elseif MSG_TYPE_B.error == t then
      err_msg = msg
    elseif MSG_TYPE_B.command_complete == t then
      set[#set + 1] = list -- will not increase the size of set when list=nil
      list = nil -- reset list
    elseif MSG_TYPE_B.ready_for_query == t then
      break
    end
  end
  if err_msg then return nil, parse_error(err_msg) end
  if #set == 1 then return set[1] else return set end
end


-----------
--- API ---
-----------
local _M = { _VERSION = '0.1' }
local mt = { __index = _M }

local STATE_CONNECTED = 1
local STATE_COMMAND_SENT = 2

function _M.new ()
  local sock, err = tcp()
  if not sock then 
    return nil, err 
  end
  return setmetatable({ sock = sock }, mt)
end

function _M.set_timeout (self, timeout)
  local sock = self.sock
  if not sock then 
    return nil, "not initialized" 
  end
  return sock:settimeout(timeout)
end

function _M.connect (self, opts)
  self.config = opts
  local sock = self.sock
  if not sock then 
    return nil, "not initialized" 
  end
  local ok, err = sock:connect(self.config.host, self.config.port or 5432, self.config)
  if not ok then 
    return nil, 'failed to connect: ' .. err 
  end
  local reused = sock:getreusedtimes()
  if reused and reused > 0 then
    self.state = STATE_CONNECTED
    return 1
  end
  if self.config.ssl then
    ok, err = send_ssl_message(self)
    if not ok then 
      return nil, err 
    end
  end
  ok, err = send_startup_message(self)
  if not ok then 
    return nil, err 
  end
  ok, err = auth(self)
  if not ok then 
    return nil, err 
  end
  ok, err = wait_until_ready(self)
  if not ok then 
    return nil, err 
  end
  self.state = STATE_CONNECTED
  return 1
end

function _M.set_keepalive(self, ...)
  local sock = self.sock
  if not sock then
    return nil, "not initialized"
  end
  if self.state ~= STATE_CONNECTED then
    return nil, "cannot be reused in the current connection state: "
      .. (self.state or "nil")
  end
  self.state = nil
  return sock:setkeepalive(...)
end

function _M.get_reused_times(self)
  local sock = self.sock
  if not sock then
    return nil, "not initialized"
  end
  return sock:getreusedtimes()
end

function _M.close(self)
  local sock = self.sock
  if not sock then
    return nil, "not initialized"
  end
  self.state = nil
  send_message(self, MSG_TYPE_F.terminate, { })
  return sock:close()
end

function _M.send_query(self, query)
  if self.state ~= STATE_CONNECTED then
    return nil, "cannot send query in the current context: "
      .. (self.state or "nil")
  end
  local sock = self.sock
  if not sock then
     return nil, "not initialized"
  end
  if query:find(NULL) then
    return nil, "invalid null byte in query"
  end
  local bytes, err = send_message(self, MSG_TYPE_F.query, {
    query,
    NULL
  })
  if not bytes then
    return nil, err
  end
  self.state = STATE_COMMAND_SENT
  return bytes
end

function _M.read_result(self, est_nrows)
  if self.state ~= STATE_COMMAND_SENT then
    return nil, "cannot read result in the current context: "
      .. (self.state or "nil")
  end
  local sock = self.sock
  if not sock then
    return nil, "not initialized"
  end
  local res, err = read_query_result(self)
  self.state = STATE_CONNECTED
  return res, err
end

function _M.query(self, query, est_nrows)
  local bytes, err = self:send_query(query)
  if not bytes then
    return nil, "failed to send query: " .. err
  end
  return self:read_result(est_nrows)
end

return _M