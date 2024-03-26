-- Copyright (C) 2024, StrumaSoft
--
-- Requires: 
--   LuaJIT FFI
--   OpenSSL


local ffi = require "ffi"
local bit = require "bit"
local bor = bit.bor

local EXIT_SUCCESS = 0
local EXIT_FAILURE = 1
local EVP_PKEY_RSA = 6
local MBSTRING_FLAG = 0x1000
local MBSTRING_UTF8 = MBSTRING_FLAG
local MBSTRING_ASC = bor(MBSTRING_FLAG, 1)
local MBSTRING_BMP = bor(MBSTRING_FLAG, 2)
local MBSTRING_UNIV = bor(MBSTRING_FLAG, 4)
  

ffi.cdef[[
  typedef struct rsa_st RSA;
  typedef struct evp_pkey_st EVP_PKEY;
  typedef struct x509_st X509;
  typedef struct x509_name_st X509_NAME;
  typedef struct evp_pkey_ctx_st EVP_PKEY_CTX;
  typedef struct file FILE;
  typedef struct asn1_integer_st ASN1_INTEGER;
  typedef struct asn1_string_st ASN1_TIME;
  typedef struct env_md_st EVP_MD;
  
  const EVP_PKEY *EVP_PKEY_new(void);
  EVP_PKEY_CTX *EVP_PKEY_CTX_new_id(int, void *);
  int EVP_PKEY_keygen_init(EVP_PKEY_CTX *);
  int EVP_PKEY_CTX_set_rsa_keygen_bits(EVP_PKEY_CTX *, int);
  int EVP_PKEY_keygen(EVP_PKEY_CTX *, EVP_PKEY **);
  void EVP_PKEY_CTX_free(EVP_PKEY_CTX *);
  void EVP_PKEY_free(EVP_PKEY *);
  
  X509 *X509_new(void);
  int X509_set_version(X509 *, long);
  int ASN1_INTEGER_set(ASN1_INTEGER *a, long v);
  ASN1_TIME *X509_getm_notBefore(const X509 *x);
  ASN1_TIME *X509_getm_notAfter(const X509 *x);
  ASN1_TIME *X509_gmtime_adj(ASN1_TIME *s, long adj);
  ASN1_INTEGER *X509_get_serialNumber(X509 *x);
  int X509_set_pubkey(X509 *x, EVP_PKEY *pkey);;
  void X509_set_subject_name(X509 *, X509_NAME *);
  void X509_set_issuer_name(X509 *, X509_NAME *);
  int X509_sign(X509 *, const EVP_PKEY *, const void *);
  
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
  
  X509_NAME *X509_NAME_new(void);
  int X509_NAME_add_entry_by_txt(X509_NAME *, const char *, int, const unsigned char *, int, int, unsigned long);
  void X509_free(X509 *);
  void PEM_write_PrivateKey(FILE *, const EVP_PKEY *, const void *, const void *, int, const void *, const void *);
  void PEM_write_X509(FILE *, const X509 *);
  FILE *fopen(const char *, const char *);
  int fclose(FILE *);
  void perror(const char *);
  
  //
  // Signature Algorithm
  //
  typedef struct x509_st X509;
  typedef struct asn1_object_st ASN1_OBJECT;
  typedef struct x509_algor_st X509_ALGOR;

  X509 *PEM_read_X509(FILE *fp, X509 **x, void *cb, void *u);
  X509_ALGOR *X509_get0_tbs_sigalg(const X509 *x);
  int X509_ALGOR_get0(const ASN1_OBJECT **paobj, int *pptype,
                      const void **pval, const X509_ALGOR *algor);
  int OBJ_obj2txt(char *buf, int buflen, const ASN1_OBJECT *aobj, int no_name);
  void X509_free(X509 *x);
  FILE *fopen(const char *path, const char *mode);
  int fclose(FILE *stream);
  int fprintf(void *stream, const char *format, ...);
  const char *strerror(int errnum);
  int errno;
  void *stderr;
  
  //
  // Signature Value
  //
  typedef struct x509_st X509;
  typedef struct asn1_string_st ASN1_BIT_STRING;
  typedef struct asn1_string_st ASN1_STRING;

  X509* PEM_read_X509(FILE* fp, X509** x509, void* cb, void* u);
  void X509_free(X509* a);
  void X509_get0_signature(const ASN1_BIT_STRING** psig, const X509_ALGOR** palg, const X509* x);
  const unsigned char *ASN1_STRING_get0_data(const ASN1_STRING *x);
  int ASN1_STRING_length(const ASN1_STRING *x);

  typedef struct FILE FILE;
  FILE* fopen(const char* path, const char* mode);
  int fclose(FILE* stream);
  const char* strerror(int errnum);
  void perror(const char* s);
  
  
  //
  // Signature Name
  //
  int X509_get_signature_nid(const X509 *x);
  const char *OBJ_nid2sn(int n);
]]

