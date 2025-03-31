# RSA-AES Hybrid Encryption System

This repository contains a set of bash scripts that implement a hybrid encryption system using RSA and AES encryption algorithms. This approach combines the security of RSA public-key cryptography with the efficiency of AES symmetric encryption.

## Overview

The hybrid encryption system works as follows:

1. **For encryption**:
   - Generate a random AES-256 key
   - Encrypt the target file with the AES key
   - Encrypt the AES key with the recipient's RSA public key
   - Distribute the encrypted file and encrypted AES key

2. **For decryption**:
   - Decrypt the AES key using the recipient's RSA private key
   - Use the decrypted AES key to decrypt the file

This approach allows for secure transmission of data without the need to exchange secret keys through insecure channels.

## Prerequisites

- OpenSSL installed on your system
- Basic understanding of public/private key cryptography concepts

## Scripts

### 1. `rsa_aes_encrypt.sh`

Encrypts a file using a hybrid RSA-AES approach.

```bash
./rsa_aes_encrypt.sh <public_key.pem> <private_key.pem> <file_to_encrypt>
```

**Parameters**:
- `public_key.pem`: RSA public key in PEM format
- `private_key.pem`: RSA private key in PEM format (not used for encryption, appears to be an unused parameter)
- `file_to_encrypt`: The file you want to encrypt

**Output**:
- `<file_to_encrypt>.enc`: The encrypted file
- `aes_key.enc`: The RSA-encrypted AES key

### 2. `rsa_aes_decrypt.sh`

Decrypts a file that was encrypted using the hybrid RSA-AES approach.

```bash
./rsa_aes_decrypt.sh <private_key.pem> <encrypted_aes_key> <file_to_decrypt>
```

**Parameters**:
- `private_key.pem`: RSA private key in PEM format
- `encrypted_aes_key`: The RSA-encrypted AES key (aes_key.enc)
- `file_to_decrypt`: The encrypted file to decrypt

**Output**:
- `decrypted_<original_filename>`: The decrypted file

## Usage Example

### Generate RSA Key Pair (if needed)

```bash
# Generate a 2048-bit private key
openssl genpkey -algorithm RSA -out private_key.pem -pkeyopt rsa_keygen_bits:2048

# Extract the public key
openssl rsa -pubout -in private_key.pem -out public_key.pem
```

### Encrypt a File

```bash
./rsa_aes_encrypt.sh public_key.pem private_key.pem secret_document.pdf
```

This will generate:
- `secret_document.pdf.enc` (encrypted file)
- `aes_key.enc` (encrypted AES key)

### Decrypt a File

```bash
./rsa_aes_decrypt.sh private_key.pem aes_key.enc secret_document.pdf.enc
```

This will generate:
- `decrypted_secret_document.pdf` (the original file)

## Security Notes

- The AES key is generated randomly for each encryption operation
- The AES key file is securely deleted after encryption
- The decrypted AES key is securely deleted after decryption
- Uses AES-256-CBC symmetric encryption
- RSA key strength depends on the key you provide (recommended: 2048 bits or higher)

## Limitations

- The `rsa_aes_encrypt.sh` script requires a private key parameter that isn't used in the encryption process
- There is no integrity verification or authentication mechanism
- Large files might take longer to process

## License

[Add your license information here]