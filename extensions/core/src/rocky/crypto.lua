-- Copyright (C) 2024, StrumaSoft
--
-- Requires: 
--   LuaJIT FFI
--   OpenSSL


local bit = require "bit"
local bxor = bit.bxor
local bor = bit.bor
local band = bit.band
local ffi = require "ffi"
ffi.cdef [[
  /******* Hash *******/
  
  unsigned char *MD5(const unsigned char *d, size_t n, unsigned char *md);
  unsigned char *SHA1(const unsigned char *d, size_t n, unsigned char *md);
  unsigned char *SHA224(const unsigned char *d, size_t n, unsigned char *md);
  unsigned char *SHA256(const unsigned char *d, size_t n, unsigned char *md);
  unsigned char *SHA384(const unsigned char *d, size_t n, unsigned char *md);
  unsigned char *SHA512(const unsigned char *d, size_t n, unsigned char *md);
  
  
  /******* HMAC & PBKDF2 *******/
  
  typedef struct env_md_st EVP_MD;
  typedef struct env_md_ctx_st EVP_MD_CTX;
  
  const EVP_MD *EVP_md2(void);
  const EVP_MD *EVP_md4(void);
  const EVP_MD *EVP_md5(void);
  const EVP_MD *EVP_md5_sha1(void);
  const EVP_MD *EVP_blake2b512(void);
  const EVP_MD *EVP_blake2s256(void);
  const EVP_MD *EVP_sha1(void);
  const EVP_MD *EVP_sha224(void);
  const EVP_MD *EVP_sha256(void);
  const EVP_MD *EVP_sha384(void);
  const EVP_MD *EVP_sha512(void);
  const EVP_MD *EVP_sha512_224(void);
  const EVP_MD *EVP_sha512_256(void);
  const EVP_MD *EVP_sha3_224(void);
  const EVP_MD *EVP_sha3_256(void);
  const EVP_MD *EVP_sha3_384(void);
  const EVP_MD *EVP_sha3_512(void);
  const EVP_MD *EVP_shake128(void);
  const EVP_MD *EVP_shake256(void);
  const EVP_MD *EVP_mdc2(void);
  const EVP_MD *EVP_ripemd160(void);
  const EVP_MD *EVP_whirlpool(void);
  const EVP_MD *EVP_sm3(void);
  
  unsigned char *HMAC(const EVP_MD *evp_md, const void *key,
    int key_len, const unsigned char *d, int n,
    unsigned char *md, unsigned int *md_len);
  
  int PKCS5_PBKDF2_HMAC(const char *pass, int passlen,
    const unsigned char *salt, int saltlen, int iter,
    const EVP_MD *digest,
    int keylen, unsigned char *out);
  
  int PKCS5_PBKDF2_HMAC_SHA1(const char *pass, int passlen,
    const unsigned char *salt, int saltlen, int iter,
    int keylen, unsigned char *out);


  /******* RANDOM *******/
    
  typedef unsigned long BN_ULONG;
  typedef struct bignum_st BIGNUM;
  
  BIGNUM *BN_new(void);
  BIGNUM *BN_secure_new(void);
  void BN_clear(BIGNUM *a);
  void BN_free(BIGNUM *a);
  void BN_clear_free(BIGNUM *a);
  char *BN_bn2dec(const BIGNUM *a);
  
  int BN_rand(BIGNUM *rnd, int bits, int top, int bottom);
  int BN_pseudo_rand(BIGNUM *rnd, int bits, int top, int bottom);
  int BN_rand_range(BIGNUM *rnd, BIGNUM *range);
  int BN_pseudo_rand_range(BIGNUM *rnd, BIGNUM *range);
  
  int RAND_bytes(unsigned char *buf, int num);
  
  
  /******* Certificate *******/
  
  typedef struct file FILE;
  typedef struct bio_st BIO;
  typedef int pem_password_cb (char *buf, int size, int rwflag, void *userdata);
  typedef struct x509_st X509;
  typedef struct env_md_st EVP_MD;
  
  FILE *fopen(const char *, const char *);
  int fclose(FILE *);
  X509 *PEM_read_X509(FILE *fp, X509 **x, void *(*cb)(const char *), void *u);
  BIO *BIO_new_mem_buf(const void *buf, int len);
  X509 *PEM_read_bio_X509(BIO *bp, X509 **x, pem_password_cb *cb, void *u);
  int BIO_free(BIO *a);
  void X509_free(X509 *);
  int i2d_X509(X509 *x, unsigned char **out);
  const EVP_MD *EVP_get_digestbyname(const char *name);
  int EVP_Digest(const void *data, size_t count, unsigned char *md, unsigned int *size, const void *type, void *impl);

  typedef struct ssl_st SSL;
  typedef struct bio_st BIO;
  typedef struct x509_st X509;
  typedef struct bio_method_st BIO_METHOD;
  
  X509 *SSL_get1_peer_certificate(const SSL *ssl);
  const BIO_METHOD *BIO_s_mem(void);
  BIO *BIO_new(const BIO_METHOD *type);
  void BIO_free(BIO *bio);
  int PEM_write_bio_X509(BIO *bio, X509 *x);
  long BIO_ctrl(BIO *bp, int cmd, long larg, void *parg);
  void X509_free(X509 *a);
  
  X509 *SSL_get1_peer_certificate(const SSL *s);
  int X509_get_signature_nid(const X509 *x);
  const char *OBJ_nid2sn(int n);
  
  /******* HIGH-LEVEL CRYPTOGRAPHIC FUNCTIONS *******/
  
  struct evp_cipher_ctx_st;
  typedef struct evp_cipher_ctx_st EVP_CIPHER_CTX;
  struct evp_cipher_st;
  typedef struct evp_cipher_st EVP_CIPHER;
  struct engine_st;
  typedef struct engine_st ENGINE;
  
  EVP_CIPHER_CTX *EVP_CIPHER_CTX_new(void);
  int EVP_CIPHER_CTX_reset(EVP_CIPHER_CTX *ctx);
  void EVP_CIPHER_CTX_free(EVP_CIPHER_CTX *ctx);

  int EVP_EncryptInit_ex(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *type,
    ENGINE *impl, unsigned char *key, unsigned char *iv);
  int EVP_EncryptUpdate(EVP_CIPHER_CTX *ctx, unsigned char *out,
    int *outl, unsigned char *in, int inl);
  int EVP_EncryptFinal_ex(EVP_CIPHER_CTX *ctx, unsigned char *out,
    int *outl);
  
  int EVP_DecryptInit_ex(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *type,
    ENGINE *impl, unsigned char *key, unsigned char *iv);
  int EVP_DecryptUpdate(EVP_CIPHER_CTX *ctx, unsigned char *out,
    int *outl, unsigned char *in, int inl);
  int EVP_DecryptFinal_ex(EVP_CIPHER_CTX *ctx, unsigned char *outm,
    int *outl);
  
  int EVP_CipherInit_ex(EVP_CIPHER_CTX *ctx, const EVP_CIPHER *type,
    ENGINE *impl, unsigned char *key, unsigned char *iv, int enc);
  int EVP_CipherUpdate(EVP_CIPHER_CTX *ctx, unsigned char *out,
    int *outl, unsigned char *in, int inl);
  int EVP_CipherFinal_ex(EVP_CIPHER_CTX *ctx, unsigned char *outm,
    int *outl);
  
  
  /******* CIPHERS *******/
  
  const EVP_CIPHER *EVP_aes_128_cbc(void);
  const EVP_CIPHER *EVP_aes_192_cbc(void);
  const EVP_CIPHER *EVP_aes_256_cbc(void);
]]

