#!/bin/bash
#Utilites per LAS

###############-VARIABILI E SIMBOLI SPECIALI-############################

$$ #PID dello script bash corrente
$# #Numero di argomenti da riga di comando
$? #Exit value dell’ultimo comando eseguito command.
$ #PID della shell
$! #PID dell’ultimo comando eseguito in background
$0 #Nome script search.
$n #N-esimo argomento posizionale. Il massimo numero è 9
$*, $@ #Tutti gli argomenti passati.
"$*" #Tutti gli argomenti in un unica stringa "$1 $2 ...". I valori sono separati da $IFS.
"$@" #Tutti gli argomenti, separati individualmente ("$1" "$2"...).

###########################-ARRAY-#######################################
# Dichiarare un array con indici
declare -a my_array
# Dichiarare un array associativo
declare -A my_array
# Inserire più valori nell'array tutti in una volta
my_array=(foo bar lol ciao)
# Assegnare un valore alla volta a un array
my_array[0]=foo

# Operazioni con array

# Stampare tutti i valori di un array
echo ${my_array[@]}
# oppure
echo ${my_array[*]}
# Stampo tutti gli elementi dell'array su righe diverse
for i in "${my_array[@]}"; do echo "$i"; done
# Stampo tutti gli elementi dell'array sulla stessa riga, separati da spazi:
for i in "${my_array[*]}"; do echo "$i"; done
# Itero lungo tutti gli elementi di una directory
for file in $(ls); do
  echo "Elaborando il file: $file"
done

# Stampo la posizione in un array posizionale:
my_array=(foo bar baz)
for index in "${!my_array[@]}"; do echo "$index"; done
# Output:
# 0
# 1
# 2

# Stampo le chiavi in un array associativo:
declare -A my_array
my_array=([foo]=bar [baz]=foobar)
for key in "${!my_array[@]}"; do echo "$key"; done
# Output:
# baz
# foo


# Trovare la dimensione di un array
DIM=${#my_array[@]}

# Aggiungo un ulteriore elemento all'array
my_array+=(baz)
# Aggiungo ulteriori elementi all'array (separati da spazi)
my_array+=(baz foobar)

# Per l'array associativo, per aggiungere elementi:
my_array+=([baz]=foobar [foobarbaz]=baz)

# Cancellare un elemento in una posizione specificata
unset my_array[1]
# Cancellare l'intero array
unset my_array
# scorrere tra un elenco numerico
for LAST in {100..120} ; do

${arr[*]}         # Tutti gli elementi dell' array
${!arr[*]}        # Tutti gli indici dell' array
${#arr[0]}        # Lunghezza dell'elemento zero

############################-SSH-########################################

# di default ciò che il programma remoto produce su stdout e stderr viene stampato sulla shell che invoca ssh

# eseguire con ssh un comando remoto
ssh 10.1.1.1 "ip r | egrep '^10\.9\.9\.0\/24 ' | awk '{ print \$3 }'" 
# eseguire con ssh due comandi remoti
ssh 10.1.1.1 "/bin/bash /tmp/regole$$.sh ; rm -f /tmp/regole$$.sh"
# eseguire ssh con ridirezione input e output su client (ssh)
ssh 10.1.1.1 "ls -l" > ~/out  2> ~/err
# copiare un file da server (/results/$1) a client (home/las/results/$1):
ssh 10.9.9.1 "cat /result/$1" | ssh las@10.1.1.1 "cat > 'results/$1'"
# generare una coppia di chiavi rsa
ssh-keygen -t rsa -b 2048 -P ""
# generare una coppia di chiavi rsa specificando il nome del file
ssh-keygen -t rsa -b 2048 -f pippo -N "" -q
# Non legge da stdin (ridiretto su /dev/null)
ssh -n 10.1.1.1 <command>
# creo utenti remoti tramite ssh
for i in {1..59} ; do
	ssh -n 10.9.9.$i "adduser --disabled-password --gecos '' --home /home/$u $u ; mkdir /home/$u/.ssh ; echo $k >> /home/$u/.ssh/authorized_keys ; chown -R $u:$u /home/$u/.ssh ; chmod 700 /home/$u/.ssh ; echo '$i * * * * /home/$u/script.sh' | crontab"
done

#Impostare il sistema affinche' i router possano eseguire ssh verso i client
##### generare sui router coppie di chiavi ssh
##### mettere le chiavi pubbliche dei router su ogni client
##### nel file /root/.ssh/authorized_keys

###################################-MAN-######################################

# (1) User commands
# (2) Chiamate al sistema operativo
# (3) Funzioni di libreria, ed in particolare
# (4) File speciali (/dev/*)
# (5) Formati dei file, dei protocolli, e delle relative strutture C
# (6) Giochi
# (7) Varie: macro, header, filesystem, concetti generali
# (8) Comandi di amministrazione riservati a root
# (n) Comandi predefiniti del linguaggio Tcl/Tk

# cercare nel man un comando in tutte le sezioni
man -a <nome-comando>
# cercare nel man in una sezione specificata
man <sez> <comando>
# carcare tutte le pagine attinenti alla parola chiave specificata
man -k <keyword>

##################################-TEST-######################################
# Comodo con if
# Opzioni comando test 

# true se file esiste ed è una directory
-d file
# true se file esiste
-e file
# true se file esiste ed è un file regolare
-f file
# true se file esiste ed è leggibile
-r file
# true se file esiste ed ha dimensione >0
-s file
# true se file esiste ed è scrivibile
-w file
# true se file esiste ed è eseguibile
-x file
# true se la stringa è vuota
-z string
# true se la stringa è non vuota
-n string

##############################################################################

# svuoto file

# Svuoto un file senza cancellarlo in modo safe

cat /dev/null > /var/log/req.log

############################-COMMANDS-########################################
# Come vedere se un certo comando è un comando esterno (/bin/<nome-comando>), un alias o built-in
type -a <nome-comando>
#copia file da locale a remoto, inserire nomefile e valore X (1 Client, 2 Router, 3 Server) (-r per dir ricorsive)
scp nomefile_locale root@192.168.56.20X:path_to_remote_dir
#copia file da remoto a locale, inserire nomefile e valore X (1 Client, 2 Router, 3 Server) (-r per dir ricorsive)
# NB ESEGUIRE DA LOCALE IL COMANDO
scp root@192.168.56.20X:/path_nomefile_remoto ~/nomedestinazione_locale
#numeri da first a last
seq first | first last | first increment last

#########################-LS-############################
# Elenca i file o il contenuto della directory specificata

# Elenca il contenuto della directory corrente
ls

# Opzioni:

-l                  # Sbbina al nome le informazioni associate al file
-h                  # Mostra la dimensione del file in versione più leggibile
-a                  # Mostra tutto (includendo anche i file che iniziano con .)
-A                  # Come -a ma escludendo .. e .
-R                  # Percorre ricorsivamente la gerarchia
-r                  # Inverte l'ordine dell'elenco
-t                  # Ordina i file in base all'ora di modifica (dal più recente)
-i                  # Indica gli i-number dei file
-F                  # Aggiunge alla fine del filename * agli eseguibili e / ai direttori
-d                  # Mostra le informazioni di un direttorio senza listare contenuto
-X                  # Lista alfabeticamente in base all'estensione
--full-time         # Mostra la data di modifica completa (data, ora, sec, ecc)
--sort=extension    # Ordina in base all'estensione
--sort=size         # Ordina in base alla dimensione del file
--sort=time         # Ordina in base alla data di ultima modifica

###########################################################

# Crea un hardlink
ln /path/to/file /path/to/hardline
# Crea un link simbolico
ln -s /path/to/file /path/to/link
#leggere ininterrottamente da file

#########################-DU-###############################

du /path/directory # stampa la dimensione di ogni nodo dell'albero

# Opzioni principali:

-h                  # Mostra le dimensioni in modo facilmente leggibile
-s                  # Mostra il sommario (totale) della directory
--max-depth         # Massima profondità di esplorazione :wink:
--exclude="*.txt"   # Esclude tutti i file che rispettano il pattern
                    # Non supporta le regular expressions
                    
# Esempi:
du -s ~/Documenti
# Output:
# 4,8G    /home/katchup/Documenti

du -h ~/Documenti
# Output:
# 37M     /home/katchup/Documenti/Fisica2/teoria
# 48M     /home/katchup/Documenti/Fisica2
# 3,3M    /home/katchup/Documenti/Tesi
# 4,8G    /home/katchup/Documenti

# Mostra i 10 file pià voluminosi del direttorio corrente:

du | sort -nr | head -10

######################-FIND-###########################

# permette di trovare file e directory all'interno del sistema

# Trovare tutti i file che finiscono per .txt nella directory specificata
find /percorso/directory -name '*.txt' 
# Trovare tutte le directory .vagrant nella directory specificata
find /percorso/directory -type d -name ".vagrant" # -exec rm -rf {} +
# trova la stringa 'carico'
find . -type f -exec grep -H 'carico' {} \;
# Solo di primo livello
find /percorso/directory -maxdepth 1 -name "mymon.service"  

# Trovare tutti i file con dimensione superiore a 100k
find -size +100k
# Trovare tutti i file dell'utente las
find -user las
# Trovare tutti i file del gruppo las
find -group las
# Trovare tutti i direttori
find -type d
# Trovare tutti i file che possono essere eseguiti dal proprietario e dal gruppo
find -type f -perm -110
# Trovare tutti i file che hanno esattamente il permesso 110
find -type f -perm /110
# Cercare tutti i file il cui nome finisce con .jpg con una regex egrep
find . -regextype posix-egrep -regex '.*\.jpg'

# NOT, AND, OR con FIND
# NOT: Trovare tutti i file che non finiscono per .txt:
find | -name *.txt

# AND: basta mettere più comandi e vengono interpretati come AND
# Esempio: trovare tutti i file con dimensione superiore a 100k e che finiscono in .txt
find -size +100k -name *.txt

# OR: bisogna inserire l'opzione -o prima del secondo comando
# Trovare tutti i file dell'utente las o che finiscono per .txt
find -user las -o -name *.txt

############################################################

# leggere da standard input
read var && echo $var

tail --pid=$$ -f /var/log/reqs | while read var1 var2 ; do  echo $var1; done
#elimina la prima riga da output
tail -n +2		
#grep quiet, no output, exit code 0 se trova match
grep -q <pattern> <file>
#grep case insensitive
grep -i <pattern> <file>
#grep inverse match
grep -v <pattern> <file>
#grep only exact word
grep -w <pattern> <file>
#grep print only matching string
grep -o <pattern> <file>
#grep print number of matching lines
grep -c <pattern> <file>
#restituisce i nomi dei file nei quali la riga cercata e' comparsa
grep -l <pattern> file.a file.b file.c
grep -l <pattern> file.*
#restituisce anche il numero di linea matchata
grep -n <pattern> <file>
#Stampa anche le N righe precedenti al match
grep -B <N> <pattern> <file>
#Stampa anche le N righe precedenti al match
grep -A <N> <pattern> <file>
#Stampa senza bufferizzare
grep --line-buffered <pattern> <file>
# Rimuove tutte le linee vuote, incluse quelle con spazi multipli: 
grep "\S" file.txt
# Elenca tutti i file che contengono "ciao" analizzando
# ricorsivamente il direttorio corrente .
grep -r "ciao" .
# Per restituire solo i nomi dei file senza le righe
# che fanno match , usare l ’ opzione -l
grep -r -l "ciao" .
# Controllo se la variabile A contiene " ciao "
A=ciaone
if echo $A | grep -q " ciao"; then
	echo A contiene ciao
else
	echo A non contiene ciao
fi
# Restituisci il decimo carattere di ogni riga del file
cut -c10 file.txt
# Restituisci i caratteri dal quinto al decimo
cut -c5-10 file.txt
# Restiuisci i caratteri dall'inizio fino al 20 esimo
cut -c-20 file.txt
# Resituisci i caratteri dal quinto in poi
cut -c5- file.txt
# Estraggo il primo campo , separati da una virgola
cut -d, -f1
# Estraggo il primo ed il terzo campo , separati da uno spazio
cut -d' ' -f1,3
#stampare un solo campo (es. user) di un solo processo
ps -C connect.sh -o user
#selezionare con ps processo con pid specifico (piu' d'uno separati da virgola)
ps -p 583
#stampare solo l'utente ed il programma in esecuzione
#per altro output: man ps, sezione STANDARD FORMAT SPECIFIERS
ps -hao uname,cmd
# Visualizza i processi di las e root, o solo las
ps U "las root"
ps U las
#Visualizza tutti i processi , anche non propri
ps ax
#Mostra gli utenti proprietari del processo
ps u
#Visualizza la riga di comando completa che ha originato il processo
ps w
#Visualizza i rapporti di discendenza tra i processi
ps f

# esempio: mostra l'utente con più processi attivi e li uccide
ps -eo user= | sort | uniq -c | sort -nr | head -n 1
pkill -9 -u `id -u username`



# xargs: considera come parametri dei comandi elencati successivamente a xargs quelli passati in standard input
xargs ps hu # stampa i processi in esecuzione, senza il clasico header di ps, in formato user oriented, ovvero:

# katchup    12504  0.0  0.0   7612  4256 pts/0    Ss+  15:40   0:00 /bin/bash
# katchup    18127  0.0  0.0   7640  4120 pts/1    Ss   19:45   0:00 /bin/bash
# katchup    18136  0.0  0.0   8172  4920 pts/1    S+   19:45   0:00 man iptables
# katchup    18146  0.0  0.0   6636  3200 pts/1    S+   19:45   0:00 less
# katchup    19253  0.0  0.0   7640  4396 pts/2    Ss   20:20   0:00 /bin/bash
# katchup    19567  0.0  0.0   8820  3200 pts/2    R+   20:28   0:00 ps hu

#ordina alfabeticamente
sort <f>
#ordina numericamente
sort -n <f>
#elimina duplicati
sort -u <f>
#inverte ordine
sort -r <f>
#ordina elenco ip address
sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n
# Elimina i duplicati CONTIGUI
uniq
# Indica il numero di occorrenze per ogni duplicato
uniq -c
# Mostra SOLO i duplicati
uniq -d
#-SED
#sed 's/vecchio_pattern/nuovo_valore/' <file>
#inserisce Linea: all'inizio di ogni rigaf
cat /etc/passwd | sed 's/^/Linea:/'
#Sostuisce a dottore Dott. (case insensitive)
cat personale | sed 's/dottore/Dott./i'
#replace tutte le virgole con punto (ogni occorrenza per linea)
sed 's/,/./g' <file>
#cancella le occorrenze	
sed '/regex/d' <file>
#elimina ultima riga da output
sed \$d	<file>		
#awk, separatore di default e' il blank (spazio)
cat log | awk -F ": " '{ print $2 }'
#awk senza buffering
cat log | awk -W interactive '{ print $1 }'
#awk che effettua substring:
# Sottostringa di $LINE da posizione $MIN a posizione $MAX
SUBSTRING=$(awk '{ print substr( $LINE, $MIN, $MAX ) }') 
#xargs
cat /etc/passwd | cut -f1 -d: | xargs mail -s 'l output di cat e cut va in input a mail'

########################- COMANDO SS-################################

# OPZIONI:

# -a: mostra tutti i socket, sia LISTENING che non LISTENING (per TCP non-listening = connessione stabilita)
# -p : mostra processi che utilizzano socket
# -n : non risolve nomi di servizi
# -l : mostra solo socket di ascolto
# -4 : mostra solo socket IPv4
# -t : mostra solo socket TCP
# -u : mostra solo socket UDP
# -e : mostra informazioni dettagliate su socket
# -m : mostra l'utilizzo della memoria di socket

# ss tcp processi e utenti attualmente in uso
ss -tpn
# un classico output di ss -tpn è il seguente:
# State  Recv-Q  Send-Q     Local Address:Port        Peer Address:Port  Process                                      
# ESTAB  0       0            192.168.1.8:37700      151.101.242.2:443    users:(("termius-app",pid=1878,fd=32))      
# ESTAB  0       0           192.168.56.1:51536     192.168.56.201:22     users:(("termius-app",pid=1893,fd=43))      
# ESTAB  0       0            192.168.1.8:58190       52.38.182.23:443    users:(("firefox",pid=5558,fd=89))         

# ss udp proc e utenti attualmente in uso
ss -upn
# visualizzare le porte in ascolto 
ss -lnt

# output di ss -lnt:
# las@Client:~$ ss -lnt
# State       Recv-Q Send-Q   Local Address:Port     Peer Address:Port 
# LISTEN      0      128                  *:52467               *:*     
# LISTEN      0      128                  *:54164               *:*     
# LISTEN      0      128                  *:22                  *:*     
# LISTEN      0      128                  *:46071               *:*     
# LISTEN      0      20           127.0.0.1:25                  *:*     
# LISTEN      0      64                   *:2049                *:*     
# LISTEN      0      64                   *:45284               *:*     
# LISTEN      0      128                  *:39822               *:*     
# LISTEN      0      128                  *:111                 *:*     
# LISTEN      0      128                 :::22                 :::*     
# LISTEN      0      64                  :::54008              :::*     
# LISTEN      0      20                 ::1:25                 :::*     
# LISTEN      0      128                 :::33915              :::*     
# LISTEN      0      64                  :::2049               :::*     
# LISTEN      0      128                 :::39754              :::*     
# LISTEN      0      128                 :::43210              :::*     
# LISTEN      0      128                 :::43403              :::*     
# LISTEN      0      128                 :::111                :::*   

####################################################################

#data in timestamp
date +%s
#byte di un file
stat prova.txt -c %s
#proprietario di un file
stat -c %U prova.txt
#aggiungere sulla macchina un ip con maschera e su interfaccia specificata
ip addr add 10.1.1.1/24 dev eth2
#rimuovere sulla macchina un ip con maschera e su interfaccia specificata
ip addr delete 10.1.1.1/24 dev eth2
#aggiungere sulla macchina indicazioni riguardo l'instradamento
ip route add 10.9.9.0/24 via 10.1.1.254
#rimuovere dalla macchina indicazioni riguardo l'instradamento
ip route delete 10.9.9.0/24 via 10.1.1.254
#cambiare sulla macchina ip che svolge l'instradamento
ip route replace default via 10.1.1.254
#aggiungere sulla macchina indicazioni riguardo l'instradamento
ip route add 10.9.9.0/24 dev eth1
#abilitare sulla macchina l'instradamento
sysctl -w net.ipv4.ip_forward=1
#buttare giù un'interfaccia
ifdown eth1
#tirare su un'interfaccia
ifup eth1
# aggiornare eventuali cambiamenti fatti al DHCP
sudo dhclient -v eth1
# visualizzare le rotte ottenute
ip route show

# Visualizza i PID dei processi che usano un file
fuser /path/to/file
# Visualizza i processi che usano un intero filesystem
fuser -m /var
# Invia un segnale di SIGUSR1 a tutti i processi che usano il file
fuser -k -USR1 /path/to/file
# Visualizza tutti i file aperti dal sistema
lsof
# Visualizza i file aperti da uno specifico user
lsof -u <username>
# Visualizza i file aperti da uno specifico processo
lsof -p <PID>
# Limitare l'output di lsof ad una sola directory
lsof +D /path/to/dir
# Listare tutti i file in base al tipo di connessione ( tcp o udp )
lsof -i tcp
# IMPORTANTE : Visualizza le porte numeriche e non simboliche
lsof -i tcp -P
#dd from if, se manca da stdin, to of, se manca stdout.
dd if=IN of=OUT

##############################-PORTE LIBERE-###############################
###########################- SS porte libere-#############################

# Questo script cerca, sul server in cui è lanciato, tra le porte TCP > 10000, la porta
# PORTA libera con valore più basso.

PORTA=10001
# Verifico se la porta 10001 è disponibile, e se lo è la utilizzo, altrimenti verifico che la porta successiva sia disponibile
while ss -lnt | cut -f2 -d: | awk '{ print $1 }' | grep -q $PORTA ; do
	PORTA=$(( $PORTA + 1 ))
	test $PORTA -gt 65535 && exit 1
done


##############################-MEMORY USAGE-###############################

# Free stampa l'utilizzo della memoria nel seguente formato:

#               total        used        free      shared  buff/cache   available
# Mem:          15633        3219        9068         878        3345       11204
# Swap:         16392           0       16392

free

# Un altro utile comando per vedere l'utilizzo della memoria, CPU, utenti e processi in esecuzione
# è top

# Output:

# top - 15:20:30 up  6:57,  5 users,  load average: 0.64, 0.44, 0.33
# Tasks: 265 total,   1 running, 263 sleeping,   0 stopped,   1 zombie
# %Cpu(s):  7.8 us,  2.4 sy,  0.0 ni, 88.9 id,  0.9 wa,  0.0 hi,  0.0 si,  0.0 st
# KiB Mem:   8167848 total,  6642360 used,  1525488 free,  1026876 buffers
# KiB Swap:  1998844 total,        0 used,  1998844 free,  2138148 cached
# PID USER      PR  NI  VIRT  RES  SHR S  %CPU %MEM    TIME+  COMMAND
# 2986 enlighte  20   0  584m  42m  26m S  14.3  0.5   0:44.27 yakuake
# 1305 root      20   0  448m  68m  39m S   5.0  0.9   3:33.98 Xorg
# 7701 enlighte  20   0  424m  17m  10m S   4.0  0.2   0:00.12 kio_thumbnail

# Per ottenere uno snapshot del comando top e salvarlo in un file:
top -b -n 1 > top.txt

############################-TRAP-########################################

FILE=/var/log/file.log
function logging(){
	case "$1" in
		start)	receive_messages > "$FILE" & PID=$! ;;
		stop)	test -n "$PID" && kill "$PID" ;;
		restart)logging stop && logging start ;;
	esac
}

