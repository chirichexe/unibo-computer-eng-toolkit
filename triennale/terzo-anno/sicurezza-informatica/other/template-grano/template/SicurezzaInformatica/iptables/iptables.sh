#Macchina client : 10.1.1.1
#Macchina router1 : 10.1.1.254 (eth1)
#Macchina router1 : 10.9.9.1 (eth2)
#Macchina router2 : 10.9.9.2 (eth1)
#Macchina router2 : 10.2.2.254 (eth2)
#Macchina server : 10.2.2.1 (eth1)


#Router1 deve inoltrare il traffico dalla rete dei client a quella dei server
iptables -F INPUT
iptables -F OUTPUT
iptables -F FORWARD
#Consentiamo il traffico in entrambe le direzioni
iptables -A FORWARD -s 10.1.1.1 -d 10.2.2.1 -j ACCEPT
iptables -A FORWARD -s 10.2.2.1 -d 10.1.1.1 -j ACCEPT 

#Impostiamo la policy di default
iptables -P FORWARD DROP

#Consentiamo il passaggio di traffico ssh (porta 22) dalla rete dei client a quella dei server
iptables -A FORWARD -p tcp --dport 22 -s 10.1.1.1 -d 10.3.3.1 -j ACCEPT
iptables -A FORWARD -p tcp --sport 22 -m state --state ESTABLISHED -s 10.3.3.1 -d 10.1.1.1 -j ACCEPT


#---------------------------CONCEDIAMO SONO A CLIENT LA CONNESSIONE SSH VERSO IL SERVER---------------------------
#CLIENT
iptables -A OUTPUT -p tcp --dport 22 -s 10.1.1.1 -d 10.3.3.1 -o eth1 -j ACCEPT
iptables -A INPUT -p tcp --sport 22 -m state --state ESTABLISHED -s 10.3.3.1 -d 10.1.1.1 -i eth1 -j ACCEPT
#R1
iptables -A FORWARD -p tcp --dport 22 -s 10.1.1.1 -d 10.3.3.1 -i eth1 -o eth2 -j ACCEPT
iptables -A FORWARD -p tcp --sport 22 -m state --state ESTABLISHED -s 10.3.3.1 -d 10.1.1.1 -i eth2 -o eth1 -j ACCEPT
#R2
iptables -A FORWARD -p tcp --dport 22 -s 10.1.1.1 -d 10.3.3.1 -i eth2 -o eth1 -j ACCEPT
iptables -A FORWARD -p tcp --sport 22 -m state --state ESTABLISHED -s 10.3.3.1 -d 10.1.1.1 -i eth1 -o eth2 -j ACCEPT
#SERVER
iptables -A INPUT -p tcp --sport 22 -s 10.1.1.1 -d 10.3.3.1 -i eth1 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 22 -m state --state ESTABLISHED -s 10.3.3.1 -d 10.1.1.1 -o eth1 -j ACCEPT

