#!/bin/bash

# Ensure required arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <public_key.pem> <private_key.pem> <file_to_encrypt>"
    exit 1
fi

# Get input arguments
PUBLIC_KEY="$1"
PRIVATE_KEY="$2"
FILE_TO_ENCRYPT="$3"

# Define output filenames
AES_KEY="aes_key.bin"
AES_KEY_ENCRYPTED="aes_key.enc"
FILE_ENCRYPTED="${FILE_TO_ENCRYPT}.enc"
FILE_DECRYPTED="decrypted_${FILE_TO_ENCRYPT}"

echo "[+] Generating a 256-bit AES key..."
openssl rand -base64 32 > "$AES_KEY"

echo "[+] Encrypting the file using AES-256..."
openssl enc -aes-256-cbc -salt -in "$FILE_TO_ENCRYPT" -out "$FILE_ENCRYPTED" -pass file:"$AES_KEY"

echo "[+] Encrypting the AES key using RSA..."
openssl pkeyutl -encrypt -pubin -inkey "$PUBLIC_KEY" -in "$AES_KEY" -out "$AES_KEY_ENCRYPTED"

# Cleanup AES key for security
rm "$AES_KEY"

echo "[✔] Encryption completed!"
echo "Encrypted file: $FILE_ENCRYPTED"
echo "Encrypted AES key: $AES_KEY_ENCRYPTED"