trap 'logging restart' USR1
trap 'logging stop' EXIT
logging start
while :
do echo qui si fa qualcosa mentre si aspettano i segnali
done

############################-AT-########################################

# Utilizzare AT per terminare un processo dopo X minuti

# Importante anche per l'attesa di al massimo di 30 minuti
echo "kill $$" | at now + 30 minutes 2>&1 | awk '{ print $2 }' > /tmp/req$$
# due comandi tra mezz'ora
echo "/root/ldapmod.sh $UTENTE status closed ; /root/ldapmod.sh $UTENTE used 0" | at now + 30 minutes
#9:00 AM , now + 2 days

# atq comandi in coda ad utente. Eseguito da root: comandi in coda a tutti
# Rimuovo il job con Id 7 (con atq vedo id del job)
atrm 7

#rimuovo processo e comandi da lui lanciati, da grep ^job  mette id nel file
trap "kill -9 -$$" EXIT
# Importante: Memorizzo il pid del processo da terminare in un file apposito
echo "/bin/kill $$" | at now + 50 minutes 2>&1 | grep ^job | awk '{ print $2 }' > /tmip/watchdog.$$

cd ~/jobs
for S in * ; do
	echo fai cose
done

# Con atrm rimuovo il processo relativo al comando desiderato
atrm $(cat /tmp/watchdog.$$)
rm -f /tmp/at_$DADDR


############################-ROOT-#######################################

comandi di root: iptables, ss (?), tcpdump, adduser, addgroup, passwd, chown
#script da chiamare supposti in /root/

############################-CHECK-######################################
# REGEX
# Check
# Parametri

# Controllo che siano passati meno 30 minuti tra adesso e timestamp.
# Se sono passati 30 minuti segnalo errore.

NOW=$(date +%s)
if test $(( $NOW - $TIMESTAMP )) -gt 1800 ; then
    echo "Entry recenti (inserite da meno di 30 minuti) non trovate"
    exit 2
fi


# controllo parametri
if [[ $# -ne "3" ]]; then 
	echo "Uso: $! ip_client num ip_generico"
	exit 1
else
	#Controllo ch $1 abbia ultimo byte ip tra 1-100
	if ! echo "$1" | egrep -q "^10\.1\.1\.([1-9][0-9]?|100)$" ; then
		echo "$1 non e' un IP valido di client"
		exit 2-h 10.9.9.254
	fi
	#Controllo che $2 sia un numero intero, anche ^\d$
	if ! [[ "$2" =~ ^[0-9]+$ ]]; then
		echo "$2 is not a number"
		exit 3
	fi
	#notare che non sono ammessi indirizzi broadcast (non ammesso valore 255) e gli indirizzi del tipo *.*.*.0
	if ! [[ "$3" =~ ^(25[0-4]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-4]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-4]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.(25[0-4]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]?)$ ]] ; then
		echo "$3 non e' un IP valido"
		exit 4
	fi
	# $1 sia close o open
	if [[ "$1" != close && "$1" != open ]]  ; then
		echo "$1 deve essere close/open"
		exit 5
	fi
	
fi

###########################-REGEX UTILI-###############################

# Vedi cheatsheet in allegato

##########################-LDAP-########################################

#avvio demone ldap
sudo systemctl restart slapd
#aggiungere uno schema ldif
sudo ldapadd -Y EXTERNAL -H ldapi:/// -f nomefile.ldif
#Visualizzare l'entry e tutti i figli a partire da "dc=labammsis" su ldap locale
ldapsearch -x -h 127.0.0.1 -b "dc=labammsis"
#Visualizzare solo i figli di primo livello di "fn=home,dc=labammsis" su ldap locale
ldapsearch -x -h 127.0.0.1 -b "fn=home,dc=labammsis" -s one
#Visualizzare solo l'entry "fn=home,dc=labammsis" su ldap locale
ldapsearch -x -h 127.0.0.1 -b "fn=home,dc=labammsis" -s base
#Aggiungere una entry allo schema ldif su ldap locale
ldapadd -x -h 127.0.0.1 -D "cn=admin,dc=labammsis" -w admin -f entry.ldif
#Eliminare una entry dallo schema ldif su ldap locale
ldapdelete -x -h 127.0.0.1 -D "cn=admin,dc=labammsis" -w admin "user=pippo,dc=labammsis"
#Modificare una entry sullo schema ldif su ldap locale (oppure vedi funzione modldapattr)
ldapmodify -x -h 127.0.0.1 -D "cn=admin,dc=labammsis" -w admin -f differenze.ldif
#Visualizzare solo le entry con un certo valore di un attributo (output NON pulito), da usare in combo con grep (-c)
ldapsearch -x -h 127.0.0.1 -b "dc=labammsis" -s one "status=open"
#Visualizzare solo un attributo di una entry (output NON pulito)
ldapsearch -x -h 127.0.0.1 -b "user=pippo,dc=labammsis" -s one status

######################-FILTRI LDAP-###################################

# Filtri LDAP:

# Uguaglianza:  (attribute=abc)     , e.g. (&(objectclass=user)(displayName=Foeckeler)
# Negazione:    (!(attribute=abc))  , e.g. (!objectClass=group)
# Presenza:     (attribute=*)       , e.g. (mailNickName=*)
# Assenza:      (!(attribute=*))    , e.g. (!proxyAddresses=*)
# Maggiore di:  (attribute>=abc)    , e.g. (mdbStorageQuota>=100000)
# Minore di:    (attribute<=abc)    , e.g. (mdbStorageQuota<=100000)
# Prossimità:   (attribute~=abc)    , e.g. (displayName~=Foeckeler) 
# Wildcards: 	e.g. (sn=F*) or (mail=*@cerrotorre.de) or (givenName=*Paul*)

