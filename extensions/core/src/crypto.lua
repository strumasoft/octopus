-- Copyright (C) 2024, StrumaSoft
-- Requires LuaJIT's FFI library
-- Requires OpenSSL


local ffi = require "ffi"
ffi.cdef [[
  /******* SHA1 *******/
  
  unsigned char *SHA1(
    const unsigned char *d,
    size_t n,
    unsigned char *md);
  
  
  /******* SHA256 *******/
  
  unsigned char *SHA256(
    const unsigned char *d,
    size_t n,
    unsigned char *md);
  
  
  /******* MD5 *******/
  
  unsigned char *MD5(
    const unsigned char *d,
    size_t n,
    unsigned char *md);
  
  
  /******* RANDOM *******/
    
  typedef unsigned long BN_ULONG;
  struct bignum_st {
    BN_ULONG *d;                /* Pointer to an array of 'BN_BITS2' bit chunks. */
    int top;                    /* Index of last used d +1. */
    /* The next are internal book keeping for bn_expand. */
    int dmax;                   /* Size of the d array. */
    int neg;                    /* one if the number is negative */
    int flags;
  };
  typedef struct bignum_st BIGNUM;
  
  BIGNUM *BN_new(void);
  BIGNUM *BN_secure_new(void);
  void BN_clear(BIGNUM *a);
  void BN_free(BIGNUM *a);
  void BN_clear_free(BIGNUM *a);
  
  int BN_rand(BIGNUM *rnd, int bits, int top, int bottom);
  int BN_pseudo_rand(BIGNUM *rnd, int bits, int top, int bottom);
  int BN_rand_range(BIGNUM *rnd, BIGNUM *range);
  int BN_pseudo_rand_range(BIGNUM *rnd, BIGNUM *range);
  
  
  /******* HMAC *******/
  
  struct evp_md_st;
  typedef struct evp_md_st EVP_MD;
  unsigned char *HMAC(const EVP_MD *evp_md, const void *key,
               int key_len, const unsigned char *d, int n,
               unsigned char *md, unsigned int *md_len);
  const EVP_MD *EVP_sha1(void);
  
  int PKCS5_PBKDF2_HMAC(const char *pass, int passlen,
    const unsigned char *salt, int saltlen, int iter,
    const EVP_MD *digest,
    int keylen, unsigned char *out);
  
  int PKCS5_PBKDF2_HMAC_SHA1(const char *pass, int passlen,
    const unsigned char *salt, int saltlen, int iter,
    int keylen, unsigned char *out);
  
  
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

local libssl = ffi.load("ssl")


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
  data = string.gsub(data, '[^'..b..'=]', '')
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


local function hashString (str, method, length)
  local md = ffi.new("unsigned char[?]", length)
  libssl[method](str, #str, md)
  return ffi.string(md, length)
end


-- https://www.openssl.org/docs/manmaster/man3/SHA1.html
local function sha1 (str)
  --return encodeHex(hashString(str, "SHA1", 20))
  return hashString(str, "SHA1", 20)
end


-- https://www.openssl.org/docs/manmaster/man3/SHA256.html
local function sha256 (str)
  --return encodeHex(hashString(str, "SHA256", 32))
  return hashString(str, "SHA256", 32)
end


-- https://www.openssl.org/docs/manmaster/man3/MD5.html
local function md5 (str)
  --return encodeHex(hashString(str, "MD5", 16))
  return hashString(str, "MD5", 16)
end


-- https://www.openssl.org/docs/manmaster/man3/BN_rand.html
-- https://www.openssl.org/docs/manmaster/man3/BN_new.html
local function randomNumber (bits)
  local bn = libssl.BN_new()
  if libssl.BN_rand(bn, bits, 0, 0) then
    local num = tonumber(bn.d[0])
    libssl.BN_clear_free(bn)
    return num
  else
    libssl.BN_clear_free(bn)
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
  local bn = libssl.BN_new()
  for i=1,length do
    if libssl.BN_rand(bn, 20, 0, 0) then
      local num = tonumber(bn.d[0])
      local index = num % 64
      if index == 0 then index = 64 end
      table.insert(hash, symbol[index])
    else
      libssl.BN_clear_free(bn)
      error("can not create random number")
    end
  end
  libssl.BN_clear_free(bn)
  return table.concat(hash)
end


-- https://www.openssl.org/docs/manmaster/man3/HMAC.html
local function hmac (str, _key)
  local key = _key or randomString(20)
  local md = ffi.new("unsigned char[?]", 64)
  local outlen = ffi.new("int[1]", 0)
  libssl.HMAC(libssl.EVP_sha1(), key, #key, str, #str, md, outlen)
  return encodeHex(ffi.string(md, outlen[0])), key
end


-- https://www.openssl.org/docs/manmaster/man3/PKCS5_PBKDF2_HMAC_SHA1.html
-- http://www.neurotechnics.com/tools/pbkdf2
local function passwordKey (str, _salt, _length)
  local salt = _salt or randomString(20)
  local md_length = _length or 32
  local md = ffi.new("unsigned char[?]", md_length)
  libssl.PKCS5_PBKDF2_HMAC_SHA1(str, #str, salt, #salt, 2000, md_length, md)
  return ffi.string(md, md_length), salt
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

  local ctx = libssl.EVP_CIPHER_CTX_new()
  if not libssl.EVP_CipherInit_ex(ctx, libssl[metadata.cipher](), nil, key, iv, metadata.encdec) then
    libssl.EVP_CIPHER_CTX_free(ctx)
    error("can not init cipher")
  end

  if not libssl.EVP_CipherUpdate(ctx, outbuf, outlen, inbuf, #str) then
    libssl.EVP_CIPHER_CTX_free(ctx)
    error("can not update cipher")
  end
  table.insert(out, ffi.string(outbuf, outlen[0]))
  
  if not libssl.EVP_CipherFinal_ex(ctx, outbuf, outlen) then
    libssl.EVP_CIPHER_CTX_free(ctx)
    error("can not finalize cipher")
  end
  table.insert(out, ffi.string(outbuf, outlen[0]))

  libssl.EVP_CIPHER_CTX_free(ctx)
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


return {
  encodeHex = encodeHex,
  decodeHex = decodeHex,
  encodeBase64 = encodeBase64,
  decodeBase64 = decodeBase64,
  sha1 = sha1,
  sha256 = sha256,
  md5 = md5,
  hmac = hmac,
  passwordKey = passwordKey,
  randomNumber = randomNumber,
  randomString = randomString,
  encryptAES128 = encryptAES128,
  decryptAES128 = decryptAES128,
  encryptAES192 = encryptAES192,
  decryptAES192 = decryptAES192,
  encryptAES256 = encryptAES256,
  decryptAES256 = decryptAES256,
  encrypt = encrypt,
  decrypt = decrypt,
}