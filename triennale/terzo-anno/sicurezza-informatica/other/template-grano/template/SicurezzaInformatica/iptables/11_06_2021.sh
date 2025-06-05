#0. Svuotiamo tutte le catene
iptables -F INPUT #Pulisco le regole di input
iptables -F OUTPUT #Pulisco le regole di output
iptables -F FORWARD #Pulisco le regole di forwarding


#1. Consentire qualsiasi traffico sull'interfaccia di loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

#2. Consentire il traffico delle connessioni HTTP entranti
iptables -A INPUT -p tcp --dport 80 
iptables -A OUTPUT -p tcp --sport 80 -m state --state ESTABLISHED -j ACCEPT

#3. Consentire connessioni SSH uscenti verso la rete host-only 192.168.56.0/24
iptables -A OUTPUT -p tcp --dport 22 -d 192.168.56.0/24 -j ACCEPT
iptables -A INPUT -p tcp --sport 22 -s 192.168.56.0/24 -m state --state ESTABLISHED -j ACCEPT

#4.Bloccare l'inoltro del traffico proveniente dalla rete host-only verso altre destinazioni
iptables -A FORWORD -s 192.168.56.0/24  ! -d 192.168.56.0/24 -j DROP

#5. Consentire la risoluzione dei nomi DNS
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --sport 53 -m state --state ESTABLISHED -j ACCEPT

#6. Infine bloccare tutto il traffico non elencato nei punti 2, 3, 5
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD ACCEPT