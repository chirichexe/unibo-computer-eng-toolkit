IP=10.1.1.1

# =============================================================================================
# Consentire all'utente Debian-snmp di eseguire comandi con sudo senza password:
#
# sudo -i
# echo "Debian-snmp ALL=NOPASSWD:/usr/bin/ss -lntp" >> visudo

# =============================================================================================
# Da aggiungere su etc/snmp/snmpd.conf:
#
# extend-sh [NOME-COMANDO-SUDO]    /usr/bin/sudo /usr/bin/ss -lntp | egrep '0\.0\.0\.0:22.*sshd' 

# =============================================================================================
# Per associare un OID a un comando custom su un agent SNMP:
# extend .1.3.6.1.4.1.2021.51 myscript1 /usr/local/bin/script1.sh

# =============================================================================================

snmpget -v 1 -c public "$IP" NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"createdump\"

snmpget -v 1 -c public "$IP" NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"deletedump\"

# per navigare un intero sottoalbero del MIB
snmpwalk -On -v 1 -c public $IP_SERVER .1.3.6.1.2.1.1
snmpset -v 1 -c supercom $IP_SERVER   .1.3.6.1.2.1.1.6.0   s   "proprio qui"

# =============================================================================================
# Monitorare sistema con SNMP (righe da mettere su etc/snmp/snmpd.conf)

# load [max-1] [max-5] [max-15]
# tabella .1.3.6.1.4.1.2021.10
# tre righe (carico negli ultimi 1-5-15 minuti)
# colonne: carico effettivo, flag di superamento delle rispettive soglie
# load [max-1] [max-5] [max-15]

load 1.0 0.5 0.2

# disk [partizione] [minfree|minfree%]
# tabella .1.3.6.1.4.1.2021.9
# una riga per ogni partizione messa sotto controllo da una direttiva disk
# colonne: tutti i dettagli della partizione e flag di spazio sotto il minimo

disk / 100000         # Alert se meno di 100000 KB disponibili
disk /home 5%         # Alert se meno del 5% di spazio libero

# proc [nomeprocesso] [maxnum [minnum]]
# tabella .1.3.6.1.4.1.2021.2
# una riga per ogni processo messo sotto controllo da una direttiva proc
# colonne: numero di istanze, flag di superamento delle soglie

proc sshd 5 1         # Alert se sshd ha meno di 1 o più di 5 istanze
proc systemd
