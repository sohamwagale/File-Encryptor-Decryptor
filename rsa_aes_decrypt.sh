#!/bin/bash

# Ensure required arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <private_key.pem> <encrypted_aes_key> <file_to_decrypt>"
    exit 1
fi

# Get input arguments
PRIVATE_KEY="$1"
AES_KEY_ENCRYPTED="$2"
FILE_TO_DECRYPT="$3"

# Define output filenames
AES_KEY_DECRYPTED="aes_key_decrypted.bin"
FILE_DECRYPTED="decrypted_${FILE_TO_DECRYPT%.enc}"

echo "[+] Decrypting the AES key using RSA..."
openssl pkeyutl -decrypt -inkey "$PRIVATE_KEY" -in "$AES_KEY_ENCRYPTED" -out "$AES_KEY_DECRYPTED"

echo "[+] Decrypting the file using AES-256..."
openssl enc -d -aes-256-cbc -in "$FILE_TO_DECRYPT" -out "$FILE_DECRYPTED" -pass file:"$AES_KEY_DECRYPTED"

# Cleanup decrypted AES key
rm "$AES_KEY_DECRYPTED"

echo "[✔] Decryption completed!"
echo "Decrypted file: $FILE_DECRYPTED"