# Esempio 
# LDAP con:
#   MUST:   name
#   MAY:    routerport, serverport, server

# LDAP: cerco eventuali entry col solo attributo name compilato (che è MUST), mentre gli attributi MAY devono essere assenti.
# Soluzione:
ldapsearch -x -b "dc=labammsis" -s one '(&(!(routerport=*))(!(serverport=*))(!(server=*)))' | grep ^name: | 

#Applicare filtri in AND (per OR sostituire &->|)
ldapsearch -h 127.0.0.1 -x -s one -b "uname=$USER,dc=labammsis" "(&(objectClass=request)(action=*))"
ldapsearch -h 127.0.0.1 -x -b "dc=labammsis" -s sub "(&(objectclass=request)(|(action=get)(action=put)))"

# -LLL rimuove l'output commentato (ci sono vari livelli, 3 L e' output completamente privo di commenti)
ldapsearch -LLL -x -h 10.9.9.254 -b "dc=labammsis" "(&(objectClass=richiesta)(tempo>=$(( $(date +%s) - 1800 ))))" -S tempo 

#########################################################################


#Verificare che esista una entry
if ldapsearch -h localhost -x -b "server=$ips,utente=$username,dc=labammsis" -s base >/dev/null 2>&1 ; then
	echo entry presente
else 
	echo "lettura username fallita"
fi

# Cerco l'attributo di una entry
# Cerco il valore corrispondende a routerport e lo salvo in $RP
$RP=$(ldapsearch -x -h 10.1.1.254 -b "name=$1,dc=labammsis, " -s base | grep ^routerport | awk '{ print $2 }')

##################-ESEMPIO DI OUTPUT CON LDAPSEARCH-################

ldapsearch -x -h 10.1.1.254 -b "cn=admin,dc=labammsis" -s base

#Output:

# extended LDIF
#
# LDAPv3
# base <dc=labammsis> with scope subtree
# filter: (objectclass=")
# requesting: ALL

# labammsis

dn: dc=labammsis
objectClass: top
objectClass: dcObject
objectClass: organization
o: labammsis
dc: labammsis

# admin, labammsis
dn: cn=admin, dc=labammsis
objectClass: simpleSecurityObject
objectClass: organizationalRole
cn: admin
description: LDAP administrator
userPassword:: E1NTSEF9a2M4c0FfcaRkDlOAmCmiSnDDCKAOSIQJHUl=

#123_331234124133, labammsis
dn: idunico=123_3312341234133,dc=labammsis
objectClass: risultato
idunico: 123_3312341234133
nome: /etc/passwd
prop: root
dimen: 1798

#142_1331234468413, labammsis
dn: idunico=142_1331234468413,dc=labammsis
objectClass: risultato
idunico: 142_1331234468413
nome: /etc/passwd
prop: root
dimen: 1798

#177_1771737468717, labammsis
dn: idunico=177_1771737468717,dc=labammsis
objectClass: risultato
idunico: 177_1771737468717
nome: /etc/passwd
prop: root
dimen: 1798

##########################-LDAP-########################################

#esempio di aggiunta di una entry in uno schema ldap
echo -e "dn: user=gatto,dc=labammsis\nobjectClass: data\nuser: topo\nupdate: $(date +%s)\nused: 0\nstatus: closed\nlimit: 200" > /tmp/entry.ldif
ldapadd -x -h 127.0.0.1 -D "cn=admin,dc=labammsis" -w admin -f /tmp/entry.ldif
rm /tmp/entry.ldif

#Aggiunta di entry, con certezza riguardo alla sua univocita'
# $1 = nuovo gateway, $2 = indirizzo server LDAP da aggiornare, $3 DN, $4 ipclient
function registra_ldap(){
	ldapdelete -c -h $2 -x -D "cn=admin,dc=labammsis" -w admin "$3" 2> /dev/null
	TS=$(/bin/date +%s)
echo "dn: $3
objectClass: gw
ipclient: $4
iprouter: $1
timestamp: $TS" | ldapadd -x -D "cn=admin,dc=labammsis" -w admin -h $2
}

#####################-Creare entry in più con LDAP-#################################

# Altro modo di aggiungere entry, leggendole da file /var/log/get.log
# Formato del file: get_N1_N2_ST

tail --pid=$$ -f /var/log/get.log | while IFS=_ read N1 N2 ST ; do

#dn: idunico, dc=labammsis
(
echo "dn: idunico=$N1_$N2, dc=labammsis"
echo "objectClass: risultato"
echo "idunico: $N1_$N2"
echo "nome: $1"
if test -f $ST ; then
    prop=$(ls -l $ST | awk '{print $3}')
    dim=$(stat -c %s $ST)
    echo "prop: $prop"
    echo "dimen: $dim"
fi
) | ldapadd -h 10.9.9.254 -x -D "cn=admin,dc=labammsis" -w admin
done


# #rimpiazzo interamente la mia directory ldap e la importo da un altro server
function sostituisci_ldap(){
        #cancello le entry che ci sono...
        ldapsearch -h 127.0.0.1 -x -s sub -b "dc=labammsis" "objectClass=gw" | grep "^dn: " | awk '{ print $2 }' | ldapdelete -D "cn=admin,dc=labammsis" -w "admin" -x
        #le rimpiazzo con le entry dell'altro router
        ldapsearch -x -c -s sub -h 10.1.1.253 -b "dc=labammsis" "objectClass=gw" | ldapadd -x -D "cn=admin,dc=labammsis" -w admin 
}

##########################-LDAP-########################################

# Legge uno specifico attributo di una entry ldap
# ARGOMENTI : $1 Distinguished Name , $2 Nome attributo, $3 ip server ldap
# RETURN : 0 se l'attributo e' stato trovato, 1 altrimenti
function readldapattr() {
	RES=$(ldapsearch -x -h "$3" -b "$1" -s base | egrep "^$2: " | awk -F ": " '{ print $2 }')
	if test -z "$RES" ; then
		return 1
	else
		echo "$RES"
		return 0
	fi
}
# Esempio d'uso :
ATTRVAL=$(readldapattr "user=pippo,dc=labammsis" "status" "127.0.0.1")
echo "RETURN VALUE: $?"
echo "ATTR VALUE: $ATTRVAL"

#leggere piu' attributi con 1 unico ldapsearch (ORDINE ALFABETICO ATTRIBUTI)
ldapsearch -x -h localhost -b "user=pippo,dc=labammsis" -s base | sort | egrep "^used: |^limit: " | awk '{ print $2 }' > /tmp/ldap$$
LIM=$(head -1 /tmp/ldap$$)
USE=$(tail -1 /tmp/ldap$$)

######################-LDAP add or modify?-############################

# Ricavo il valore relativo al contatore della entry che presenta NAME come 'programma'
RES=$(ldapsearch -x -h 10.9.9.254 -b "programma=$1,dc=labammsis" -s base | egrep "^contatore: " | awk -F ": " '{ print $2 }')


# Incremento di N unità il contatore relativo alla propria entry LDAP:
# ARGOMENTI: $1 Distinguished Name, $2 Nome attributo, $3 Nuovo valore, $4 host server ldap
# RETURN: 0 se l'attributo e'stato modificato, 1 altrimenti

# NB: Contatore è un attributo MAY, pertanto potrebbe non comparire: occorre fare un controllo e poi decidere se aggiungere o modificare l'attributo contatore

if test -z "$RES" ; then
    RES=$N
    CMD=add
else 
    RES=$((RES+N))
    CMD=replace
fi

################-LDAP con comando a scelta specificato come CMD-#################

# nomeEntryUnivoca: entry corrispondente al servizio $NOME 


# In base a CMD (che può essere add, replace), aggiungere un certo attributo con un certo valore (in questo caso contatore: $RES)

# NB: prestare attenzione a $NOME. È un nome univoco relativo a una entry che viene solitamente richiesta.

echo -e "dn: nomeEntryUnivoca=$NOME,dc=labammsis\nchangetype: modify\n$CMD: contatore\ncontatore: $RES" | ldapmodify -x -h 10.9.9.254 -D "cn=admin,dc=labammsis" -w admin


##########################-LDIF-########################################

#Schema ldif, importante non prendere gli spazi
dn: cn=data,cn=schema,cn=config
objectClass: olcSchemaConfig
cn: data
olcAttributeTypes: ( 1000.1.1.1 NAME 'user'
  DESC 'nome dello user'
  EQUALITY caseExactMatch
  SUBSTR caseExactSubstringsMatch
  SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )
olcAttributeTypes: ( 1000.1.1.2 NAME 'limit'
  DESC 'MB trasferibili max'
  EQUALITY integerMatch
  ORDERING integerOrderingMatch
  SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 )
olcAttributeTypes: ( 1000.1.1.3 NAME 'used'
  DESC 'MB trasferiti'
  EQUALITY integerMatch
  ORDERING integerOrderingMatch
  SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 )
olcAttributeTypes: ( 1000.1.1.4 NAME 'status'
  DESC 'valore dello status'
  EQUALITY caseExactMatch
  SUBSTR caseExactSubstringsMatch
  SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )
olcAttributeTypes: ( 1000.1.1.5 NAME 'update'
  DESC 'ultimo update'
  EQUALITY integerMatch
  ORDERING integerOrderingMatch
  SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 )
olcObjectClasses: ( 1000.2.1.1 NAME 'data'
  DESC 'data'
  MUST ( user $ limit $ used $ status $ update )
  STRUCTURAL )

#Schema LDIF piu' articolato, importante non includere spazi
dn: cn=file,cn=schema,cn=config
objectClass: olcSchemaConfig
cn: file
olcAttributeTypes: ( 5000.1.1.1 NAME ( 'uname' )
  DESC 'uname'
  EQUALITY caseExactMatch
  SUBSTR caseExactSubstringsMatch
  SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )
olcAttributeTypes: ( 5000.1.1.2 NAME ( 'file' )
  DESC 'file'
  EQUALITY caseExactMatch
  SUBSTR caseExactSubstringsMatch
  SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )
olcAttributeTypes: ( 5000.1.1.3 NAME ( 'action' )
  DESC 'nome dello scipt'
  EQUALITY caseExactMatch
  SUBSTR caseExactSubstringsMatch
  SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )
olcAttributeTypes: ( 5000.1.1.4 NAME ( 'ts' )
  DESC 'ts'
  EQUALITY integerMatch
  ORDERING integerOrderingMatch
  SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 )
olcAttributeTypes: ( 5000.1.1.5 NAME ( 'limit' )
  DESC 'limit'
  EQUALITY integerMatch
  ORDERING integerOrderingMatch
  SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 )
olcAttributeTypes: ( 5000.1.1.6 NAME ( 'byte' )
  DESC 'byte'
  EQUALITY integerMatch
  ORDERING integerOrderingMatch
  SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 )
olcAttributeTypes: ( 5000.1.1.7 NAME ( 'client' )
  DESC 'client'
  EQUALITY caseExactMatch
  SUBSTR caseExactSubstringsMatch
  SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )
olcObjectClasses: ( 5000.2.1.1 NAME 'user'
  DESC 'un utente'
  MUST ( uname $ limit )
  STRUCTURAL )
olcObjectClasses: ( 5000.2.1.2 NAME 'request'
  DESC 'richiesta di esecuzione'
  MUST ( ts $ file $ client )
  MAY (action $ byte )
  STRUCTURAL )

##########################-LDIF-########################################

# Definizione di una entry per lo schema data (file entry.ldif)
# Aspetto di una singola entry;

# pippo, labammsis
dn: user=pippo,dc=labammsis
objectClass: data
user: pippo
update: 1234567890
used: 0
status: closed
limit: 200

##########################-LDIF-########################################

# File differenze.ldif che modifica l’attributo used dell’entry
# definita in precedenza con dn: user=pippo,dc=labammsis
dn: user=pippo,dc=labammsis
changetype: modify
replace: used
used: 50

# Eliminazione di un attributo
dn: ts=555555,uname=$USER,dc=labammsis
changetype: modify
delete: action

# Aggiunta di un attributo
dn: ts=555555,uname=$USER,dc=labammsis
changetype: modify
add: byte
byte: 30

##########################-LDAP-########################################

# Modifica di uno specifico attributo di una entry ldap
# ARGOMENTI: $1 Distinguished Name, $2 Nome attributo, $3 Nuovo valore, $4 host server ldap
# RETURN: 0 se l'attributo e'stato modificato, 1 altrimenti
function modldapattr() {
	echo -e "dn: $1\nchangetype: modify\nreplace: $2\n$2: $3" | ldapmodify -x -h "$4" -D "cn=admin,dc=labammsis" -w admin
	return $?
}
# Esempio d’uso :
modldapattr "ind=10.9.9.1,ind=10.1.1.1,dc=labammsis" "cnt" "2" "127.0.0.1"
echo "RETURN VALUE: $?"

# Eliminazione di uno specifico attributo di una entry ldap
# ARGOMENTI: $1 Distinguished Name, $2 Nome attributo, $3 host server ldap
# RETURN: 0 se l'attributo e'stato rimosso, 1 altrimenti
function delldapattr() {
	echo -e "dn: $1\nchangetype: modify\ndelete: $2" | ldapmodify -x -h "$3" -D "cn=admin,dc=labammsis" -w admin
	return $?
}
# Esempio d’uso :
modldapattr "ts=555555,uname=$USER,dc=labammsis" "action" "127.0.0.1"
echo "RETURN VALUE: $?"

