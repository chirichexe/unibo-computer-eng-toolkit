#----------------------------CLIENT----------------------------
iptables -F INPUT
iptables -F OUTPUT
iptables -F FORWARD

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
#1. i Client sulla rete privata 192.168.0.0/24 devono poter interrogare DNS e servizi di sincronizzazione NTP in Internet (porte UDP 53 e 1233)

iptables -A INPUT -p udp --sport 53 -d 192.168.56.0/24 -i eth1 -m state --state ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -s 192.168.0.0/24  -o eth1 -j ACCEPT

iptables -A OUTPUT -p udp --dport 1233 -s 192.168.0.0/24 -j ACCEPT
iptables -A INPUT -p udp --sport 1233 -d 192.168.56.0/24 -m state --state ESTABLISHED -j ACCEPT

iptables -P INPUT DROP #Imposto la policy di default per il traffico in ingresso
iptables -P OUTPUT DROP #Imposto la policy di default per il traffico in uscita
iptables -P FORWARD DROP #Imposto la policy di default per

#----------------------------ROUTER----------------------------

iptables -t nat -F
iptables -F INPUT
iptables -F OUTPUT
iptables -F FORWARD


iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

#1. i Client sulla rete privata 192.168.0.0/24 devono poter interrogare DNS e servizi di sincronizzazione NTP in Internet (porte UDP 53 e 1233)

iptables -A FORWARD -p tcp --dport 53 -s 192.168.0.0/24 -i eth1 -o eth3 -j ACCEPT
iptables -A FORWARD -p tcp --sport 53 -m state --state ESTABLISHED -d 192.168.0.0/24 -i eth3 -o eth1 -j ACCEPT

iptables -A FORWARD -p tcp --dport 1233 -s 192.168.0.0/24 -i eth1 -o eth3 -j ACCEPT
iptables -A FORWARD -p tcp --sport 1233 -m state --state ESTABLISHED -d 192.168.0.0/24 -i eth3 -o eth1 -j ACCEPT

iptables -t nat -A POSTROUTING -p tcp -i eth1 -o eth3 -s 192.168.0.0/24 -j SNAT --to-source 130.136.5.15

#2. il servizio SMTP (porta 25 tcp ) del Server collocato sulla rete privata 172.16.0.0/20 deve essere raggiungibile da qualsiasi host di Internet
iptables -t nat -A PREROUTING -i eth3 -o eth2 -s 130.136.5.15 -p tcp --dport 25 -j SNAT --to-destination 172.16.0.1
iptables -A FORWARD -p tcp --dport 25 -d 172.16.0.1 -i eth3 -o eth2 -j ACCEPT
iptables -A FORWARD -p tcp --sport 22 -m state --state ESTABLISHED -s 172.16.0.1 -i eth2 -o eth3 -j ACCEPT


#3. il servizio LDAP (porta 389 tcp) del Router deve essere raggiungibile dal Server
iptables -A INPUT -p tcp --sport 389 -s 172.16.0.1 -d 172.16.15.254 -i eth2 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 389 -m state --state ESTABLISHED -s 172.16.15.254 -d 172.16.0.1 -o eth2 -j ACCEPT

iptables -P INPUT DROP #Imposto la policy di default per il traffico in ingresso
iptables -P OUTPUT DROP #Imposto la policy di default per il traffico in uscita
iptables -P FORWARD DROP #Imposto la policy di default per

#----------------------------SERVER----------------------------
iptables -F INPUT
iptables -F OUTPUT
iptables -F FORWARD

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

#2. il servizio SMTP (porta 25 tcp ) del Server collocato sulla rete privata 172.16.0.0/20 deve essere raggiungibile da qualsiasi host di Internet
iptables -A INPUT -p tcp --dport 25 -d 172.16.0.1 -i eth1 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 25 -m state --state ESTABLISHED -s 172.16.0.1 -o eth1 -j ACCEPT

#3. il servizio LDAP (porta 389 tcp) del Router deve essere raggiungibile dal Server
iptables -A OUTPUT -p udp --dport 389 -s 172.16.0.1 -d 172.16.15.254  -o eth1 -j ACCEPT
iptables -A INPUT -p udp --sport 389  -s 172.16.15.254 -d 172.16.0.1 -i eth1 -m state --state ESTABLISHED -j ACCEPT

iptables -P INPUT DROP #Imposto la policy di default per il traffico in ingresso
iptables -P OUTPUT DROP #Imposto la policy di default per il traffico in uscita
iptables -P FORWARD DROP #Imposto la policy di default per