-- Load OpenSSL library
local C = ffi.load("ssl")


--[[
Function to generate a self-signed certificate

EVP_PKEY_new() returns a constant pointer (const struct evp_pkey_st*), 
and LuaJIT FFI does not allow direct assignment of constant pointers 
to non-constant pointers. To resolve this, you need to explicitly cast the result 
of EVP_PKEY_new() to a non-constant pointer before passing it to ffi.new.
]]
local function generate_certificate (cert_file, key_file, key_bits, hash)
  -- Create RSA key
  local ppkey = ffi.new("EVP_PKEY*[1]", ffi.cast("EVP_PKEY*", C.EVP_PKEY_new()))
  local pkey = ppkey[0]
  local ctx = C.EVP_PKEY_CTX_new_id(EVP_PKEY_RSA, nil)

  if ctx == nil or C.EVP_PKEY_keygen_init(ctx) <= 0 or
    C.EVP_PKEY_CTX_set_rsa_keygen_bits(ctx, key_bits) <= 0 or
    C.EVP_PKEY_keygen(ctx, ppkey) <= 0 then
    --io.stderr:write("Error generating RSA key\n")
    C.EVP_PKEY_free(pkey)
    return nil, "Error generating RSA key"
  end

  C.EVP_PKEY_CTX_free(ctx)

  -- Create X509 certificate
  local x509 = C.X509_new()
  if x509 == nil then
    --io.stderr:write("Error creating X509 certificate\n")
    C.EVP_PKEY_free(pkey)
    return nil, "Error creating X509 certificate"
  end

  -- Set version of the certificate
  C.X509_set_version(x509, 2) -- Version 3

  -- Set the serial number (in a real-world scenario, this should be unique for each certificate)
  C.ASN1_INTEGER_set(C.X509_get_serialNumber(x509), 1)

  -- Set validity period for 365 days
  C.X509_gmtime_adj(C.X509_getm_notBefore(x509), 0)
  C.X509_gmtime_adj(C.X509_getm_notAfter(x509), 60 * 60 * 24 * 365)

  -- Set the subject and issuer information
  local name = C.X509_NAME_new()
  C.X509_NAME_add_entry_by_txt(name, "CN", MBSTRING_ASC, "localhost", -1, -1, 0)
  C.X509_set_subject_name(x509, name)
  C.X509_set_issuer_name(x509, name)

  -- Set the public key
  if C.X509_set_pubkey(x509, pkey) ~= 1 then
    --io.stderr:write("Error setting public key\n")
    C.X509_free(x509)
    C.EVP_PKEY_free(pkey)
    return nil, "Error setting public key"
  end

  -- Sign the certificate with the private key
  if C.X509_sign(x509, pkey, C["EVP_" .. hash]()) <= 0 then
    --io.stderr:write("Error signing the certificate\n")
    C.X509_free(x509)
    C.EVP_PKEY_free(pkey)
    return nil, "Error signing the certificate with " .. hash
  end

  -- Save the private key to a file
  local key_file_ptr = C.fopen(key_file, "w")
  if key_file_ptr == nil then
    --C.perror("Error opening private key file")
    C.X509_free(x509)
    C.EVP_PKEY_free(pkey)
    return nil, "Error opening private key file"
  end
  C.PEM_write_PrivateKey(key_file_ptr, pkey, nil, nil, 0, nil, nil)
  C.fclose(key_file_ptr)

  -- Save the certificate to a file
  local cert_file_ptr = C.fopen(cert_file, "w")
  if cert_file_ptr == nil then
    --C.perror("Error opening certificate file")
    C.X509_free(x509)
    C.EVP_PKEY_free(pkey)
    return nil, "Error opening certificate file"
  end
  C.PEM_write_X509(cert_file_ptr, x509)
  C.fclose(cert_file_ptr)

  -- Clean up
  C.X509_free(x509)
  C.EVP_PKEY_free(pkey)
  
  return true