# Aggiunta di uno specifico attributo di una entry ldap
# ARGOMENTI: $1 Distinguished Name, $2 Nome attributo, $3 Valore, $4 host server ldap
# RETURN: 0 se l'attributo e'stato aggiunto, 1 altrimenti
function addldapattr() {
	echo -e "dn: $1\nchangetype: modify\nadd: $2\n$2: $3" | ldapmodify -x -h "$4" -D "cn=admin,dc=labammsis" -w admin
	return $?
}
# Esempio d’uso :
modldapattr "ts=555555,uname=$USER,dc=labammsis" "byte" "30" "127.0.0.1"
echo "RETURN VALUE: $?"

##########################-LDAP esercizio-#######################################
# Controllo directory LDAP
# 1 minuto di controllo
# Come incrementare un contatore di uno
# Impostare un timeout


# controlla ogni 10 secondi se compaiono nella directory LDAP di Router i risultati relativi
# alla richiesta inviata. inseriti da Server per mezzo dello script find.sh.
# Per ogni entry trovata, deve essere stampata su stdout una riga coi valori di nome, prop e
# dimen; la entry deve poi essere immediatamente cancellata.
# il ciclo di controllo termina quando sono state trovate tutte le risposte attese, o se trascorre 1
# minuto senza che siano comparse nuove risposte dopo l'ultima trattata.
TLIMIT=$(( $(date +%s) + 60 ))
while test $(date +%s) -lt "$TLIMIT" -a "$NUMRESPONSES" -lt "$PROG"  ; do
    ldapsearch -h 10.1.1.254 -b "dc=labammsis" -s one "(idunico=${RAN}_*)" |
    grep --line-buffered ^dn | 
    while read DN VAL ; do
    
    # DN ="cn=ris,cn=schema,cn=config"
    # VAL= tutto il resto
    
        # output di LDAPSearch:
        # [Commenti random che non interessano a nessuno]
        # dn: cn=ris,cn=schema,cn=config
        # objectClass: olcSchemaConfig
        # idunico:1234567890123456 
        # nome:111
        # prop:ciao
        # dimen:10

        ldapsearch -h 10.1.1.254 -b "$VAL" -s base > /tmp/details
        echo $(grep ^nome /tmp/details | cut -c6-) $(grep ^prop /tmp/details | cut -c6-) $(grep ^dimen /tmp/details | cut -c7-)
        ldapdelete -h 10.1.1.254 -x -D "cn=admin,dc=labammsis" -w admin "$VAL"
        # Azzero il contatore dei secondi e ne aggiungo 60 in più
        TLIMIT=$(( $(date +%s) + 60 ))
        (( NUMRESPONSES++ ))
    done
    sleep 10 
done

#################-LDAP CONSIGLIO SALVATAGGIO DI UNA ENTRY-###############

# Salvare la entry in un file temporaneo come /tmp/details
ldapsearch -h 10.9.9.254 -b "timestamp=$MOSTRECENT,dc=labammsis, " -s base > /tmp/details

#Effettuare le opportune operazioni, come ricavare un IP:
IPCLIENT=$(grep ^ip /tmp/details | awk ": " '{ print $2 }')
# Rimuovere il file temporaneo
rm -f /tmp/details

##########################-LOG-#########################################
# CAPITOLO SYSLOG
# Filtri regex per rsyslog
# eregex = ERE (Extended Regular Expression )
# regex = BRE (Basic Regular Espression)
:msg, ereregex, "get(_[[:digit:]]+){2}_(/[^/ ]+)+$"     /var/log/destination.log
#Scrivere un messaggio al logger

logger -p local4.info ___$(hostname -I | egrep -o "10\.1\.1\.([1-9][0-9]?|100)")___$(whoami)___

# Scrivere messaggi syslog a un host remoto, con etichetta local4.info:
logger -p local4.info -n 10.9.9.1 "Questa è una prova"


#formato di un file di log:
#Jun  7 14:29:40 Router las: ___prova1___ciao___
#facility: auth, ftp, news, authpriv, kern, syslog, cron, lpr, user, daemon, mail, uucp, local0 .. local7
#priority: emerg, alert, crit, err, warning, notice, info, debug

#leggere da /var/log/reqs righe con formato
#Jun  7 14:29:40 Router las: ___prova1___ciao___
tail --pid=$$ -f /var/log/reqs | while read mm gg hh host user msg ; do
	IP=$(echo $msg | awk -F '___' '{ print $2 }')
	UTENTE=$(echo $msg | awk -F '___' '{ print $3 }')
	echo $IP
	echo $UTENTE
done
#(per filtrare su input)
#tail --pid=$$ -f /var/log/reqs | grep --line-buffered EXEC___ | while read line; do

#Usare una funzione per scrivere messaggi di errore sul log
function err() {
	EX=$1
	shift
	echo "$@"
	logger -p local1.info "$@" 
	exit $EX
}
#Esempio d'uso
if [ "$1" != "put" -a "$1" != "get" ] ; then
	err 1 "Bad first argument, need put|get"
fi

if ! echo "$2" | grep -q '^/' ; then
	err 2 "Bad second argument, need a filename"
fi

##########################-LOG-#########################################

# Come configurare rsyslog
# /etc/rsyslog.d/esame.conf
# -- su C: local1.=info	@10.1.1.253
#          local1.=info	@10.1.1.254
# -- su R: local1.=info /var/log/reqs
# Decommentare le seguenti linee in /etc/rsyslog.conf
#       $ModLoad imudp
#	$UDPServerRun 514
# Eseguire il comando
# sudo systemtctl restart rsyslog

##########################-SNMP-#########################################

#**************************************************
# Lato manager (client) [/etc/snmp/snmp.conf]
#**************************************************
# Configurare il demone SNMP su client commentando nel file /etc/snmp/snmp.conf la riga "mibs:" per avere i nomi simbolici


#**************************************************
# Lato agent (server) [/etc/snmp/snmpd.conf]
#***************************************************

#----------------------------------------------------------------
# Sezione AGENT BEHAVIOUR: vengono elencate le connessioni (socket)
#----------------------------------------------------------------
# La riga agentAddress  udp:127.0.0.1:161 non rende interrogabile la macchina, poiché in questo modo è interrogabile solo da se stessa.
# Occorre infatti togliere l'indirizzo, in modo che sia accessibile da qualunque manager.
# Pertanto nel file /etc/snmp/snmpd.conf deve comparire al posto di udp:127.0.0.1:161
# agentAddress  udp:161

#----------------------------------------------------------------
# Sezione ACCESS CONTROL: vengono definite le password affinché
#                         il manager possa fare operazioni Read-Only
#                         oppure Read-Write sull'agent SNMP                         
#----------------------------------------------------------------

# public e supercom sono le due password di default
# Tutto quello che riguarda rocommunity e rwcommunity va commentato, tranne rouser, e vanno aggiunte le seguenti due righe:
# rocommunity public
# rwcommunity supercom
# In questo modo chiunque disponga della parola segreta public esegue solo lettura di tutto l'agent SNMP, chi scrive supercom esegue sia lettura che scrittura.


#----------------------------------------------------------------
# Sezione SYSTEM INFORMATION:                     
#----------------------------------------------------------------

# Minisezioni: sono tabelle con specifiche informazioni
# Se sysLocation è scritto, allora si possono fare solo operazioni Read-Only, altrimenti se commentato qualsiasi oggetto su cui sia possibile scrivere del SNMP-Agent è sia writable che readable.

# Minisezione process monitoring (prTable):

# Utile per capire se vengono sforate delle soglie per quel che riguarda il numero di processi massimi e minimi in esecuzione. Serve per fare capire eventuali problemi di esecuzione di certi processi al manager.
# NB se il range max-min non viene specificato il numero di processi attualmente in esecuzione sull'agent è illimitato

# Aggiungere in questa sezione (segue esempio)
# proc <nome_processo> <max_numero> <min_numero>

# ESEMPI:
#proc rsyslogd 10 1
#proc rsyslogd

# Minisezione Disk Monitoring (dskTable)
# Mostra le partizioni a livello di memoria e quanto vengono utilizzate in percentuale.
# Mostra se ci sono eventuali problemi di utilizzo della memoria

# Minisezione System Load (laTable)
# Massimo valore tollerabile per gli ultimi 1-5-15 minuti
# Stesso output di uptime
uptime | awk -F 'average: ' '{ print $2 }' | cut -f1 -d$(locale decimal_point))
# per il carico medio del sistema a 1 minuto

#----------------------------------------------------------------
# Sezione EXTENDING THE AGENT: Estendo il funzionamento dell'agent
#                              permettendo di fargli eseguire comandi
#                              sull'agent quando viene invocato con snmpget
#----------------------------------------------------------------

# Presenta etichette simboliche
# Aggiungere i comandi che si desiderano eseguire 

# Per fare in modo che SNMP possa essere esteso per eseguire un comando di root sono necessari alcuni passaggi:

# Per far eseguire a SNMP comandi di root serve editare il file di configurazione
# /etc/snmp/snmpd.conf per includere la nuova regola (sezione arbitrary extension commands del server):
# In caso di ss:
extend sslist /usr/bin/sudo /bin/ss
# In caso di iptables -vnL
extend ipt /usr/bin/sudo /sbin/iptables -vnL

# editare il file /etc/sudoers con: sudo visudo

# Inserire la seguente riga nel file /etc/sudoers in modo che l'utente snmp possa eseguire il comando ss senza digitare la password (NB: All'esame sostituire ss con il comando richiesto ed eventuali opzioni)
#snmp ALL=NOPASSWD:/bin/ss

# Altro esempio di modifica di /etc/sudoers: permette di eseguire iptables -vnL
#snmp ALL=NOPASSWD:/sbin/iptables -vnL

# Infine eseguire il comando "sudo systemtctl restart snmpd"

# Successivamente eseguire snmpget e snmpwalk


########################################################################
#snmpget esame
# verifico se esiste una directory con nome "esame" e con nome file $2
snmpget -v 1 -c public 10.1.1.1 'NET-SNMP-EXTEND-MIB::nsExtendOutputFull."esame"' | awk -F ' = STRING: ' '{ print $2 }'
#Inserire inoltre la riga "extend-sh esame ps -C connect.sh -o user | grep -v USER"


# Verifica via SNMP se esiste su Server il file /results/$SU
snmpget -v 1 -c public 10.9.9.1 'NET-SNMP-EXTEND-MIB::nsExtendOutputFull."results"' | grep -q "$1" &&

#Visualizza tutti gli oggetti del server 10.9.9.1
snmpwalk -v 1 -c public 10.9.9.1 .1 | less
#Visualizza tutti gli oggetti del server 10.9.9.1 mostrando OID
snmpwalk -On -v 1 -c public 10.9.9.1 .1 | less
# Visualizza il valore di una specifica entry del server 10.9.9.1 'SNMPv2-MIB::sysName.0'
snmpget -v 1 -c public 10.9.9.1 'SNMPv2-MIB::sysName.0'

##########################################################################################
# Esempio 1 (ss via SNMP):
# Testa via SNMP il server S, per verificare se esiste un processo di nome N in ascolto sulla porta PS
snmpget -v 1 -c public "$S" 'NET-SNMP-EXTEND-MIB::nsExtendOutputFull."sslist"' | egrep -q :$PS' users:\(\("'$N'.sh"' ||
# Esempio 2 (iptables via SNMP):
snmpget -v 1 -c public 192.168.56.203 NET-SNMP-EXTENDED-MIB::nsExtendedOutputFull.\"ipt \"

#########################################################################################
#Elenco dei processi monitorati da snmp su localhost
snmpwalk -v 1 -c public localhost "UCD-SNMP-MIB::prNames"
# Visualizza tutti i valori di UDC - SNMP - MIB
snmpwalk -v 1 -c public localhost .1 | grep "UCD-SNMP-MIB"

# Ottengo l'id del processo "rsyslogd" su localhost e lo salvo in ID
ID=$(snmpwalk -v 1 -c public localhost "UCD-SNMP-MIB::prNames" | grep rsyslogd | awk -F "prNames." '{ print $2 }' | awk -F " = " '{ print $1 }')
# Utilizzo l'id per ottenere il conteggio, verifico cosi' se il processo e' in esecuzione su localhost
snmpget -v 1 -c public localhost "UCD-SNMP-MIB::prCount.$ID" | awk -F "INTEGER: " '{ print $2 }'

##########################-SNMP-#########################################

# Ottiene il numero di istanze di un processo registrato tramite SNMP
# ARGOMENTI : $1 nome processo , $2 indirizzo macchina
function getProcessCount{
    # Ottengo l'id del processo "$1" sull'indirizzo IP "$2" e lo salvo in ID
	ID=$(snmpwalk -v 1 -c public "$2" "UCD-SNMP-MIB::prNames" | grep "$1" | awk -F "prNames." '{ print $2 }' | awk -F " = " '{ print $1 }')
    # Utilizzo l'id per ottenere il conteggio, verifico cosi' se il processo "$1" e' in esecuzione su "$2"
	NUM=$(snmpget -v 1 -c public "$2" "UCD-SNMP-MIB::prCount.$ID" | awk -F "INTEGER: " '{ print $2 }')
	echo $NUM
}

# Esempio d'utilizzo:
NUMERO=$(getProcessCount "rsyslogd" "10.9.9.1" )
echo $NUMERO

# ESEMPIO:
# Cerca con SNMP il server, tra i 10, che ha il più basso carico medio negli ultimi 5 minuti

function bestserver() {
for S in "$@" ; do 
    echo $(snmpget -v 1 -c public $S UCD-SNMP-MIB::laLoadInt.1 | awk -F 'INTEGER: ' '{ print $2 }') $S
done | sort -nr | head -1 | awk '{ print $2 }'
}


##########################-IPTABLES-#########################################

