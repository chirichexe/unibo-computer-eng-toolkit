# Hash e GPG

Gli hash esistono anche per proteggere le password

man -a crypt

# Esercizio

Creo utente lista e ci metto una password di rockyou.txt
Creo l'utente easy che ha una password corta ma non presente in rockyou.txt

```sh
adduser lista

zcat /usr/share/wordlists/rockyou.txt.gz | head -200 | tail -1
september

adduser easy

# password eksq
```     

Creiamo in file password che mostra in chiaro l'hash delle password, da non vedere in /etc/shadow

```sh
unshadow /etc/passwd /etc/shadow > password
Created directory: /root/.john
```

Eseguo il comando john per trovare la password di kali

```sh
john -format:crypt -single password
# trova password, ad es. trova "kali"

#john -show password
```

Eseguo il comando john per trovare la password da wordlist

```sh
#1. unzippo rockyou
gunzip /usr/share/wordlists/rockyou.txt.gz

#2. uso john
john -format:crypt -wordlist:/usr/share/wordlists/rockyou.txt password

# Trova la password
# september        (lista)     

```

Configuro /etc/john/john.conf per craccare la password breve non presente in wordlist

```
[Incremental:Lower]
File = $JOHN/lower.chr
MinLen = 3
MaxLen = 4    
CharCount = 26
```

ed eseguo

```sh
john -format:crypt -incremental:Lower password

#premi "l" durante l'esecuzione
```

# GPG

Software per, ad esempio, generare una coppia di chiavi

```sh
gpg --full-generate-key
```
Selezionare identità
Grandezza chiave ( >= 2048)
Data di Scadenza! (importante)
Passphrase

Chiave pubblica esportabile con:

```sh
gpg --output public.pgp --armor --export identita@email
```

Scelgo l'algoritmo RSA and RSA,

Devo poi inserire una chiave simmetrica con cui verrà cifrata la mia chiave privata 

Ha creato:
la chiave di nome rsa...
fingerprint...


```
pub   rsa3072 2025-05-21 [SC]
      0ED28C7BC481B2D78477D14C1CD1D0E18DC1590A
uid                      Davide Chirichella (Chiave di prova per il corso) <davide.chirichella@studio.unibo.it>
sub   rsa3072 2025-05-21 [E]

```

Posso utilizzare ora questa chiave per cifrare dei dati

```sh
# specifico receiver e file da criptare
gpg -r davide.chirichella@studio.unibo.it -e gvm.pass 

# con la flag --armor viene codificato in un file [nome].gpg

# per decriptare
gpg -d gvm.pass.gpg 

# con la flag
# gpg --armor -r davide.chirichella@studio.unibo.it --sign -e gvm.pass
# mi viene chiesta la passphrase
```

Processo tipico:

```sh
# 1. genero la chiave
gpg --full-generate-key

# 2. firma
gpg --sign messaggio.txt
# crea messaggio.txt.gpg firmato

# 3. cifratura (solo il destinatario potrà leggerlo con la sua chiave privata)
gpg --encrypt -r destinatario@email.com messaggio.txt

# PER ACCORPARE autenticità e confidenzialità (2. e 3.)
gpg --sign --encrypt -r destinatario@email.com messaggio.txt

```

# OPENSSL
Libreria C che implementa operazioni crittografiche


