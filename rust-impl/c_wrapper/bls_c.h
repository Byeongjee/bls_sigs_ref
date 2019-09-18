/* Text to put at the beginning of the generated file. Testing */

/* Warning, this file is autogenerated by cbindgen. Don't modify this manually. */

#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

#define PK_LEN 49

#define POP_LEN 49

#define SIG_LEN 97

#define SK_LEN 33

/**
 * A wrapper of signature
 */
typedef struct bls_sig {
  uint8_t data[SIG_LEN];
} bls_sig;

/**
 * A wrapper of pk
 */
typedef struct bls_pk {
  uint8_t data[PK_LEN];
} bls_pk;

/**
 * A wrapper of sk
 */
typedef struct bls_sk {
  uint8_t data[SK_LEN];
} bls_sk;

/**
 * A wrapper that holds the output of key generation function.
 */
typedef struct bls_keys {
  bls_pk pk;
  bls_sk sk;
} bls_keys;

/**
 * A wrapper of signature
 */
typedef struct bls_pop {
  uint8_t data[POP_LEN];
} bls_pop;

/**
 * This function aggregates the signatures without checking if a signature is valid or not.
 * It panics if ciphersuite fails, or if signatures do not have same compressness
 */
bls_sig c_aggregation(bls_sig *sig_list, size_t sig_num);

/**
 * Input a pointer to the seed, and its length, and a ciphersuie id.
 * The seed needs to be at least
 * 32 bytes long. Output the key pair.
 * Generate a pair of public keys and secret keys.
 */
bls_keys c_keygen(const uint8_t *seed, size_t seed_len, uint8_t ciphersuite);

/**
 * Input a secret key, and a message in the form of a byte string,
 * output a signature.
 */
bls_sig c_sign(bls_sk sk, const uint8_t *msg, size_t msg_len);

/**
 * Input a public key, a message in the form of a byte string,
 * and a signature, outputs true if signature is valid w.r.t. the inputs.
 */
bool c_verify(bls_pk pk, const uint8_t *msg, size_t msglen, bls_sig sig);

/**
 * This function verifies the aggregated signature
 */
bool c_verify_agg(bls_pk *pk_list,
                  size_t pk_num,
                  const uint8_t *msg,
                  size_t msglen,
                  bls_sig agg_sig);

/**
 * This function verifies the public key against the proof of possession
 */
bool c_verify_pop(bls_pk pk, bls_pop pop);
