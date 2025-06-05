# Utilizzo l'opzione -A in tutte le regole per fare in modo che vengano inserite una in seguito all'altra in ordine

Fare il FLUSH delle CATENE per partire puliti:
iptables -F INPUT
iptables -F OUTPUT
iptables -F FORWARD
#iptables -t nat -F PREROUTING
#iptables -t nat -F POSTROUTING

# 1) Consentire qualsiasi traffico sull'interfaccia di loopback

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# REGOLE

# INSERIRE POLITICHE CHE SI COMPLEMENTANO CON QUELLE PRECEDENTI (SE PRIMA ACCETTAVI QUALCOSA, DEVI NON ACCETTARE TUTTO IL RESTO (?))
