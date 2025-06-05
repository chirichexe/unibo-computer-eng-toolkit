#--------------------------------------CLIENT--------------------------------------
iptables -F INPUT
iptables -F OUTPUT
iptables -F FORWARD

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

#1. Accesso da parte dei client con IMAP/S a mail server su internet (porta TCP 993)
iptables -A OUTPUT -p tcp --dport 993 -s 172.20.0.0/20 -o eth1 -j ACCEPT
iptables -A INPUT -p udp --sport 993 -d 172.20.0.0/20 -i eth1 -m state --state ESTABLISHED -j ACCEPT

#3. Accesso da parte dei client alla porta UDP 53 del router
iptables -A OUTPUT -p udp --dport 53 -s 172.20.0.0/20 -d 172.20.15.254 -o eth1 -j ACCEPT
iptables -A INPUT -p udp --sport 53 -d 172.20.0.0/20 -s 172.20.15.254 -i eth1 -m state --state ESTABLISHED -j ACCEPT

#4. Accesso da parte del server agli agent SNMP dei client (porta UDP 161)
iptables -A INPUT -p udp --dport 161 -s 1.1.1.14 -d 172.20.0.0/20 -i eth1  -j ACCEPT
iptables -A OUTPUT -p tcp --dport 161 -s 172.20.0.0/20 -d 1.1.1.14 -o eth1 -m state --state ESTABLISHED -j ACCEPT

iptables -P INPUT DROP #Imposto la policy di default per il traffico in ingresso
iptables -P OUTPUT DROP #Imposto la policy di default per il traffico in uscita
iptables -P FORWARD DROP #Imposto la policy di default per


#--------------------------------------ROUTER--------------------------------------
iptables -t nat -F
iptables -F INPUT
iptables -F OUTPUT
iptables -F FORWARD

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT


#1. Accesso da parte dei client con IMAP/S a mail server su internet (porta TCP 993)
iptables -A FORWARD -p tcp --dport 993 -s 172.20.0.0/20 -i eth1 -o eth3 -j ACCEPT
iptables -A FORWARD -p tcp --sport 993 -m state --state ESTABLISHED -d 172.20.0.0/20 -i eth3 -o eth1 -j ACCEPT
iptables -t nat -A POSTROUTING -i eth1 -o eth3 -s 172.20.0.0/20 -p tcp --dport 993 -j SNAT --to-source 137.204.1.15

#2. Accesso da parte di qualsiasi host su internet alla porta TCP 443 del Server
#iptables -t nat -A POSTROUTING -i eth1 -o eth3 -s 172.20.0.0/20 -p tcp --dport 993 -j SNAT --to-source 137.204.1.15

iptables -A FORWARD -p tcp --dport 443 -d 1.1.1.14 -i eth3 -o eth2 -j ACCEPT
iptables -A FORWARD -p tcp --sport 443 -m state --state ESTABLISHED -s -d 1.1.1.14 -i eth2 -o eth3 -j ACCEPT

#-----------------------------------------------------------------
#In caso l'indirizzo del server debba essere protetto
iptables -t nat -A PREROUTING -i eth3 -o eth2 -d 137.204.1.15 -p tcp --dport 443 -j DNAT --to-destination 1.1.1.14
iptables -A FORWARD -p tcp --dport 443 -d 1.1.1.14 -i eth3 -o eth2 -j ACCEPT
iptables -A FORWARD -p tcp --sport 443 -m state --state ESTABLISHED -s 1.1.1.14 -i eth2 -o eth3 -j ACCEPT
#-----------------------------------------------------------------


#3. Accesso da parte dei client alla porta UDP 53 del router
iptables -A INPUT -p tcp --dport 53 -s 172.20.0.0/20 -d 172.20.15.254 -i eth1 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 53 -m state --state ESTABLISHED -d 172.20.0.0/20 -s 172.20.15.254 -o eth1 -j ACCEPT



#4. Accesso da parte del server agli agent SNMP dei client (porta UDP 161)
iptables -A FORWARD -p udp --dport 161 -s 1.1.1.14 -d 172.20.0.0/20 -i eth2 -o eth1  -j ACCEPT
iptables -A FORWARD -p tcp --sport 161 -s 172.20.0.0/20 -d 1.1.1.14 -i eth1 -o eth2 -m state --state ESTABLISHED -j ACCEPT


iptables -P INPUT DROP #Imposto la policy di default per il traffico in ingresso
iptables -P OUTPUT DROP #Imposto la policy di default per il traffico in uscita
iptables -P FORWARD DROP #Imposto la policy di default per


#--------------------------------------SERVER--------------------------------------
iptables -F INPUT
iptables -F OUTPUT
iptables -F FORWARD

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

#2. Accesso da parte di qualsiasi host su internet alla porta TCP 443 del Server
iptables -A INPUT -p tcp --dport 443 -d 1.1.1.14 -i eth1 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 443 -m state --state ESTABLISHED -s 1.1.1.14 -o eth1 -j ACCEPT



#4. Accesso da parte del server agli agent SNMP dei client (porta UDP 161)
iptables -A OUTPUT -p udp --dport 161 -s 1.1.1.14 -d 172.20.0.0/24 -o eth1 -j ACCEPT
iptables -A INPUT -p udp --sport 161  -d 1.1.1.14 -s 172.20.0.0/20 -i eth1 -m state --state ESTABLISHED -j ACCEPT

iptables -P INPUT DROP #Imposto la policy di default per il traffico in ingresso
iptables -P OUTPUT DROP #Imposto la policy di default per il traffico in uscita
iptables -P FORWARD DROP #Imposto la policy di default per
