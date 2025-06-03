# Configurazione

**Agent**: installato sul sistema da monitorare (es. un server Linux). Espone dati 
(via MIB – Management Information Base).

Da fare: 

1. ```apt update && apt install snmpd```

```sh
snmpget #recupero di un singolo oggetto
snmpset #impostazione del valore di un oggetto
snmpwalk #utilizza ricorsivamente la PDU getNext per navigare un intero sottoalbero del MIB

# parametri comuni:
# -v versione
# -c community
# indirizzo del network element
# OID del managed object
```

**Manager**: si connette agli agent per leggere/scrivere dati SNMP (di solito un'app di 
monitoraggio, o script).

Da fare:

1. aggiungere le parole contrib non-free al termine di ogni riga che inizia con deb nel 
file  ```/etc/apt/sources.list```

3. Eseguire ```apt update && apt install snmp snmp-mibs-downloader```

2. Commentare la riga mibs : ```sudo sed -i 's/mibs :/# mibs :/g' /etc/snmp/snmp.conf```



## Comandi utili
Lato **manager**:
```sh
export IP_SERVER=10.2.2.1

# vedo il valore della stringa sysContact
snmpget -v 1 -c public $IP_SERVER .1.3.6.1.2.1.1.4.0

# snmpwalk utilizza ricorsivamente la PDU getNext per navigare un intero sottoalbero del MIB
snmpwalk -On -v 1 -c public $IP_SERVER .1.3.6.1.2.1.1

# imposto il valore di una stringa
snmpget -v 1 -c public $IP_SERVER .1.3.6.1.2.1.1.6.0 # Nessun output
snmpset -v 1 -c supercom $IP_SERVER   .1.3.6.1.2.1.1.6.0   s   "proprio qui"
snmpget -v 1 -c public $IP_SERVER .1.3.6.1.2.1.1.6.0 # Output: proprio qui

```

# Misura di parametri di sistema

in /etc/snmp/snmpd.conf, si possono attivare direttive di monitoraggio dei parametri base 
del sistema

```load [max-1] [max-5] [max-15]```
tabella .1.3.6.1.4.1.2021.10
tre righe (carico negli ultimi 1-5-15 minuti)
colonne: carico effettivo, flag di superamento delle rispettive soglie

```disk [partizione] [minfree|minfree%]```
tabella .1.3.6.1.4.1.2021.9
una riga per ogni partizione messa sotto controllo da una direttiva disk
colonne: tutti i dettagli della partizione e flag di spazio sotto il minimo

```proc [nomeprocesso] [maxnum [minnum]]```
tabella .1.3.6.1.4.1.2021.2
una riga per ogni processo messo sotto controllo da una direttiva proc
colonne: numero di istanze, flag di superamento delle soglie


Dal manager, per controllare

```
snmpwalk -v2c -c public $IP_SERVER .1.3.6.1.4.1.2021.10

snmpwalk -v2c -c public $IP_SERVER .1.3.6.1.4.1.2021.9

snmpwalk -v2c -c public $IP_SERVER .1.3.6.1.4.1.2021.2
# Se il processo non è attivo: prErrorFlag diventa 1 e prErrMessage avrà un messaggio.
```

# Esecuzione di codice remoto
estensione NET-EXTEND

- tabella NET-SNMP-EXTEND-MIB::
- righe con nome = etichetta della direttiva extend o extend-sh
- diverse colonne, la più comune: nsExtendOutputFull

es ```extend-sh test1 echo HelloWorld```

Questo comando definisce un “oggetto SNMP” che quando interrogato esegue echo HelloWorld e restituisce l’output.

OID corrispondente: NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"test1\"

(notare i doppi apici, indicano all'agent che è un nome da risolvere, non un segmento di OID standard – attenzione all'espansione bash, devono arrivare al comando snmp!)

# Esecuzione codice privilegiato
1. Consentire all'utente Debian-snmp di eseguire comandi con sudo senza password
```sh
sudo -i
echo "Debian-snmp ALL=NOPASSWD:/usr/bin/ss -lntp" >> visudo
```
2. Inserisco un comando root:
extend-sh sshd    /usr/bin/sudo /usr/bin/ss -lntp | egrep '0\.0\.0\.0:22.*sshd'

3. Testo con ```snmpget -v 1 -c public $IP_SERVER NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"sshd\"```

# -------------------------------------------------------------------------------------------

1. Per associare un OID a un comando custom su un agent SNMP, devi usare le funzionalità extend 
o exec nel file di configurazione ```snmpd.conf```

```conf
# /etc/snmp/snmpd.conf

# Comando 1
extend .1.3.6.1.4.1.2021.51 myscript1 /usr/local/bin/script1.sh

# Comando 2
extend .1.3.6.1.4.1.2021.52 myscript2 /usr/local/bin/script2.sh
```

2. Assegnazione permessi a SNMPD per eseguire il comando come root:

```conf
snmp ALL=(ALL) NOPASSWD: /usr/sbin/iptables
```

