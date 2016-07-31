local ffi = require "ffi"
ffi.cdef [[
	/******* SHA1 *******/
	
	unsigned char *SHA1(
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