end

local function signature_algorithm (cert_file_name)
  local cert_file = ffi.C.fopen(cert_file_name, "r")
  if cert_file == nil then
    --ffi.C.perror("Error opening certificate file")
    --ffi.C.fprintf(ffi.C.stderr, "Error opening certificate file: %s\n", ffi.C.strerror(ffi.C.errno))
    return nil, "Error opening certificate file"
  end

  local cert = C.PEM_read_X509(cert_file, nil, nil, nil)
  ffi.C.fclose(cert_file)

  if cert == nil then
    --io.stderr:write("Error reading certificate\n")
    return nil, "Error reading certificate"
  end

  local algorithm, err
  local sig_alg = C.X509_get0_tbs_sigalg(cert)
  if sig_alg ~= nil then
    local obj = ffi.new("const ASN1_OBJECT*[1]")
    --local pptype = ffi.new("int[1]")
    --local pval = ffi.new("const void*[1]")
    --C.X509_ALGOR_get0(obj, pptype, pval, sig_alg)
    C.X509_ALGOR_get0(obj, nil, nil, sig_alg)
    if obj[0] ~= nil then
      local buffer = ffi.new("char[256]")
      C.OBJ_obj2txt(buffer, 256, obj[0], 0)
      algorithm = ffi.string(buffer)
    else
      err = "Error getting certificate algorithm"
    end
  end

  C.X509_free(cert)
  
  return algorithm, err
end

local function signature_value (cert_file)
  local cert_file_ptr = ffi.C.fopen(cert_file, "r")
  if cert_file_ptr == nil then
    --ffi.C.perror("Error opening certificate file")
    return nil, "Error opening certificate file"
  end

  local cert = C.X509_new()
  cert = C.PEM_read_X509(cert_file_ptr, nil, nil, nil)
  ffi.C.fclose(cert_file_ptr)

  if cert == nil then
    --io.stderr:write("Error reading certificate\n")
    return nil, "Error reading certificate"
  end

  local signature = ffi.new("const ASN1_BIT_STRING*[1]")
  C.X509_get0_signature(signature, nil, cert)
  local signature_data = C.ASN1_STRING_get0_data(signature[0])
  local signature_length = C.ASN1_STRING_length(signature[0])

  local text = {}
  text[#text +1] = "    "
  for i = 0, signature_length - 1 do
    text[#text +1] = string.format("%02x:", signature_data[i])
    if (i + 1) % 18 == 0 then
      text[#text +1] = "\n    "
    end
  end

  C.X509_free(cert)
  
  return table.concat(text)
end

local function signature_name (cert_file)
  local cert_file_ptr = ffi.C.fopen(cert_file, "r")
  if cert_file_ptr == nil then
    --ffi.C.perror("Error opening certificate file")
    return nil, "Error opening certificate file"
  end

  local cert = C.X509_new()
  cert = C.PEM_read_X509(cert_file_ptr, nil, nil, nil)
  ffi.C.fclose(cert_file_ptr)

  if cert == nil then
    --io.stderr:write("Error reading certificate\n")
    return nil, "Error reading certificate"
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


return {
  generate_certificate = generate_certificate,
  signature_algorithm = signature_algorithm,
  signature_name = signature_name,
  signature_value = signature_value,
}