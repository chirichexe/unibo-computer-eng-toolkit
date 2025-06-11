## Speciali

| | | | | |
|---|---|---| --- | --- | 
| **comando** | **descrizione**  | **opzioni utili** |
| </> | ridirezione di stdout su file troncandolo||
| <</>> | ridirezione di stdout su file in append | |
| exec | ridirezione definitiva |  |
| >/< ( comando ) | process substitution: simula l'input/output di un file in una pipe  |
| &|mette il programma in background|
| (comando;comando) | esegue sequenze di comandi bash ||
| $( comando ) | command substitution, viene sostituito e considera il suo output come parametro||
| ${!A[@]} |set di indici validi||
| ${#A[*]} |numero di celle assegnate||
| $! | pid del processo mandato in background ||
|${NOMEVARIABILE}| identico a $NOMEVARIABILE, ma resistente a variabili composte o ambigue ||
| $? | exit code ||
||||


## Variabili notevoli

||||
|:--|:---|:---|
|BASHPID|pid corrente||
| $ |pid shell capostipite||
| PPID |PID del parent process della shell “capostipite”||
|HOSTNAME|nome dell'host||
|RANDOM |numero casuale||
|UID|id utente||
|IFS|separatore di sistema|a default space+tab+newline|
|HOME|home directory utente||
|tty|restituisce il terminale connesso in stdinput||
||||
||||


## Filtri

| **comando** | **descrizione**  | **opzioni** |**descr. opz** | |
|---|---|---| --- | --- |
| cat | scrive il contenuto di uno o più file |  |
| tac | inverso di cat, scrive il contenuto all'inverso (per righe)| |
| less | intercetta l'output e lo mostra sul terminale | < N >g |con g riga da mostrare
| rev | inverte l'ordine dei caratteri per riga  | |
| head | estrae la parte iniziale dell'input | -c NUM <br> -n NUM| -primi NUM caratteri, -NUM tutto tranne ultime NUM char,  <br> -come prima ma con le righe 
| tail |estrae la parte finale di un file | -c NUM <br>-n NUM<br> -f| +NUM tutto il file da NUM in poi<br> <br>si mantiene aperto il file | |
| cut | taglia parti di riga | -c8-30 <br>-f<br> -d <br>-s |-restituisce char da 8 a 30<br><br>-f sceglie il campo, d il delimitatore<br> -elimina le righe senza delim.| | |
|sort | ordina le linee|-r<br> -m<br>-q <br>-n|reverse<br> merge<br>elimina i duplicati<br>ordina per numero(e non per alfabeto)| |
| uniq| elimina i duplicati consecutivi |-c <br>-d  |-indica il numero di righe compattate<br> -mostra le entry non singole| |
| wc| conta l'input |-c<br>-l<br>-w |-char<br>-linee<br>-parole | |
| grep | restituisce le linee con un pattern | | | |
| egrep | come grep ma con REGEX specifiche| | | |

## Comandi

| **comando** | **descrizione**  | **opzioni** |**descr. opz** | |
|---|---|---| --- | --- |
|echo | stampa l'input| | | | 
| sed | sostituzione | | | |
| tr |sostituzione singoli caratteri | | | |
|awk | evoluzione di cut | | awk -F "-" '{print $3}'| |
|xargs|passa quello che arriva in input come parametri ad un comando|||
|tee|oltre a mantenere l'output, lo duplica copiandolo in un file,  ||tee >(grep foo &#124; wc > foo.count) &#124; |
|diff|mostra la differenza tra files|||
|shuf|permutazioni randomiche delle righe in input |||
|paste|unisce "orizzontalmente" files|||
|join|unisce files controllando se coincidono con la chiave|||
|touch|Imposta la data e ora di ultima modifica e di ultimo accesso del file prova.txt alla data e ora correnti, creando il file se esso non esiste|||
|export|setta una variabile d'ambiente|||
|showmount |mostra le partizioni montate |-e|elenca gli exports |
|set|visualizza le variabili d'ambiente|||
|env|controllo variabili di ambiente|||
|shift|trasla di uno l'ordine delle variabili |||
| nc | netcat, scrive tra due macchine|||
| tcpdump | controlla il traffico|||
| ss |elenco porte aperte|||
|mount | innesta le gerarchie della directory | -t nfs|mount 'partizione' 'mount point' |
|df |spazio su disco|||
|du |spazio dei file|||
|fuser | quali processi stanno usando un file|||
|losf |list of open files|||
|||||


## Builtin
| **comando** | **descrizione**  | **opzioni** |**descr. opz** | |
|---|---|---| --- | --- |
|read |inserisce l'input nelle variabili passate per argomento, di default legge una riga alla volta|||
|bc |operazioni in shell|||
|declare |specifica alla shell come considerare(intero, stringa...) le variabili |||
| (( )) | valuta l'espressione|||
|let |valuta l'espressione||
|test|restituisce vero(0) o falso dell'espressione  equivalente a [[ ]] |||
|if then fi ||if (test $num -gt 5); then echo "yes"; else echo "no"; fi||
|case "" in *) ;; esac | come switch in c|||
|for in do done ||||
|while/until do done ||||
|break |esce dal ciclo|||
|continue |salta alla sucessiva iterazione|||
|trap |collega un handler ad un segnale in arrivo|||
|kill |manda un segnale|||
|sleep |manda in pausa il processo|||
|wait |aspetta che finiscano i job in bg|||
|fg |riporta un processo in foreground|||
|bg |porta un processo in background|||
|jobs|elenca il processi avviati dalla shell corrente ||
|nohup |evita l'invio del segnale SIGHUP (per terminare i programmi in background) |||
|nice | modifica la priorita|||
|disown | rimuove un job dalla job table della shell|||
|source |esegue ed include tutto di un altro script|||
|eval |considera un file come uno script|||
|select |||
| getops | per gestire le opzioni |OPTIND OPTARG||
|su/sudo|esegue il processo come superuser|||
|time | restituisce la durata di un processo|||
|date | restituisce la data attuale|||
|mktemp | crea un file temporaneo|||
|basename |rimuove il path e il suffisso di un file|||
|dirname |restituisce la directory in input meno l'ultimo passaggio|||
|printf |stampa in modo più elegante di echo|||
|script |crea una copia di cio che accade sul terminale|||
|watch | esegue un comando periodicamente|||
|seq |crea una sequenza nei parametri passati sucessivamente|||
|lsof |elenca i file(in generale) aperti|||
|id |elenca i gruppi di cui un utente fa parte||
|uptime | visualizza il carico ||
|free |mostra situazione delle partizioni/memoria||
|ps |elenca i processi in esecuzione|||
|top | riassume ps uptime e free||
|vmstat | uso di memoria||
|iostat|||
|mdadm | crea un sistema raid|mdadm -C /dev/md1 -l 5 -n 3 /dev/sdb /dev/sdc /dev/sdd | raid livello 5 3 dischi |
|fdisk | crea una partizione | fdisk nomePartizione||
|mkfs | inserisce il filesystem | mkfs.ext4 nomePartizione||
|||||