local C = ffi.load("ssl")


local function decodeHex(str)
  return (str:gsub('..', function (cc)
    return string.char(tonumber(cc, 16))
  end))
end
local function encodeHex(str)
  return (str:gsub('.', function (c)
    return string.format('%02x', string.byte(c))
  end))
end


local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function encodeBase64 (data)
  if not data then return nil end
  return ((data:gsub('.', function(x) 
    local r,b='',x:byte()
    for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
    return r;
  end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
    if (#x < 6) then return '' end
    local c=0
    for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
    return b:sub(c+1,c+1)
  end)..({ '', '==', '=' })[#data%3+1])
end
local function decodeBase64 (data)
  if not data then return nil end
  data = data:gsub('[^'..b..'=]', '')
  return (data:gsub('.', function(x)
    if (x == '=') then return '' end
    local r,f='',(b:find(x)-1)
    for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
    return r;
  end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
    if (#x ~= 8) then return '' end
    local c=0
    for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
    return string.char(c)
  end))
end


local function xor (a, b)
  if not a or not b or #a ~= #b then return nil end
  local result = {}
  for i = 1, #a do
    local x, y = a:byte(i), b:byte(i)
    if not (x and y) then return nil end
    result[i] = string.char(bxor(x, y))
  end
  return table.concat(result)
end


local function hashString (str, method, length)
  local md = ffi.new("unsigned char[?]", length)
  C[method](str, #str, md)
  return ffi.string(md, length)
end

-- https://www.openssl.org/docs/manmaster/man3/MD5.html
local function md5 (str)
  return hashString(str, "MD5", 16)
end

-- https://www.openssl.org/docs/manmaster/man3/SHA1.html
local function sha1 (str)
  return hashString(str, "SHA1", 20)
end

local function sha224 (str)
  return hashString(str, "SHA224", 28)
end

-- https://www.openssl.org/docs/manmaster/man3/SHA256.html
local function sha256 (str)
  return hashString(str, "SHA256", 32)
end

local function sha384 (str)
  return hashString(str, "SHA384", 48)
end

local function sha512 (str)
  return hashString(str, "SHA512", 64)
end


-- https://www.openssl.org/docs/manmaster/man3/HMAC.html
local function hmac (key, str, digest, len)
  local md = ffi.new("unsigned char[?]", len)
  local md_len = ffi.new("int[1]", 0)
  C.HMAC(digest, key, #key, str, #str, md, md_len)
  return ffi.string(md, tonumber(md_len[0]))
end

local function hmac_sha1 (key, str)
  return hmac(key, str, C.EVP_sha1(), 20)
end

local function hmac_sha256 (key, str)
  return hmac(key, str, C.EVP_sha256(), 32)
end


-- https://www.openssl.org/docs/manmaster/man3/PKCS5_PBKDF2_HMAC.html
local function pbkdf2 (pass, salt, iter, digest, len)
  local out = ffi.new("unsigned char[?]", len)
  local result = C.PKCS5_PBKDF2_HMAC(pass, #pass, salt, #salt, iter, digest, len, out)
  if result == 1 then 
    return ffi.string(out, len)
  else
    return nil
  end
end

local function pbkdf2_sha256 (pass, salt, iter)
  return pbkdf2(pass, salt, iter, C.EVP_sha256(), 32)
end

local function pbkdf2_sha1 (pass, salt, iter)
  return pbkdf2(pass, salt, iter, C.EVP_sha1(), 20)
end


-- https://www.openssl.org/docs/manmaster/man3/PKCS5_PBKDF2_HMAC_SHA1.html
-- http://www.neurotechnics.com/tools/pbkdf2
local function passwordKey (str, _salt, _length, _iterations)
  local salt = _salt or randomString(20)
  local len = _length or 20
  local iterations = _iterations or 4096
  local md = ffi.new("unsigned char[?]", len)
  local result = C.PKCS5_PBKDF2_HMAC_SHA1(str, #str, salt, #salt, iterations, len, md)
  if result == 1 then 
    return ffi.string(md, len), salt
  else
    return nil
  end
end


-- https://www.openssl.org/docs/manmaster/man3/BN_rand.html
-- https://www.openssl.org/docs/manmaster/man3/BN_new.html
local function randomNumber (bits)
  local bn = C.BN_new()
  if C.BN_rand(bn, bits, 0, 0) then
    local decstr = C.BN_bn2dec(bn)
    if not decstr then
      C.BN_clear_free(bn)
      error("can not convert BIGNUM to decimal string")
    end
    local num = tonumber(ffi.string(decstr), 10)
    C.BN_clear_free(bn)
    return num
  else
    C.BN_clear_free(bn)
    error("can not create random number")
  end
end


-- https://github.com/openssl/openssl/blob/master/apps/rand.c
local symbol = {
  "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P",
  "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f",
  "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", 
  "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "+", "/", 
}
local function randomString (length)
  local hash = {}
  local bn = C.BN_new()
  for i=1,length do
    if C.BN_rand(bn, 20, 0, 0) then
      local decstr = C.BN_bn2dec(bn)
      if not decstr then
        C.BN_clear_free(bn)
        error("can not convert BIGNUM to decimal string")
      end
      local num = tonumber(ffi.string(decstr), 10)
      local index = num % 64
      if index == 0 then index = 64 end
      table.insert(hash, symbol[index])
    else
      C.BN_clear_free(bn)
      error("can not create random number")
    end
  end
  C.BN_clear_free(bn)
  return table.concat(hash)
end


local function uuid ()
  local buffer = ffi.new("unsigned char[16]")
  C.RAND_bytes(buffer, ffi.sizeof(buffer))

  -- Set version and variant bits
  buffer[6] = bor(band(buffer[6], 0x0F), 0x40) -- version 4 (random)
  buffer[8] = bor(band(buffer[8], 0x3F), 0x80) -- variant

  -- Format the UUID as a string
  return string.format(
    "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x",
    buffer[0], buffer[1], buffer[2], buffer[3],
    buffer[4], buffer[5], buffer[6], buffer[7],
    buffer[8], buffer[9], buffer[10], buffer[11],
    buffer[12], buffer[13], buffer[14], buffer[15]
  )
end


local EVP_MAX_MD_SIZE = 64
local function hash_certificate (cert, hash_function)
  local der_buf_ptr = ffi.new("unsigned char*[1]")
  local der_len = C.i2d_X509(cert, der_buf_ptr)
  C.X509_free(cert)

  if der_len < 0 then
    return nil, "Error converting PEM to DER"
  end

  local der_buf = ffi.string(der_buf_ptr[0], der_len)

  -- EVP_get_digestbyname: sha3-512 | EVP_: sha3_512
  --local md = C.EVP_get_digestbyname(hash_function)
  local md = C["EVP_" .. hash_function]()
  if md == nil then
    return nil, "Invalid hash function: " .. hash_function
  end

  local hash = ffi.new("unsigned char[?]", EVP_MAX_MD_SIZE)
  local hash_len = ffi.new("unsigned int[1]")

  if C.EVP_Digest(der_buf, der_len, hash, hash_len, md, nil) ~= 1 then
    return nil, "Failed to hash DER data"
  end

  return ffi.string(hash, hash_len[0])
end

-- { "md5", "sha1", "sha224", "sha256", "sha384", "sha512", "sha512-224", "sha512-256", "sha3-224", "sha3-256", "sha3-384", "sha3-512" }
local function hash_pem_file (filename, hash_function)
  local fp = ffi.C.fopen(filename, "rb")

  if fp == nil then
    return nil, "Error opening PEM file"
  end

  local cert = C.PEM_read_X509(fp, nil, nil, nil)
  ffi.C.fclose(fp)

  if cert == nil then
    return nil, "Error reading PEM file"
  end
  
  return hash_certificate(cert, hash_function)
end

-- { "md5", "sha1", "sha224", "sha256", "sha384", "sha512", "sha512-224", "sha512-256", "sha3-224", "sha3-256", "sha3-384", "sha3-512" }
local function hash_pem (pem, hash_function)
  local bio_mem = C.BIO_new_mem_buf(pem, #pem)
  if bio_mem == nil then
    return nill, "Error creating memory BIO"
  end

  local cert = C.PEM_read_bio_X509(bio_mem, nil, nil, nil)
  C.BIO_free(bio_mem)

  if cert == nil then
    return nil, "Error reading PEM data"
  end

  return hash_certificate(cert, hash_function)
end

local BIO_CTRL_INFO = 3
local BIO_CTRL_SET_CLOSE = 9
local BIO_CTRL_FLUSH = 11
local BIO_CLOSE = 0x01
local function get_peer_pem (ssl)
  local cert = C.SSL_get1_peer_certificate(ssl)
  if cert == nil then
    return nil, "Error getting peer certificate"
  end

  local bio = C.BIO_new(C.BIO_s_mem())
  if bio == nil then
    C.X509_free(cert)
    return nil, "Error creating memory BIO"
  end

  C.PEM_write_bio_X509(bio, cert)
  C.BIO_ctrl(bio, BIO_CTRL_FLUSH, 0, nil)

  local buffer = ffi.new("char *[1]")
  local _length = C.BIO_ctrl(bio, BIO_CTRL_INFO, 0, buffer)
  
  local length = tonumber(_length)
  local pem, err
  if length > 0 then
    pem = ffi.string(buffer[0], length)
  else
    err = "Error reading memory BIO"
  end

  C.X509_free(cert)
  C.BIO_ctrl(bio, BIO_CTRL_SET_CLOSE, BIO_CLOSE, nil)
  C.BIO_free(bio)
  
  return pem, err
end

local function get_peer_signature_name (ssl)
  local cert = C.SSL_get1_peer_certificate(ssl)
  if cert == nil then
    return nil, "Error getting peer certificate"
  end
  
  local nid = C.X509_get_signature_nid(cert)
  local name = C.OBJ_nid2sn(nid)
  if name == nil then
    C.X509_free(cert)
    return nil, "Error getting signature name"
  end
    
  C.X509_free(cert)
  
  return ffi.string(name)
end

local function parse_hash (input)
  local hash_algorithm = input:match("with%-(.-)$")
  if hash_algorithm then 
    return (hash_algorithm:lower():gsub("[/-]", "_"))
  end
  hash_algorithm = input:match(".*%-(.-)$")
  if hash_algorithm then 
    return (hash_algorithm:lower():gsub("[/-]", "_"))
  end
end


-- https://www.openssl.org/docs/manmaster/man3/EVP_aes_128_cbc.html
local function cipher (str, metadata, _key, _iv)
  local out = {}
  local outlen = ffi.new("int[1]", 0)
  local outbuf = ffi.new("unsigned char[?]", #str + 32)
  
  local inbuf = ffi.new("unsigned char[?]", #str)
  ffi.copy(inbuf, str, #str)
  
  if _key then assert(#_key == metadata.key_length, "key length is wrong") end
  local key = ffi.new("unsigned char[?]", metadata.key_length)
  ffi.copy(key, _key or randomString(metadata.key_length), metadata.key_length)
  
  if _iv then assert(#_iv == metadata.iv_length, "iv length is wrong") end
  local iv = ffi.new("unsigned char[?]", metadata.iv_length)
  ffi.copy(iv, _iv or randomString(metadata.iv_length), metadata.iv_length)

  local ctx = C.EVP_CIPHER_CTX_new()
  if not C.EVP_CipherInit_ex(ctx, C[metadata.cipher](), nil, key, iv, metadata.encdec) then
    C.EVP_CIPHER_CTX_free(ctx)
    error("can not init cipher")
  end

  if not C.EVP_CipherUpdate(ctx, outbuf, outlen, inbuf, #str) then
    C.EVP_CIPHER_CTX_free(ctx)
    error("can not update cipher")
  end
  table.insert(out, ffi.string(outbuf, outlen[0]))
  
  if not C.EVP_CipherFinal_ex(ctx, outbuf, outlen) then
    C.EVP_CIPHER_CTX_free(ctx)
    error("can not finalize cipher")
  end
  table.insert(out, ffi.string(outbuf, outlen[0]))

  C.EVP_CIPHER_CTX_free(ctx)
  return table.concat(out), ffi.string(key, metadata.key_length), ffi.string(iv, metadata.iv_length)
end
local function encryptAES128 (str, _key, _iv)
  local enc, key, iv = cipher(str, {encdec = 1, cipher = "EVP_aes_128_cbc", key_length = 16, iv_length = 16}, _key, _iv)
  return enc, key, iv
end
local function decryptAES128 (str, _key, _iv)
  return cipher(str, {encdec = 0, cipher = "EVP_aes_128_cbc", key_length = 16, iv_length = 16}, _key, _iv)
end
local function encryptAES192 (str, _key, _iv)
  local enc, key, iv = cipher(str, {encdec = 1, cipher = "EVP_aes_192_cbc", key_length = 24, iv_length = 24}, _key, _iv)
  return enc, key, iv
end
local function decryptAES192 (str, _key, _iv)
  return cipher(str, {encdec = 0, cipher = "EVP_aes_192_cbc", key_length = 24, iv_length = 24}, _key, _iv)
end
local function encryptAES256 (str, _key, _iv)
  local enc, key, iv = cipher(str, {encdec = 1, cipher = "EVP_aes_256_cbc", key_length = 32, iv_length = 32}, _key, _iv)
  return enc, key, iv
end
local function decryptAES256 (str, _key, _iv)
  return cipher(str, {encdec = 0, cipher = "EVP_aes_256_cbc", key_length = 32, iv_length = 32}, _key, _iv)
end

local function encrypt (_cipher, str, _key, _iv)
  if _cipher == "AES128" then
    local enc, key, iv = encryptAES128(str, _key, _iv)
    return enc, key, iv
  elseif _cipher == "AES192" then
    local enc, key, iv = encryptAES192(str, _key, _iv)
    return enc, key, iv
  elseif _cipher == "AES256" then
    local enc, key, iv = encryptAES256(str, _key, _iv)
    return enc, key, iv
  end
end
local function decrypt (_cipher, str, _key, _iv)
  if _cipher == "AES128" then
    return decryptAES128(str, _key, _iv)
  elseif _cipher == "AES192" then
    return decryptAES192(str, _key, _iv)
  elseif _cipher == "AES256" then
    return decryptAES256(str, _key, _iv)
  end
end


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

local function dump (t, msg)
  if type(t) ~= "table" then 
    if msg then print(msg .. tostring(t)) else return tostring(t) end
    return
  end
  local traverse
  traverse = function (t, level)
    if level > 10 then return end -- prevent stak overflow
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
  local res = table.concat({"{", traverse(t, 1), "}"}, "\n")
  if msg then print(msg .. res) else return res end
end


return {
  -- hex / _hex
  encodeHex = encodeHex,
  decodeHex = decodeHex,
  encode_hex = encodeHex,
  decode_hex = decodeHex,

  -- b64 / _b64
  encodeBase64 = encodeBase64,
  decodeBase64 = decodeBase64,
  encode_base64 = encodeBase64,
  decode_base64 = decodeBase64,

  xor = xor,

  md5 = md5,
  sha1 = sha1,
  sha224 = sha224,
  sha256 = sha256,
  sha384 = sha384,
  sha512 = sha512,
  hmac_sha1 = hmac_sha1,
  hmac_sha256 = hmac_sha256,
  pbkdf2_sha1 = pbkdf2_sha1,
  pbkdf2_sha256 = pbkdf2_sha256,
  passwordKey = passwordKey,

  randomNumber = randomNumber,
  randomString = randomString,
  random_number = randomNumber,
  random_string = randomString,
  uuid = uuid,
  
  hash_pem_file = hash_pem_file,
  hash_pem = hash_pem,
  get_peer_pem = get_peer_pem,
  get_peer_signature_name = get_peer_signature_name,
  parse_hash = parse_hash,
  
  encryptAES128 = encryptAES128,
  decryptAES128 = decryptAES128,
  encryptAES192 = encryptAES192,
  decryptAES192 = decryptAES192,
  encryptAES256 = encryptAES256,
  decryptAES256 = decryptAES256,
  encrypt = encrypt,
  decrypt = decrypt,

  flat = flat,
  dumpstr = dumpstr,
  dump = dump,
}