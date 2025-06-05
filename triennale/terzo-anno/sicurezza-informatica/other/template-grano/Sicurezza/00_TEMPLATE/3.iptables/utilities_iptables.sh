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