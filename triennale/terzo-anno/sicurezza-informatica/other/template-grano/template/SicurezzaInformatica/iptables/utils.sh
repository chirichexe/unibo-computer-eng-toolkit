#Uso del comando iptables per configurare il firewall
iptables -F INPUT #Pulisco le regole di input
iptables -F OUTPUT #Pulisco le regole di output
iptables -F FORWARD #Pulisco le regole di forwarding

iptables -P INPUT DROP #Imposto la policy di default per il traffico in ingresso
iptables -P OUTPUT DROP #Imposto la policy di default per il traffico in uscita
iptables -P FORWARD DROP #Imposto la policy di default per


iptables -vnL #Visualizzo le regole di iptables
iptables -vnL --line-numbers #Visualizzo le regole di iptables con i numeri di riga
iptables -vnL INPUT --line-numbers #Visualizzo le regole di iptables con i numeri di riga per il traffico in ingresso


-A #Aggiunge una regola in coda
-I #Aggiunge una regola all'inizio


# Permette al sistema di inviare pacchetti a se stesso
iptables -I INPUT -i lo -j ACCEPT
iptables -I OUTPUT -o lo -j ACCEPT

#Per inserire i messaggi scarta in un file di log
iptables -A INPUT -j LOG --log-prefix " input_end "
iptables -A OUTPUT -j LOG --log-prefix " output_end "
iptables -A FORWARD -j LOG --log-prefix " forward_end "
#Il traffico si puo ottenere dal file /var/log/kern.log


#Per effettuare un NAT 
iptables -t nat -I PREROUTING -p tcp -s 10.1.1.1 -d 10.1.1.254 --dport 22 -j DNAT --to-destination 10.2.2.1