# OPZIONI:
-i eth3 # Solo pacchetti in ingresso dall'interfaccia eth3
-o eth3 # Solo pacchetti in uscita dall'interfaccia eth3
-s <ip>[/<netmask>] # Pacchetti che provengono dall'ip specificato
-d <ip>[/<netmask>] # Pacchetti destinati all'ip specificato
-p tcp # Solo pacchetti TCP
-p udp # Solo pacchetti UDP [anche icmp]
#Si puo' specificare il negato di un'opzione
! -s <address>[/<netmask>]
# Specificando il protocollo tcp o udp , si possono selezionare le porte:
--dport <prt> # Pacchetti con porta di destinazione == <prt>
--sport <prt> # Pacchetti con porta di partenza == <prt>
# Nel caso del protocollo TCP, anche lo stato della connessione:
-m state --state NEW,ESTABLISHED
-m state --state ESTABLISHED

#Le regole iptables vengono resettate allo spegnimento della macchina, se si vogliono rendere persistenti
#è quindi importante aggiungerle al file .bashrc
# Visualizza le configurazioni di iptables (tabella filter), -x per valori numerici esatti
iptables -vnxL
# Visualizza una singola chain
iptables -L <chain>

############################-FILTER-########################################

#Policy:
#DROP: Scarta il pacchetto
#REJECT: Scarta il pacchetto ed invia un pacchetto ICMP per segnalare l’errore al mittente.
#ACCEPT: Accetta il pacchetto.

#chain: INPUT, OUTPUT, FORWARD

# IPTABLES definisce i seguenti stati di flussi/connessioni:
# – NEW: generato da un pacchetto appartenente a un
#  flusso/connessione non presente nella tabella conntrack
# – ESTABLISHED: associato a flussi/connessioni dei quali
# sono stati già accettati pacchetti precedenti, in entrambe le
# direzioni

# Aggiungo una regola in coda ( APPEND ) alla chain FORWARD
iptables -A FORWARD <options> -j <policy>
# Aggiungo una regola all'inizio della coda ( INSERT ) alla chain FORWARD
iptables -I FORWARD <options> -j <policy>
# Rimuovo una regola ( DELETE ) dalla chain FORWARD 
iptables -D FORWARD <options> -j <policy>
# Elimina la regola numero 2 della chain INPUT
iptables -D INPUT 2
#Eliminare tutte le regole (di ogni chain o di quella specificata)
iptables -F <chain>
iptables -F
#Azzera pacchetti passati nelle catena, mostrando valori attuali
iptables -Z -vnL

# -j RETURN indica che i pacchetti non devono più passare dalla catena corrente, ma a quella successivamente indicata

######################### NAT ###########################

# 4 chain predefinite:

# – PREROUTING: contiene le regole da usare prima
# dell’instradamento per sostituire l’indirizzo di destinazione dei
# pacchetti (policy = Destination NAT o DNAT)
#
# – POSTROUTING: contiene le regole da usare dopo
# l’instradamento per sostituire l’indirizzo di origine dei pacchetti
# (policy = Source NAT o SNAT)
#
# – OUTPUT/INPUT: contiene le regole da usare per sostituire
# l’indirizzo di pacchetti generati/ricevuti localmente


# La policy ACCEPT vuol dire assenza di conversione
# La policy MASQUERADE vuol dire conversione implicita
# nell’indirizzo IP assegnato all’interfaccia di uscita


# Per visualizzare le regole attualmente in uso da ogni
# chain della tabella nat:
iptables -t nat -L [ -nv --line-num ]
# Per visualizzare le regole attualmente in uso da una
# chain specifica:
iptables -t nat -L <chain>
# Per aggiungere una regola in coda ad una chain:
iptables -t nat -A <chain> <rule specs> -j <policy>

# dove:
# <chain> = POSTROUTING | PREROUTING | OUTPUT | ...
# <policy> = ACCEPT | MASQUERADE |
# SNAT --to-source <addr> |
# DNAT --to-destination <addr>
# <addr> = <address> | <address>:<port>
# <rule specs> = come per la tabella filter


##################-Esercizio IPTABLES cattivo-##########################

# Il traffico TCP, relativo al servizio N, e indirizzato ad una specifica porta di RF stesso, deve venire inoltrato a S sulla porta PS.


# Identifico la chain che caratterizza il nome del servizio offerto
CHAINNAME=REDIR_$N
IPN="/sbin/iptables -t nat"
 
# Nel caso non vi sia nessuna ridirezione attiva per il servizio N, deve essere scelta una porta PR
# non utilizzata (la prima disponibile >5000) e inserita una nuova regola.

# Nel caso sia già attiva una ridirezione per il servizio N, deve essere sostituita la regola
# esistente mantenendo la porta PR corrente e aggiornando la destinazione (S:PS)

if ! $IPN -nL PREROUTING | grep -q $CHAINNAME ; then
	# custom chain missing, must choose port and create it
	PR=$($IPN -nL PREROUTING | grep REDIR_ | awk -F 'dpt:' '{ print $2}' | sort -n | tail -1)
	if test "$PR" ; then 
		PR=$(( $PR + 1 ))
	else
		PR=5001
	fi
	$IPN -N $CHAINNAME 
	$IPN -I PREROUTING -p tcp -d 10.1.1.254 --dport $PR -j $CHAINNAME
fi
$IPN -F $CHAINNAME
$IPN -I $CHAINNAME -j DNAT -p tcp --to-dest $S:$PS

##################-IPTABLES VPN-################################


# Ricavo IP pubblico VPN e porta
IPPUBVPN=$(ss -ntp | grep openvpn | awk '{ print $5 }' | cut -f1 -d:)
PORTPUBVPN=$(ss -ntp | grep openvpn | awk '{ print $5 }' | cut -f2 -d:)
# Ricavo indirizzo privato
IPPRIVATO=$(ip a | grep peer | awk -F 'peer ' '{ print $2 }'| cut -f1 -d/)

# connessioni da macchina remota
# la macchina remotamente raggiungibile attraverso la VPN possa connettersi con qualsiasi
# protocollo a Router

iptables -I INPUT -s $IPPRIVATO -j ACCEPT
iptables -I OUTPUT -d $IPPRIVATO -j ACCEPT
iptables -I INPUT -p tcp -s $IPPUBVPN --sport $PORTPUBVPN -j ACCEPT
iptables -I OUTPUT -p tcp -d $IPPUBVPN --dport $PORTPUBVPN -j ACCEPT

#################-ESERCIZIO CON VPN CONFIG DI IPTABLES-################


# Realizzate sulla VM Router uno script /root/fw.sh che configuri il sistema in modo
# che le connessioni TCP entranti attraverso la VPN (cioè provenienti dall’endpoint remoto
# privato e dirette all’indirizzo privato locale di Router)
# ◦ sulla porta 221 siano ridirette alla porta 22 di Client
# ◦ sulla porta 229 siano ridirette alla porta 22 di Server
# ◦ siano gestite in modo che Client e Server vedano il traffico provenire da Router
# ed eseguitelo

# Elimino qualsiasi regola di ogni chain per precauzione
iptables -F 

# Gestisco la connessione VPN: trovo l'indirizzo IP remoto
# output di "ip a" contiene:
# inet 10.12.0.54 peer 10.12.0.1/32 scope global tun0
ip a | grep peer | awk '{ print $2, $4}' | cut -f1 -d/ | (
    read LOC REM
    # La connessione entrante attraverso la VPN, sulla porta 221 di Router viene ridiretta alla porta 22 di client
    iptables -t nat -A PREROUTING -s $REM -p tcp -d $LOC --dport 221 -j DNAT --to-dest 10.1.1.1:22
    iptables -t nat -A PREROUTING -s $REM -p tcp -d $LOC --dport 229 -j DNAT --to-dest 10.9.9.1:22
    iptables -t nat -A POSTROUTING -s $REM -p tcp -d 10.1.1.1 --dport 22 -j SNAT --to-source 10.1.1.254
    iptables -t nat -A POSTROUTING -s $REM -p tcp -d 10.9.9.1 --dport 22 -j SNAT --to-source 10.9.9.254
    
)

# In caso di assegnazione di policy default DROP:

# Imposto policy ACCEPT per traffico che coinvolge l'interfaccia di loopback
iptables -I INPUT -i lo -j ACCEPT
iptables -I OUTPUT -o lo -j ACCEPT
########################################################################################################

#ARGOMENTI: $1 A oppure D per aggiungere o togliere la regola, $2 indirizzo sorgente, ma da settare a seconda dei casi
function gestisciRegola() {
	iptables -"$1" INPUT -s "$2" -j ACCEPT
	#iptables -"$1" FORWARD -i eth2 -o eth1 -s "$2" ! -d 10.1.1.0/24 -j ACCEPT
	#iptables -"$1" FORWARD -i eth1 -o eth2 ! -s 10.1.1.0/24 -d "$2" -j ACCEPT -m state --state ESTABLISHED
	#iptables -t nat -"$1" POSTROUTING -i eth2 -o eth1 -s "$2" ! -d 10.1.1.0/24 -j SNAT --to-source 10.9.9.250
}

# Esempio d'uso
# Aggiungo la regola
gestisciRegola A 10.1.1.1
# Elimino la regola
gestisciRegola D 10.1.1.1

#check rule in forward chain already exists 
#Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
# pkts bytes target     prot opt in     out     source               destination         
#    0     0 ACCEPT     tcp  --  eth1   eth2    10.9.9.1             10.1.1.1             tcp spt:22 state ESTABLISHED
#    0     0 ACCEPT     tcp  --  eth2   eth1    10.1.1.1             10.9.9.1             tcp dpt:22
client=10.1.1.1
server=10.9.9.1
if ! iptables -vnL FORWARD | egrep -q "ACCEPT +tcp +-- +eth2 +eth1 +$client +$server +tcp dpt:22$" ; then
	iptables -I FORWARD -o eth1 -i eth2 -p tcp -s 10.1.1.1 -d 10.9.9.1 --dport 22 -j ACCEPT
	iptables -I FORWARD -o eth2 -i eth1 -p tcp -d 10.1.1.1 -s 10.9.9.1 --sport 22 -m state --state ESTABLISHED -j ACCEPT
else
	echo regola gia inserita
fi


##########################-IPTABLES LOG-#####################################

#Inserisce una regola che logga i pacchetti in transito nella chain specificata con prefisso e livello di log specificati
#I log hanno facility=kernel, --log-level=debug => i log salvati con livello kernel.debug 
iptables -I <chain> <options> -j LOG --log-prefix="___prefisso___" --log-level=<livello_log>
# Logga l'inizio di ogni connessione inoltrata da 10.1.1.1 a 10.9.9.1 con livello debug e prefisso ___NEWCON___
iptables -I FORWARD -i eth2 -s 10.1.1.1 -d 10.9.9.1 -p tcp --tcp-flags SYN SYN -j LOG --log-prefix "___NEWCON___" --log-level=debug
# Logga la fine di ogni connessione inoltrata da 10.1.1.1 a 10.9.9.1 con livello debug e prefisso ___ENDCON___
iptables -I FORWARD -i eth2 -s 10.1.1.1 -d 10.9.9.1 -p tcp --tcp-flags FIN FIN -j LOG --log-prefix "___ENDCON___" --log-level=debug

function imposta_regole(){
	# ... deve essere attivata (evitando duplicazioni) 
	# su entrambi i router una regola di iptables 
	# che permetta di loggare ogni pacchetto da e per tale client (passato come $1)
	#volendo mandare in background imposta_regole: ssh las@192.168.56.202 "ip route" | grep -q "default via 10.0.2.2", se $? diverso da 0 si lanciano script seguenti

	echo "if ! iptables -vnL FORWARD | grep -q 'check_$1' ; then
                iptables -I FORWARD -s $1 -j LOG --log-level debug --log-prefix  ' check_$1 '
                iptables -I FORWARD -d $1 -j LOG --log-level debug --log-prefix  ' check_$1 '
                iptables -I INPUT -s $1 -j LOG --log-level debug --log-prefix  ' check_$1 '
                iptables -I OUTPUT -d $1 -j LOG --log-level debug --log-prefix  ' check_$1 '
              fi" > /tmp/regole$1.sh
	/bin/bash /tmp/regole$1.sh
	#qui inserimento regole su altro router
	scp /tmp/regole$1.sh 10.1.1.253:/tmp
	ssh 10.1.1.253 "/bin/bash /tmp/regole$1.sh ; rm -f /tmp/regole$1.sh"
	#rimuovo file contenente regole
	rm -f /tmp/regole$1.sh
}

# ===============================================================================================================
# /var/log/newconn:

# Apr 27 12:02:56 router kernel: [10139.999098]  INIZIO IN=eth2 OUT=eth1 MAC=08:00:27:27:a6:e6:08:00:27:24:9b:d5:08:00 SRC=10.1.1.1 DST=10.9.9.1 LEN=60 TOS=0x00 PREC=0x00 TTL=63 ID=23272 DF PROTO=TCP SPT=37668 DPT=22 WINDOW=29200 RES=0x00 SYN URGP=0

# ===============================================================================================================

#FORMATO DEI LOG CIRCA PER UDP, ICMP, TCP

#Jun 16 15:59:03 Router kernel: [12506.141621] ___UDP___ IN=eth2 OUT= MAC=08:00:27:0b:37:1f:08:00:27:72:c7:c1:08:00 SRC=10.1.1.1 DST=10.1.1.254 LEN=82 TOS=0x00 PREC=0x00 TTL=64 ID=2939 DF PROTO=UDP SPT=51519 DPT=161 LEN=62 

