1. accesso da parte dei client alla porta TCP 993 del server

iptables -A INPUT -p tcp -s 1.1.1.1 -i eth1 --dport 993 -j ACCEPT
iptables -A OUTPUT -p tcp -d 1.1.1.1 -o eth1 --sport 993 -m state --state ESTABLISHED -j ACCEPT

2. accesso da parte di qualsiasi host su internet alla porta TCP 25 del server

iptables -A INPUT -p tcp -i eth1 --dport 25 -j ACCEPT
iptables -A OUTPUT -p tcp -o eth1 --sport 25 -m state --state ESTABLISHED -j ACCEPT