## Utenti e files

| **comando** | **descrizione**  | **opzioni** |**descr. opz** | |
|---|---|---| --- | --- |
| useradd | aggiunge un utente |-m<br>-s /bin/bash |aggiunge la home <br> seleziona la shell||
|chpasswd| cambia la password ||echo username:password \| chpasswd ||
| id |mostra le informazioni dell'utente |||
| usermod | modifica le caratteristiche dell'utente |||
| adduser | aggiunge un utente|||
| groupadd ||||
| addgroup ||||
| gpasswd |modifica gruppo|||
| getent | interroga il db utenti o gruppi |||
| last | elenca i login |||
| lastlog | data dell'ultimo login di ogni utente |||
| faillog | login falliti |||
| newgrp | change current group ID |||
| chown | modifica owner e/o group owner del file|||
| chgrp | modifica group owner del file |||
| chmod | modifica i permessi |||
| stat | visualizza metadati file |||
| file | cerca di capire la natura dei files |||
| cp | copia file in una directory|||
| rm | elimina un link a un file |||
| mv | sposta un file |||
| ln | crea link a file |||
| mkdir | crea directory |||
| rmdir| elimina directory |||
| dd | sposta dati byte per byte |||
| find | cerca all'interno del FS |||
| locate | ricerca su DB indicizzato |||
| tar | trasferimento dati |||
| gzip - bzip2 - xz | compressione dati |||
| ||||
||||| 
|||||


## Utili 

||||
|---|---|---|
| dpkg-reconfigure | modificare le impostazioni di un package installato |
| pwd | directory corrente||
| cd | cambia direcory||
| ls | visualizza contenuto directory||
| ip a del 10.1.1.1/24 dev eth1 |||
| ip link set dev eth1 down |||
||||
||||


ssh-keygen -t rsa <br>
ssh-copy-id 192.168.56.
 <br> <br> <br> 
## ldap

dn: ou=People,dc=labammsis
objectclass: organizationalunit
ou: People
description: system's users

dn: ou=Groups,dc=labammsis
objectclass: organizationalunit
ou: Groups
description: system's groups

dn: uid=dave,uo=People,dc=labammsis
objectClass: top
objectClass: posixAccount
objectClass: shadowAccount
objectClass: inetOrgPerson
givenName: Davide Berardi
cn: Davide
sn: Berardi
mail: davide.berardi@unibo.it
uid: dave
uidNumber: 10000
gidNumber: 10000
homeDirectory: /home/dave
loginShell: /bin/bash
gecos: Davide Berardi
userPassword: {crypt}x

dn: cn=dave,ou=Groups,dc=labammsis
objectClass: top
objectClass: posixGroup
gidNumber: 10000


 <br> <br> <br> <br>


systemctl start slapd

ldapsearch -x -LLL -D cn=admin,dc=labammsis -b dc=labammsis -w gennaio.marzo -H ldap:///

ldapadd -H ldapi:/// -D cn=admin,dc=labammsis -x -w gennaio.marzo -f people.ldif

ldapadd -H ldapi:/// -D cn=admin,dc=labammsis -x -w gennaio.marzo -f groups.ldif

apt install libpam-ldap libnss-ldap

 <br> <br> <br>

[Unit] <br>
Description= Descrizione  <br>
Requires/Wants= da chi dipende questa unit  <br>
Documentation= es. man:rsyslogd(8) o URL o altro  <br>
[Service]  <br>
Type= (simple, forking, oneshot, notify, dbus, idle) <br>
RemainAfterExit=  <br>
ExecStart= comando da lanciare all’avvio  <br>
ExecStop= comandi (opzionali) per stop  <br>
ExecReload= comandi (opzionali) per reload <br>
Restart= reazione (opzionale) alla terminazione (on-failure) <br>
[Install] <br>
WantedBy= chi dipende da questa unit (basic.target) <br>
Alias= nome con cui è nota a systemd <br>
 <br> <br> <br>


Facility = argomento <br>
• auth, authpriv, cron, daemon, ftp, kern, lpr, mail,
news, syslog, user, uucp, local0..local7 <br>
– Priority = importanza in ordine decrescente:
• emerg, alert, crit, err, warning, notice, info, debug