#Jun 16 15:31:40 Router kernel: [10862.759703] ___ICMP___ IN=eth2 OUT= MAC=08:00:27:0b:37:1f:08:00:27:72:c7:c1:08:00 SRC=10.1.1.1 DST=10.1.1.254 LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=33869 DF PROTO=ICMP TYPE=8 CODE=0 ID=1301 SEQ=1

# Apr 27 12:02:56 router kernel: [10139.999098]  INIZIO IN=eth2 OUT=eth1 MAC=08:00:27:27:a6:e6:08:00:27:24:9b:d5:08:00 SRC=10.1.1.1 DST=10.9.9.1 LEN=60 TOS=0x00 PREC=0x00 TTL=63 ID=23272 DF PROTO=TCP SPT=37668 DPT=22 WINDOW=29200 RES=0x00 SYN URGP=0

# opzioni dei comandi
# tail --pid $$ garantisce che tail termini quando termina il processo principale
# grep --line-buffered e awk -W interactive evitano il buffering, ogni linea 
# prodotta va direttamente in output
#
# notare che awk taglia sulla "]" evitando il problema dovuto al timestamp precedente,
# che potrebbe riempire o non riempire le [] modificando la numerazione dei campi seguenti

tail --pid=$$ -f /var/log/newconn | egrep --line-buffered 'INIZIO|FINE' | awk -W interactive -F ']' '{ print $2 }' | while read EVENTO IN OUT MAC SRC DST LEN TOS PREC TTL ID DF PROTO SPT DPT RESTO ; do
	SOURCEIP=$(echo $SRC | cut -f2 -d=)
	SOURCELASTBYTE=$(echo $SOURCEIP | cut -f4 -d.)
	DESTIP=$(echo $DST | cut -f2 -d=)
	DESTLASTBYTE=$(echo $DESTIP | cut -f4 -d.)
	SOURCEPORT=$(echo $SPT | cut -f2 -d=)
	DESTPORT=$(echo $DPT | cut -f2 -d=)
	CHAIN="CONTA-$SOURCELASTBYTE-$DESTLASTBYTE-$SOURCEPORT-$DESTPORT"

	# uso una custom chain semplicemente per metterci dentro una sola regola
	# salto poi nella custom chain dalla catena FORWARD, sia per i pacchetti
	# in andata che in ritorno: la regola della custom chain quindi somma
	# automaticamente i traffici, semplificando il successivo rilevamento
	#
	# notare che si usa solo l'ultimo byte degli indirizzi, che in questo 
	# specifico caso è suffciente a individuare le macchine, perche' le 
	# catene hanno nomi limitati a 32 caratteri

	case $EVENTO in 
		INIZIO)
			iptables -N $CHAIN
			iptables -I $CHAIN -j RETURN
			forwardjump I $SOURCEIP $DESTIP $SOURCEPORT $DESTPORT $CHAIN
		;;
		FINE)
			forwardjump D $SOURCEIP $DESTIP $SOURCEPORT $DESTPORT $CHAIN
			iptables -F $CHAIN
			iptables -X $CHAIN
		;;
		*)
			echo "evento sconosciuto $EVENTO"
		;;
	esac
done

function forwardjump() {
	iptables -$1 FORWARD -p tcp -s $2 -d $3 --sport $4 --dport $5 -j $6
	iptables -$1 FORWARD -p tcp -d $2 -s $3 --dport $4 --sport $5 -j $6
}

##########################-IPTABLES DEFAULT-#####################################

#data una coppia di indirizzi, un'interfaccia e una porta si abilitano le comunicazioni
#in entrambe le direzioni, entrambi i componenti sono sia server che client
function confTotallyBidir(){
	# confTotallyBidir interface ip1 ip2 port proto
    	# ip2 come server di ip1
	iptables -I INPUT -i $1 -s $2 -d $3 -p $5 --dport $4 -j ACCEPT
    	iptables -I OUTPUT -o $1 -d $2 -s $3 -p $5 --sport $4 -m state --state ESTABLISHED -j ACCEPT
	# ip2 come client di ip1
   	iptables -I INPUT -i $1 -s $2 -d $3 -p $5 --sport $4 -m state --state ESTABLISHED -j ACCEPT
    	iptables -I OUTPUT -o $1 -d $2 -s $3 -p $5 --dport $4 -j ACCEPT
    	# ip1 come server di ip2
  	iptables -I INPUT -i $1 -s $3 -d $2 -p $5 --dport $4 -j ACCEPT
    	iptables -I OUTPUT -o $1 -d $3 -s $2 -p $5 --sport $4 -m state --state ESTABLISHED -j ACCEPT
	# ip1 come client di ip2
   	iptables -I INPUT -i $1 -s $3 -d $2 -p $5 --sport $4 -m state --state ESTABLISHED -j ACCEPT
   	iptables -I OUTPUT -o $1 -d $3 -s $2 -p $5 --dport $4 -j ACCEPT
}

#data una coppia di indirizzi, un'interfaccia e una porta si abilitano le comunicazioni
#rendendo ip1 client di ip2, ip2 server di ip1
function confTotallyMono(){
	# confConnMono interface ip1 ip2 port
    	# ip2 come server di ip1
	iptables -I INPUT -i $1 -s $2 -d $3 -p tcp --dport $4 -j ACCEPT
    	iptables -I OUTPUT -o $1 -d $2 -s $3 -p tcp --sport $4 -m state --state ESTABLISHED -j ACCEPT
	# ip1 come client di ip2
   	iptables -I INPUT -i $1 -s $3 -d $2 -p tcp --sport $4 -m state --state ESTABLISHED -j ACCEPT
   	iptables -I OUTPUT -o $1 -d $3 -s $2 -p tcp --dport $4 -j ACCEPT
}

#data una coppia di indirizzi, un'interfaccia, una porta e un protocollo si abilitano le comunicazioni
#rendendo ip2 server di ip1
function confServer(){
	# confServer interface ip1 ip2 port proto
	iptables -I INPUT -i $1 -s $2 -d $3 -p $5 --dport $4 -j ACCEPT
    	iptables -I OUTPUT -o $1 -d $2 -s $3 -p $5 --sport $4 -m state --state ESTABLISHED -j ACCEPT
}

#data una coppia di indirizzi, un'interfaccia, una porta e un protocollo si abilitano le comunicazioni
#rendendo ip2 client di ip1
function confClient(){
	# confClient interface ip1 ip2 port proto
	iptables -I OUTPUT -i $1 -s $2 -d $3 -p $5 --dport $4 -j ACCEPT
    	iptables -I INPUT -o $1 -d $2 -s $3 -p $5 --sport $4 -m state --state ESTABLISHED -j ACCEPT
}

#scarto qualsiasi configurazione precedente
iptables -F INPUT
iptables -F OUTPUT
iptables -F FORWARD
#confTotallyBidir
confTotallyBidir eth1 10.9.9.254 10.9.9.253 22 tcp
confTotallyBidir eth2 10.1.1.254 10.1.1.253 22 tcp
confTotallyBidir eth3 192.168.56.254 192.168.56.253 22 tcp
confTotallyBidir eth3 192.168.56.254 192.168.56.253 389 tcp
# LDAP client-router (router server ldap)
confServer eth2 10.1.1.0/24 10.1.1.250 389 tcp
iptables -I INPUT -i eth2 -p tcp -s 10.1.1.0/24 -d 10.1.1.250 --dport 389 -j ACCEPT
iptables -I OUTPUT -o eth2 -p tcp -d 10.1.1.0/24 -s 10.1.1.250 --sport 389 -m state --state ESTABLISHED -j ACCEPT
# rsyslog client-router (log registrati su router)
confServer eth2 10.1.1.0/24 10.1.1.254 514 udp
iptables -I INPUT -i eth2 -p udp -s 10.1.1.0/24 -d 10.1.1.254 --dport 514 -j ACCEPT
iptables -I OUTPUT -o eth2 -p udp -d 10.1.1.0/24 -s 10.1.1.254 --sport 514 -m state --state ESTABLISHED -j ACCEPT
# SNMP router-client (demone snmp su client)
confClient eth2 10.1.1.254 10.1.1.0/24 161 udp
iptables -I OUTPUT -o eth2 -p udp -d 10.1.1.0/24 -s 10.1.1.254 --dport 161 -j ACCEPT
iptables -I INPUT -i eth2 -p udp -s 10.1.1.0/24 -d 10.1.1.254 --sport 161 -m state --state ESTABLISHED -j ACCEPT
# Accetta tutti i pacchetti dell'interfaccia di loopback
iptables -I INPUT -i lo -s 127.0.0.0/8 -j ACCEPT
iptables -I OUTPUT -o lo -d 127.0.0.0/8 -j ACCEPT
# Imposto policy di default
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Consenti le connessioni SSH ( in questo caso verso router ) PER DEBUG
iptables -I INPUT -i eth3 -s 192.168.56.1 -d 192.168.56.202 -p tcp --dport 22 -j ACCEPT
iptables -I OUTPUT -o eth3 -d 192.168.56.1 -s 192.168.56.202 -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT

##########################-IPTABLES2 DEFAULT-#####################################

#utile se ho ICMP oppure RANGE-IP

function setipparams() {
	# setta le variabili a seconda che ci sia un ip o un range
	# MOD per caricare eventualmente il modulo iprange
	# IPS e IPD sono sorgente e destinazione con l'opzione giusta
	if echo $1 | grep -q -- '-' ; then
		# se c'è un - è un range
		MOD="-m iprange"
		IPD="--dst-range $1"
		IPS="--src-range $1"
	else
		# se no è un ip singolo
		MOD=""
		IPD="-d $1"
		IPS="-s $1"
	fi
}

function setprotoparams() {
	# setta le variabili a seconda del protocollo (icmp, tcp o udp)
	# PROTO è sempre il protocollo
	# DP e SP sono sorgente e destinazione solo se non è icmp
	# sarebbe opportuno error checking, anche se invocata solo 
	# internamente da questo stesso script
	PROTO="-p $1"
	if test "$PROTO" = "-p icmp" ; then
		DP=""
		SP=""
	else
		DP="--dport $2"
		SP="--sport $2"
	fi
}

function client() {
	# imposta regole iptables quando io sono client
	# parametri: server proto porta 
	setipparams $3
	setprotoparams $4 $5
	iptables -I OUTPUT -o $1 $MOD $PROTO -s $2 $DP $IPD -j ACCEPT
	iptables -I INPUT -i $1 $MOD $PROTO -d $2 $SP $IPS --state ESTABLISHED -j ACCEPT
}

function server() {
	# imposta regole iptables quando io sono server
	# parametri: client proto porta 
	setipparams $3
	setprotoparams $4 $5
	iptables -I INPUT -i $1 $MOD $PROTO -d $2 $DP $IPS -j ACCEPT
	iptables -I OUTPUT -o $1 $MOD $PROTO -s $2 $SP $IPD --state ESTABLISHED -j ACCEPT
}

#Esempi d'uso
# sono server LDAP per i client (gw.sh)
server eth2 10.1.1.254 "10.1.1.1-10.1.1.200" tcp 389
# rispondo ai ping dei client (gw.sh)
server eth2 10.1.1.254 "10.1.1.1-10.1.1.200" icmp
# sono client SSH verso i client (check.sh e reset.sh)
client eth2 10.1.1.254 "10.1.1.1-10.1.1.200" tcp 22
# sono client e server SSH per l'altro router (check.sh e reset.sh)
client eth2 10.1.1.254 10.1.1.253 tcp 22
server eth2 10.1.1.254 10.1.1.253 tcp 22
# sono client e server SYSLOG per l'altro router (check.sh)
client eth2 10.1.1.254 10.1.1.253 udp 514
server eth2 10.1.1.254 10.1.1.253 udp 514
# sono client e server LDAP per l'altro router (init.sh)
client eth2 10.1.1.254 10.1.1.253 tcp 389
server eth2 10.1.1.254 10.1.1.253 tcp 389
# sono client i server SNMP per l'altro router (init.sh)
client eth2 10.1.1.254 10.1.1.253 udp 161
server eth2 10.1.1.254 10.1.1.253 udp 161

##########################-IPTABLES NAT-#########################################

# Visualizza le configurazioni di iptables (tabella nat)
iptables -t nat -vnL
# Visualizza una singola chain
iptables -t nat -L <chain>
#chain: POSTROUTING, PREROUTING, OUTPUT
#Policy:
#MASQUERADE: conversione implicita nell’indirizzo IP assegnato all’interfaccia di uscita.
#ACCEPT: No conversione.
#SNAT --to-source <addr> (chain POSTROUTING) 
#DNAT --to-destination <addr> (chain PREROUTING) 
#con <addr>=<address>|<address>:<port>
#<options> uguali a tabella filter
# Aggiungo una regola in coda ( APPEND ) 
iptables -t nat -A <chain> <options> -j <policy>
# Aggiungo una regola all'inizio della coda ( INSERT )
iptables -t nat -I <chain> <options> -j <policy>
# Rimuovo una regola ( DELETE )
iptables -t nat -D <chain> <options> -j <policy>

#Esempi:
# Intercetta le connessioni SSH da Client a Router e le ridirige a Server
iptables -t nat -A PREROUTING -i eth2 -s 10.1.1.1 -d 10.1.1.254 -p tcp --dport 22 -j DNAT --to-dest 10.9.9.1
# Espone le connessioni dal Client al Server come se venissero dal Router stesso
iptables -t nat -A POSTROUTING -o eth1 -s 10.1.1.1 -d 10.9.9.1 -j SNAT --to-source 10.9.9.254

##########################-IPTABLES CHAIN/STORE-#####################################

