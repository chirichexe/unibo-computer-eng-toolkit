1. accesso da parte dei client alla porta TCP 993 del server

iptables -t nat -A POSTROUTING -s 172.20.0.0/20 -d 1.1.1.14 -j SNAT --to-source 1.1.1.1
iptables -A FORWARD -p tcp -s 172.20.0.0/20 -d 1.1.1.14 -i eth1 -o eth2 --dport 993 -j ACCEPT
iptables -A FORWARD -p tcp -s 1.1.1.14 -d 1.1.1.1 -i eth2 -o eth1 --sport 993 -m state --state ESTABLISHED -j ACCEPT

2. accesso da parte di qualsiasi host su internet alla porta TCP 25 del server

iptables -A FORWARD -p tcp -i eth3 -o eth2 -d 1.1.1.14 --dport 25 -j ACCEPT
iptables -A FORWARD -p tcp -i eth2 -o eth3 -s 1.1.1.14 --sport 25 -m state --state ESTABLISHED -j ACCEPT

3. navigazione sicura dei client sul web (internet, porta TCP 443)

iptables -t nat -A POSTROUTING -s 172.20.0.0/20 -i eth1 -o eth3 --to-source 137.204.1.15
iptables -A FORWARD -p tcp -s 172.20.0.0/20 -i eth1 -o eth3 --dport 443 -j ACCEPT
iptables -A FORWARD -p tcp -d 137.204.1.15 -i eth3 -o eth1 --sport 443 -m state --state ESTABLISHED -j ACCEPT

4. accesso da parte dei client alla porta UDP 53 del router

iptables -A INPUT -p udp -s 172.20.0.0/20 -i eth1 --dport 53 -j ACCEPT
iptables -A OUTPUT -p udp -d 172.20.0.0/20 -o eth1 --sport 53 -m state --state ESTABLISHED -j ACCEPT
