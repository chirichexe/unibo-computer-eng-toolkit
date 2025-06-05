#!/bin/bash

HASH=$1
HASHLEN=${#HASH}

# 1. Indovina algoritmo
if [[ $HASHLEN -eq 32 ]]; then
    ALG="MD5"
    FORMAT="raw-md5"
elif [[ $HASHLEN -eq 40 ]]; then
    ALG="SHA1"
    FORMAT="raw-sha1"
elif [[ $HASHLEN -eq 64 ]]; then
    ALG="SHA256"
    FORMAT="raw-sha256"
elif [[ $HASHLEN -eq 128 ]]; then
    ALG="SHA512"
    FORMAT="raw-sha512"
else
    echo "Algoritmo sconosciuto (lunghezza hash: $HASHLEN)"
    exit 1
fi

echo "- Hash: $HASH"
echo "- Algoritmo presunto: $ALG"
echo "- Formato John: $FORMAT"

# 2. Crea file per John
HASHFILE="hashes.txt"
echo "$HASH" > $HASHFILE

# 3. Avvia John
echo "Avvio John the Ripper..."
john --format=$FORMAT $HASHFILE

# 4. Mostra risultato
echo "Risultato:"
john --show --format=$FORMAT $HASHFILE