# Crea la chain PIPPO
iptables -N PIPPO
# Inserisco una regola all'interno di PIPPO che faccia direttamente il RETURN (ovvero ritorni alla chain che l'ha invocata)
iptables -I PIPPO -j RETURN
# Elimino tutte le regole all'interno di PIPPO ( FLUSH )
iptables -F PIPPO
# Elimino la chain PIPPO
iptables -X PIPPO

# Salva la configurazione corrente sul file
iptables-save > /tmp/output
# Ripristina la configurazione salvata
iptables-restore < /tmp/output

############################-CRON-###################################################

#PERCORSI ASSOLUTI!
#Esegue il comando ogni 5 minuti
# */5 * * * * /root/traffic.sh
#Esegue il comando da lun a ven alle 22
# 00 22 * * 1-5 /root/traffic.sh
#Esegue il comando alle 5 e alle 17 delle domeniche e dei venerdi di gennaio, maggio e agosto
# 00 5,17 * jan,may,aug sun,fri /root/traffic.sh
#Esegui un job la prima domenica di ogni mese
#0 2 * * sun [ $(date +% d) -le 07 ] && /root/traffic.sh
#Esegui ogni 30 secondi
#* * * * * /root/traffic.sh
#* * * * * sleep 30; /root/traffic.sh
#Esegui piu' di un job
#* * * * * /root/traffic.sh ; /root/script.sh
#Esegui ogni smt=yearly,monthly,weekly,daily,hourly,reboot
#@smt /root/traffic.sh


# configuro cron per l'esecuzione come root, apro l'editor predefinito con crontab -e ed inserisco la linea "*/5 * * * * /root/traffic.sh" in modo da eseguire lo script ogni 5 minuti

# Se volessi invece configurare lo script per venire eseguito ogni minuto scrivo:
# "* * * * * /root/runas.sh"

# Se voglio configuratre che un certo script venga eseguito ogni tot minuto uso crontab -e, e come standard input
# ho la stringa con la configurazione della frequenza nel seguente formato:

# */$1 * * * *
# dove (da sinistra a destra):
# Primo asterisco: minuto
# Secondo asterisco: ora
# Terzo asterisco: giorno del mese
# Quarto asterisco: mese
# Quinto asterisco: giorno della settimana (0: domenica, 6 sabato)

# Viene eseguito ogni minuto
echo '*/$1 * * * * /root/script.sh' | crontab -e 

# configuro cron per l'esecuzione tramite script, eseguendo i seguenti comandi
CRONCMD="/root/watch.sh $1 $3 $4"
crontab -l | grep -v "$CRONCMD" > /tmp/crontab$$
echo "*/3 * * * * $CRONCMD" >> /tmp/crontab$$
crontab /tmp/crontab$$
rm -f /tmp/crontab$$

#edito cron altro utente
crontab -u username -e
#verifico chi ha invocato cron
if /usr/bin/tty > /dev/null ; then
	# invocato da terminale, controllo parametri
else
	# Invocato da cron
fi

# controllare che crontab stia funzionando
sudo crontab -l -u $UTENTE

# editare crontab manualmente
sudo crontab -e

# controllare che stia funzionando
systemctl status cron
sudo systemctl is-active cron
pgrep cron
sudo journalctl -u cron
sudo tail -f /var/log/syslog | grep CRON

############################-TCPDUMP-###################################################

#Opzioni:
-i any #Ascolta da tutte le interfacce di rete
-i eth0 #Ascolta sull ’ interfaccia eth0
-l #IMPORTANTE Line - buffered : Stampa un pacchetto appena lo riceve senza bufferizzare
-n #IMPORTANTE Non risolvere gli hostname , lascia numerico
-t #Stampa il tempo in un formato human - friendly
-c [N] #Legge solo N pacchetti e poi termina
-w output #Scrive i pacchetti nel file PCAP di output
-r output #Legge i pacchetti dal file PCAP
-p #No promiscuous mode
-A #Stampa i pacchetti in ASCII
-X #Stampa i pacchetti in ASCII ed esadecimale

#tcpdump attende $SOGLIA pacchetti tra i due host con udp
tcpdump -vnl -i eth2 -c $SOGLIA src host $SIP and dst host $DIP and src port $SP and dst port $DP and udp > /dev/null 2>&1
#combinazioni
tcpdump src 10.9.9.1 and (dst port 1234 or 22) and not src port 12345

#tcpdump traccia i pacchetti fin tra le due net
#Output CON -v e CON 2>/dev/null
#tcpdump: listening on eth1, link-type EN10MB (Ethernet), capture size 262144 bytes
#11:39:39.398845 IP (tos 0x10, ttl 64, id 64019, offset 0, flags [DF], proto TCP (6), length 52)
#    10.9.9.1.46286 > 10.1.1.1.22: Flags [F.], cksum 0x9551 (correct), seq 3935713374, ack 2875122919, win 1091, options [nop,nop,TS val 1302060 ecr 4294932668], length 0
tcpdump -vlnp -i eth3 'tcp[tcpflags] & tcp-fin != 0 and src net 10.9.9.0/24 and dst net 10.1.1.0/24' 2>/dev/null

#tcpdump traccia i pacchetti fin tra i due host
#Output SENZA -v e CON 2>/dev/null, port specificata (valido anche per net)
#11:30:38.763502 IP 192.168.56.1.39010 > 192.168.56.202.22: Flags [F.], seq 2819887278, ack 1156069010, win 311, options [nop,nop,TS val 1218725399 ecr 2117893], length 0
tcpdump -vlnp -i eth3 'tcp[tcpflags] & tcp-fin != 0 and src host 192.168.56.1 and dst host 192.168.56.202 and dst port 22'


# osserva continuamente il traffico da Client a Server, e per ogni pacchetto syslog in transito  
# - Estrae l'id univoco
# - Pianifica l'esecuzione di transfer.sh dopo 3 minuti

# tcpdump a differenza di iptables LOG accede al payload
# e' sufficiente il verbose perche' sa decodificare syslog
# in altri casi potrebbe servire -A per fare il dump in ASCII dell'intero pacchetto
# e attenzione che di default cattura 68 bytes, se non bastano, usare -s 0

# 16:38:59.883820 IP (tos 0x0, ttl 64, id 16130, offset 0, flags [DF], proto UDP (17), length 152)
#    10.1.1.1:53926 > 10.9.9.1.514: SYSLOG, length: 124
#	    Facility user (1), Severity notice (5)
#	    Msg: 1 2020-06-25T16:38:59.883736+02:00 Client las - - [timeQuality tzKnown="1" isSynced="1" syncAccuracy="389500"] exec_PROGRAMMA_4324310.1.1.1_

tcpdump -vnlp -i eth2 'udp port 514 and src host 10.1.1.1 and dst host 10.9.9.1' |
grep --line-buffered exec_ | 
awk -F _ -W interactive '{ print $3 }' | 
while read SU; do 
    echo "/root/transfer.sh $SU" | at now + 3 minutes 
done

# tcpdump monitora unicamente il traffico via ssh
tcpdump -i eth1 tcp port 22

############################-TCPDUMP LOG-###################################################

#logging in background di inizio e fine connessioni tcp tra le due net
( tcpdump -lnp -i eth2 'tcp[tcpflags] & (tcp-syn|tcp-fin) != 0 and src net 10.1.1.0/24 and dst net 10.9.9.0/24' 2>/dev/null | logger -p local0.info ) &

# log format:
# Mar 28 11:41:17 Router logger: 11:41:17.574430 IP 10.1.1.1.52356 > 10.9.9.1.22: S 3572751694:3572751694(0) win 5840 <mss 1460,sackOK,timestamp 2110393 0,nop,wscale 1>

tail --pid=$$ -f /var/log/newconn | while read M G H HOST PROC TS PROTO SRC DIR DST FLAG OTHER ; do

    case "$FLAG" in
        S)  if test -f /var/run/traffic_monitor_${SRC}_${DST}.pid
            then
                echo connessione $SRC $DST gia monitorata
            else
                SIP=$(echo $SRC | cut -f-4 -d.)
                DIP=$(echo $DST | cut -f-4 -d.)
                SP=$(echo $SRC | cut -f5 -d.)
                DP=$(echo $DST | cut -f5 -d. | sed -e 's/://')
                /root/traffic_monitor.sh $SIP $DIP $SP $DP &
                echo $! > /var/run/traffic_monitor_${SRC}_${DST}.pid
                echo avvio monitoraggio connessione $SRC $DST
            fi
            ;;
        F)  if test -f /var/run/traffic_monitor_${SRC}_${DST}.pid
            then
                echo arresto monitoraggio connessione $SRC $DST
		kill $(cat /var/run/traffic_monitor_${SRC}_${DST}.pid)
                rm -f "/var/run/traffic_monitor_${SRC}_${DST}.pid"
            else
                echo processo di monitoring di $SRC $DST non trovato
            fi
            ;;
        *)  echo "$FLAG" non valido
            ;;
    esac
done

############################-CHIUDI CONNESSIONI SU HOST REMOTO-###################################################
############################- Esempio di utilizzo ss in remoto-###################################################

# si collega al client e termina tutti i processi che stanno utilizzando socket di rete

function segnala_client(){
	# l'output di ss può essere di questo tipo:
	# tcp ESTAB 0 0 127.0.0.1:ssh 127.0.0.1:37012 users:(("sshd",pid=10610,fd=3),("sshd",pid=10516,fd=3))
	# prima converto le virgole in a capo, poi seleziono i pid
        ssh root@$1 "ss -ptu | sed -e 's/,/\n/g' | grep pid= | sed -e 's/pid=//' | xargs kill -9"
}

############################-RICONOSCO VERIFICARSI EVENTO 10 VOLTE IN 2 MIN-###################################################

# Questo script esamina continuamente il file /var/log/orphans.log. 
# Per ogni riga che legge, determina se l'IP client in essa contenuto
# è stato osservato più di 10 volte nei due minuti precedenti.

#Jun 16 16:27:43 Router kernel: [14225.975606] check_10.1.1.1 IN=eth2 OUT= MAC=08:00:27:0b:37:1f:08:00:27:72:c7:c1:08:00 SRC=10.1.1.1 DST=10.1.1.254 LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=3814 DF PROTO=ICMP TYPE=8 CODE=0 ID=990 SEQ=1 
tail -f /var/log/orphans.log | grep --line-buffered " check_" | while read riga ; do
	# check.sh marca le righe con la stringa check_INDIRIZZO, quindi		
        IP=$(echo $riga | awk -F 'check_' '{ print $2 }' | awk '{ print $1 }')

	# ricavo il timestamp e lo converto in secondi dall'1/1/70
	TS=$(echo $riga | awk '{ print $1,$2,$3 }')
	TS=$(date -D "$TS" +%s)

	# implemento su file un buffer circolare nel quale tenere 
	# gli ultimi 10 timestamp relativi all'indirizzo letto:
	# "dimentico" la riga più vecchia e accodo la più recente
	if test -f /tmp/buffer_$IP ; then
		tail -9 /tmp/buffer_$IP > /tmp/new_buffer_$IP
	else
		echo "0" > /tmp/new_buffer_$IP
	fi
	echo $TS >> /tmp/new_buffer_$IP
	mv /tmp/new_buffer_$IP /tmp/buffer_$IP

	# se ci sono almeno 10 righe...
	if $(wc -l /tmp/buffer_$IP | awk '{ print $1 }') -ge 10 ; then
  	   # leggo il timestamp più vecchio, se è entro i 2 minuti
	   # lo sono anche tutti gli altri --> ho superato la soglia
	   FIRSTTS=$(head -1 /tmp/buffer_$IP)
           if test $(( $TS - $FIRSTTS )) -lt 120 ; then
		#esegui operazioni per evento                
		#segnala_client $IP
                #rimuovi_regole $IP INPUT
                #rimuovi_regole $IP FORWARD
                #rimuovi_regole $IP OUTPUT
           fi
	fi
done

#################################-SERVER CON PIÙ MEMORIA TRA 10 DISPONIBILI-###################################
# Funzione che trova il server con più memoria tra 10 disponibili.
# Range IP server: [10.9.9.1 ... 10.9.9.10]

function freeserver() {
    # creo temporaneamente una directory sicura 
	D=$(mktemp -d)
	cd $D || { echo unexpected error ; exit 2 ; }
    
    # creo un array associativo.
    # Un array associativo funziona come una mappa
    # Quindi si avrà, in questo caso qualcosa come:
    
    # 10.9.9.1      1345
    # 10.9.9.2      1346
    # .
    # .
    # .
    # 10.9.9.10     1564
    
	declare -A P
	for i in 10.9.9.{1..10} ; do 

	# Trovo il server con più memoria non utilizzata (indicata dalla colonna free)
	# Memorizzo sulla macchina locale il valore della memoria non utilizzata in un file che ha come nome
	# l'ip del server considerato.
	# In background (sulla macchina locale) ho il processo che associa per ciascun file il pid del processo in background più recente. Il processo in questione avrà il pid del comando ssh.
		ssh -n $i "free | grep Mem | awk '{ print $4 }'" > $i & P[$i]=$!
	done
	# Dopo 10 secondi termino i processo che cerca server con maggiore memoria disponibile
	sleep 10
	kill ${P[*]} 2>/dev/null
	
	# Stampo l'ip del server con maggiore memoria disponibile
	for i in * ; do 
		echo -n "$i "
		cat $i
	done | sort -k2nr | head -1 | awk '{ print $1 }'
	cd ..
	# Rimuovo la directory temporanea
	rm -rf $D
}

############################-ATTENDO UN PING MAX 10 SECONDI-###################################################

count=0
while ! ping -c1 -w1 10.1.1.254 > /dev/null 2>&1
do
        echo "In attesa che RF risponda..."
        if test "$count" -gt 9 
        then
                echo "Il router non risponde"
                exit 5
        fi
        count=$(( "$count" + 1 ))
