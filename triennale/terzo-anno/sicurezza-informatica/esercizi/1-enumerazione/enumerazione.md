# Google Dorks
```
"inurl:."domain"/"dorks" "
``` 

## Esempi concreti
- Cerchiamo dei file pdf sul sito ulisse contenente la
parola “password”

```
site:ulisse.unibo.it filetype:PDF intext:password
```


# DNS Enumeration con ```nslookup```
Consiste nell'individuare tutti i **server dns** e i **record** per un certo target

Esempio: ```nslookup -type=any google.com```

# Subdomain enumeration con ```nmap```
```
nmap -sn <ip/subnet> # 
nmap -A <ip> # Ottiene tutti i servizi attivi per le porte di un certo ip
nmap -sC -sV -oA output_porte.txt $IP

```

# Ricerca dei percorsi di accesso con ```greenbone```
```
sudo gvm-start # per l'avvio, credenziali in ~kali/gvm.pass

```

# Attacco bruteforce ssh con hydra
```
hydra -l guest -P /usr/share/wordlists/rockyou.txt -u -s 23 192.168.56.101 ssh
```
