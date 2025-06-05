#---------------------------------------------------------------------------------------------
#CLIENT
iptables -F INPUT
iptables -F OUTPUT
iptables -F FORWARD

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

#1. Accesso da parte dei client alla porta TCP 993 del server
iptables -A OUTPUT -p tcp --dport 993 -s 172.20.0.0/20 -d 1.1.1.14/28 -o eth1 -j ACCEPT
iptables -A INPUT -p tcp --sport 993 -s 1.1.1.14/28 -d 172.20.0.0/20 -m state --state ESTABLISHED -i eth1 -j ACCEPT

#3. Navigazione sicura dei client sul web (internet, porta TCP 443)
iptables -A OUTPUT -p tcp --dport 443 -s 172.20.0.0/20 -o eth1 -j ACCEPT
iptables -A INPUT -p tcp --sport 443 -d 172.20.0.0/20 -m state --state ESTABLISHED -i eth1 -j ACCEPT

#4. Accesso da parte dei client alla porta UDP 53 del router
iptables -A OUTPUT -p udp --dport 53 -s 172.20.0.0/20 -d 172.20.15.254 -o eth1 -j ACCEPT
iptables -A INPUT -p tcp --sport 53 -d 172.20.0.0/20 -s 172.20.15.254 -m state --state ESTABLISHED -i eth1 -j ACCEPT

#Impostiamo le policy di default
iptables -P INPUT DROP #Imposto la policy di default per il traffico in ingresso
iptables -P OUTPUT DROP #Imposto la policy di default per il traffico in uscita
iptables -P FORWARD DROP #Imposto la policy di default per

#---------------------------------------------------------------------------------------------
#ROUTER
iptables -t nat -F
iptables -F INPUT
iptables -F OUTPUT
iptables -F FORWARD

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

#1. Accesso da parte dei client alla porta TCP 993 del server
iptables -t nat -A POSTROUTING -s 172.20.0.0/20 -d 1.1.1.14 -j SNAT --to-source 1.1.1.1
iptables -A FORWARD -p tcp --dport 993 -s 192.168.0.0/24 -d 1.1.1.14/28 -i eth1 -o eth2 -j ACCEPT
iptables -A FORWARD -p tcp --sport 993 -s 1.1.1.14/28 -d 192.168.0.0/24 -i eth2 -o eth1 -m state --state ESTABLISHED -j ACCEPT

#2. Accesso da parte di qualsiasi host su internet alla porta TCP 25 del server
iptables -A FORWARD -p tcp --dport 25 -d 1.1.1.14 -i eth3 -o eth2 -j ACCEPT
iptables -A FORWARD -p tcp --sport 25 -m state --state ESTABLISHED -s 172.16.0.1 -i eth2 -o eth3 -j ACCEPT

#3. Navigazione sicura dei client sul web (internet, porta TCP 443)
iptables -t nat -A POSTROUTING -p tcp -i eth1 -o eth3 -s 172.20.0.0/24 -j SNAT --to-source 137.204.1.15
iptables -A FORWARD -p tcp --dport 443 -s 172.20.0.0/20 -i eth1 -o eth3 -j ACCEPT
iptables -A FORWARD -p tcp --sport 443 -d 172.20.0.0/20 -m state --state ESTABLISHED -i eth3 -o eth1 -j ACCEPT

#4. Accesso da parte dei client alla porta UDP 53 del router
iptables -A INPUT -p tcp --dport 53 -d 172.20.15.254 -s 172.20.0.0/20  -i eth1 -j ACCEPT
iptables -A OUTPUT -p udp --sport 53 -d 172.20.0.0/20 -s 172.20.15.254 -m state --state ESTABLISHED -o eth1 -j ACCEPT

#Impostiamo le policy di default
iptables -P INPUT DROP #Imposto la policy di default per il traffico in ingresso
iptables -P OUTPUT DROP #Imposto la policy di default per il traffico in uscita
iptables -P FORWARD DROP #Imposto la policy di default per

#---------------------------------------------------------------------------------------------
#SERVER

iptables -F INPUT
iptables -F OUTPUT
iptables -F FORWARD

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

#1. Accesso da parte dei client alla porta TCP 993 del server
iptables -A INPUT -p tcp --dport 993 -s  1.1.1.1 -i eth1 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 993 -d 1.1.1.1 -o eth1 -m state --state ESTABLISHED -j ACCEPT

#2. Accesso da parte di qualsiasi host su internet alla porta TCP 25 del server
iptables -A INPUT -p tcp --dport 25 -i eth1 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 25 -m state --state ESTABLISHED -o eth1 -j ACCEPT

#Impostiamo le policy di default
iptables -P INPUT DROP #Imposto la policy di default per il traffico in ingresso
iptables -P OUTPUT DROP #Imposto la policy di default per il traffico in uscita
iptables -P FORWARD DROP #Imposto la policy di default per