done

echo "Ha risposto connessione avviata con $1"

############################-ATTENDO UN PING MAX 3 SECONDI-###################################################

#eseguo operazione se falliscono 3 ping consecutivi
FAILPING="0"
while sleep 1 ; do
        if ping -c 1 -W 1 10.1.1.254 > /dev/null 2>&1 ; then
		FAILPING=0
	else		
                FAILPING=$(( $FAILPING + 1 ))
                if test $FAILPING -ge 3 ; then
                        echo qui faccio una operazione
                        FAILPING="0"
                fi
        fi
done

############################-BACKGROUND FOREGROUND-###################################################

# Avvia il comando in background
gedit &
# Mandare SIGSTOP a processo (CTRL+Z) per stopparlo
# [1]+  Fermato                 top
# poi bg <job_id> lo si manda in background
# Riporta il processo con il jobid specificato in foreground
fg <job_id>
# Elenca tutti i jobs con il loro stato.
jobs
# Esegue il comando in background e lo
# Rende immune alla chiusura della shell
nohup <command> &

############################-UTENTI GRUPPI-###################################################

#contiene il nome dell utente
$USER	
#id utente
$EUID	
#PERMESSI ROOT
# Aggiungi un utente al sistema
adduser <nomeutente>
# Se non esiste gia', bisogna creare il gruppo
addgroup <nomegruppo>
# A questo punto possiamo creare un nuovo utente ed aggiungerlo al gruppo
adduser --ingroup <nomegruppo> <nomeutente>
# Creo un utente senza home directory e senza password valida, appartenente a un gruppo specificato
adduser --ingroup --no-create-home --disabled-password <nome gruppo> <nome utente>
#Per aggiungere un utente ad un gruppo secondario, si può utilizzare il comando usermod in questo modo:
usermod -a -G <nomegruppo> <nomeutente>
#Cambiare il gruppo primario di un utente
usermod -g <nomegruppo> <nomeutente>
# Visualizzo le info dell ’ utente corrente
id
# Visualizzo le info di un utente specifico
id <nomeutente>
# Elenco i gruppi dell ’ utente corrente
groups
# Elenco i gruppi di un utente specifico
groups <nomeutente>
# Stampa l ’ elenco di tutti i gruppi del sistema
getent group
# Cambia la password dell ’ utente corrente
passwd
# Cambia la password di un utente specifico
# NOTA : Necessari i permessi di root
#Utilizzando rispettivamente le opzioni -l e -u è possibile settare un account in stato di lock o unlock.
Solo root può farlo.
passwd <nomeutente>
# Stampa l ’ username dell ’ utente corrente
whoami
# Elenca gli utenti correntemente collegati alla macchina
who

# SU -c
# Fa eseguire un comando ad un altro utente
# lancio programma a nome di un altro utente
su -c 'cat .ssh/id_rsa.pub' - username
# genera per un utente una coppia di chiavi SSH di tipo RSA
su -c 'ssh-keygen -t rsa -b 2048 -P ""' - "nomeutente" 
############################-PERMESSI-###################################################

# Diamo a tutti il permesso di lettura
chmod a=r <nomefile>
# Aggiungiamo il permesso di scrittura ed esecuzione al proprietario
chmod u+wx <nomefile>
# Rimuoviamo i permessi di scrittura al gruppo proprietario
chmod g-w <nomefile>
# E ’ anche possibile utilizzare il formato numerico
chmod 0777 <nomefile>
# Cambia l ’ utente proprietario di un file
chown <username> <nomefile>
# Cambia il gruppo proprietario di un file
# NOTA : Attenzione ad aggiungere :
chown :<group> <nomefile>
# Cambia l ’ utente ed il gruppo proprietario
chown <username>:<group> <nomefile>
# Cambia la proprieta di tutti i file contenuti nella directory
# in maniera RICORSIVA
chown -R <username>: <group> <nomedirectory>
# Cambiare la proprietà dei file di una directory
# in modo che appartenga a un gruppo specificato
chgrp -R <group> <dirname>

# Visualizza la umask corrente
umask
# Per visualizzare i permessi a default correnti in maniera
# piu ’ comprensibile , si puo ’ usare l ’ opzione -S
umask -S
# Imposta la maschera in modo che i nuovi file abbiano permesso 775
umask 0002
# L’impostazione della umask è valida solo per la sessione di shell corrente. Per fare in modo che l’impostazione sia persistente, bisogna aggiungere il comando umask al file /etc/bash.bashrc

############################-ALTRO ROUTER-###################################################

ROUTER1="10.1.1.253"
ROUTER2="10.1.1.254"

function altro_router(){
        ATTUALE=$1
        if test $ATTUALE = $ROUTER1
                echo $ROUTER2
        else
                echo $ROUTER1
        fi
}

##MAIN

ATTUALE=$(ifconfig eth2 | grep "inet addr" | awk -F 'addr:' '{ print $2 }' | cut -f1 -d" ")
ALTRO=$(altro_router $ATTUALE)

############################-ESEGUI SEMPRE-###################################################

#  deve essere permanentemente in esecuzione su entrambi i router (specificare nei commenti come si può ottenere che questo avvenga fin dal boot)
# inserire in /etc/inittab
# pi:2345:respawn:/root/ping.sh

############################-CONTARE TRAFFICO CON CATENA-###################################################

# funzione che abilita il traffico per uno specifico client i parametri sono $1: indirizzo cliente $2: inserimento o cancellazione regole
function set_rules() {
	if [ "$2" = "open"] ; then

		# Apro la connessione inserendo una catena per contare il traffico
		iptables -N "C_$1" 
		iptables -I "C_$1" -j ACCEPT

		iptables -I FORWARD -i eth3 -s "$1" -j "C_$1"
		iptables -I FORWARD -o eth3 -d "$1" -j "C_$1"

	elif [ "$2" = "close" ] ; then 

		# Rimuovo la connessione
		iptables -D FORWARD -i eth3 -s "$1" -j "C_$1"
		iptables -D FORWARD -o eth3 -d "$1" -j "C_$1"

		iptables -F "C_$1" 
		iptables -X "C_$1"
		
	fi
}

##MAIN##

DIMENSIONE=$(iptables -Z -vxnL C_$SOURCE | grep ACCEPT | awk '{ print $2 }' 2>/dev/null)
#se regola non gia' inserita
if [ -z "$DIMENSIONE" ] ; then
	set_rules $SOURCE open
	DIMENSIONE=0
else
	# aggiorno la dir di LDAP
	DIMENSIONE=$(($DIMENSIONE + $TRAFFICO))
	(echo "dn: utente=$UTENTE,dc=labammsis"
	 echo "changetype: modify"
	 echo "replace: traffico"
	 echo "traffico: $DIMENSIONE") 
	| ldapmodify -x -c -h 192.168.56.202 -w las -D "cn=admin,dc=laboratorio" 
fi

############################-ESEGUIRE IN PARALLELO-###################################################

#MEGLIO CON PATH ASSOLUTI

function is_default(){
	# segnalo che sta girando il verificatore
	touch running_$1
        ssh root@$1 "ip route" | grep -q "default via $ROUTER" || touch $1 
	rm -f running_$1
}

##MAIN##

rm -rf /tmp/check$$
mkdir /tmp/check$$
cd /tmp/check$$

ldapsearch -h 127.0.0.1 -x -b 'dc=labammsis' "(&(objectClass=gw)(iprouter=$ROUTER))" -s one ipclient | grep "^ipclient:" | awk '{ print $2 }' | while read IP ; do
	# lancio tutti i verificatori di coerenza in parallelo
        is_default $IP &
	# crea un file in /tmp/check$$ per ogni client con routing incoerente
done


# attendo la fine di tutti i verificatori
while ls running* ; do sleep 1 ; done > /dev/null 2>&1

# Per ogni client su cui è configurato un default gateway incoerente 
# con quello memorizzato in LDAP ...
for CLIENT in * ; do
	imposta_regole $CLIENT
done

############################-PROCESSI DEMONI-###################################################

ls /etc/init.d

acpid			checkroot.sh   kbd	       motd		      nfs-common	 reboot     slapd	 umountnfs.sh
anacron			console-setup  keyboard-setup  mountall-bootclean.sh  nfs-kernel-server  rmnologin  snmpd	 umountroot
atd			cron	       killprocs       mountall.sh	      openvpn		 rpcbind    ssh		 urandom
bluetooth		dbus	       kmod	       mountdevsubfs.sh       procps		 rsyslog    sudo	 x11-common
bootlogs		exim4	       lvm2	       mountkernfs.sh	      rc		 saned	    sysstat
bootmisc.sh		halt	       mdadm	       mountnfs-bootclean.sh  rc.local		 sendsigs   udev
checkfs.sh		hostname.sh    mdadm-raid      mountnfs.sh	      rcS		 single     udev-finish
checkroot-bootclean.sh	hwclock.sh     mdadm-waitidle  networking	      README		 skeleton   umountfs


#####################################-KNOWN-PORTS-##############################################

# porta ssh: 22 (TCP)
# porta LDAP: 389 (TCP), connessione cifrata: 636 (TCP)
# porta syslog: 514 (UDP)
# porta SNMP: 161 (UDP)

# Per maggiori informazioni sulle porte disponibili eseguire il seguente comando:

sudo cat /etc/services | grep <nome-comando>

#####################################-HOSTNAME-##################################################
# Ricavare l'ip di una particolare N-esima interfaccia
hostname -I | awk '{print $N}'

####################################-SEGNALI-###################################################
# attende la terminazione
sleep 40 &
wait

# osserva ogni 2 secondi i job
watch "ps auxw | grep sleep | grep -v grep"



######################################-NMAP-####################################################

# nmap
nmap -p 1700 router.eu.thethings.network

#####################################-NETCAT-###################################################

# Comando netcat (nc)

# Use IPv4 only
nc -4
# Use IPv6
nc -6
# Use UDP instead of TCP
nc -u
# Continue listening after disconnection
nc -k -l 
# Skip DNS lookups
nc -n
# Provide verbose output
nc -v
# Restituisce le porte in ascolto e il loro stato
nc -z -v <nome server o indirizzo ip>
# Scan a single port
nc -zv 10.9.9.1 80
# Scan a set of individual ports
nc -zv 10.9.9.1 80 84
# scan a range of ports
nc -zv 10.9.9.1 80-84
# Avvia una shell su Linux
nc -l -p [porta] -e /bin/bash
# Controllo se un indirizzo IP è raggiungibile entro 3 secondi
# dove:
# w è il timeout
# fare echo $? per vedere il risultato
nc -w 3 -z indirizzoIP

# Si può anche mandare un file da un server a un client.
# Basta avere due processi, uno sul client e uno sul server.

# Quello sul server può essere questo:
nc -l 1499 > filename.out

# Sul client occorre utilizzare questo comando:
nc server.com 1499 > filename.in

# Verifico se una porta di un server è in ascolto
if nc -z 10.9.9.1 22 ; then
    echo "Porta in ascolto"
else
    echo "Porta non in ascolto"
fi

#####################################-OPENVPN-#################################################

# Per generare una chiave segreta per comunicare con un host remoto
openvpn --genkey --secret nomechiavesegreta.key

##################################-Random-numbers-###############################################

# Come generare numeri o stringhe casuali di N caratteri
# bash generate random alphanumeric string
# Generare un numero compreso tra 5 e 100 (inclusi)
shuf -i 5-100 -n 1

# bash generate random 32 character alphanumeric string (upper and lowercase) and 
# n is the number of generated alphanumeric string with 32 characters
NEW_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# bash generate random 32 character alphanumeric string (lowercase only)
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1

# Random numbers in a range, more randomly distributed than $RANDOM which is not
# very random in terms of distribution of numbers.

# bash generate random number between 0 and 9
cat /dev/urandom | tr -dc '0-9' | fold -w 256 | head -n 1 | head --bytes 1

# bash generate random number between 0 and 99
NUMBER=$(cat /dev/urandom | tr -dc '0-9' | fold -w 256 | head -n 1 | sed -e 's/^0*//' | head --bytes 2)
if [ "$NUMBER" == "" ]; then
  NUMBER=0
fi

# bash generate random number between 0 and 999
NUMBER=$(cat /dev/urandom | tr -dc '0-9' | fold -w 256 | head -n 1 | sed -e 's/^0*//' | head --bytes 3)
if [ "$NUMBER" == "" ]; then
  NUMBER=0
fi
#############################-GENERAL UTILS-##########################################

# creare un file temporaneo 
# --tmpdir[=DIR] : permette di specificare una directory destinazione per il file temporaneo, se il parametro DIR
# non viene specificato , usa $TMPDIR altrimenti /tmp
# I caratteri 'XXXX' specificati verranno sostituiti in automatico con una combinazione univoca alfanumerica
mktemp [-p directory] XXXXXX.txt

# Here-document
cat <<-EOF > $output_file
text_line_1
text_line_2
text_line_3
text_line_4
EOF

# Timer
seconds_from_now=60
time_limit=$(( $(date +%s) + $seconds_from_now ))
while [ $(date +%s) -lt $time_limit -a etc]; do

# Random number
for i in {1..16}; do N=$N$(( $RANDOM % 10)); echo $N ;done

# ##############################-PARAMETER EXPASION-####################################

# {parameter:offset:length}
string="01234567890abcdefgh"
echo ${string:7}
# 7890abcdefgh
echo ${string:7:0}
#
echo ${string:7:2}
# 78
echo ${string:7:-2}
# 7890abcdef
echo ${string: -7}
# bcdefgh
echo ${string: -7:0}
# 
echo ${string: -7:2}
# bc
echo ${string: -7:-2}
# bcdef 
