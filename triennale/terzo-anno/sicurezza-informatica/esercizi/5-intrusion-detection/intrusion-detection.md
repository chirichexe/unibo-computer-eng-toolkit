# Suricata

Il motore Suricata è in grado di eseguire rilevamento delle
intrusioni in tempo reale (IDS), prevenzione delle
intrusioni (IPS), monitoraggio della sicurezza di rete (NSM)
e l'elaborazione dei pcap offline.

# Regole Suricata:

- **Azione**: 
drop, alert, pass, reject, log
- **Intestazione**: 
protocol (ip, tcp, dump, icmp) address (IPv4, ...) port direction (from to or bidirectional) address port
- **Opzioni**

# Setup di Suricata

```sh
# avvio
suricata -c suricata.yaml -i <INTERFACE, default: eth0> -vvv

# aggiunta di regole
touch /etc/suricata/rules/seclab.rules
cat ping-rules >> /etc/suricata/rules/seclab.rules
```

# Primo test: ping

```sh
suricata -c /etc/suricata/suricata.yaml -i eth0 -vvv # avvio

tail -f /var/log/suricata/fast.log # guardo gli alert

ping 192.168.56.8 
# se voglio farlo dalla macchina host alla vm devo
# cambiare interfaccia di rete. Quella host only
# è eth1
 
wget facebook.com

# mediante jq, log più user friendly in json
tail -f /var/log/suricata/eve.json | jq 'select(.event_type="alert")'

```

# Suricata offline

Funziona dandogli in input il tracciato di un traffico in formato pcap

1. Per **generare** file pcap:

```sh
sudo tcpdump -i eth0 -w traffico.pcap

```

Oppure da wireshark, stoppando poi il tracking e salvando con nome.pcapng

2. Sulla macchina host faccio ping o altro

3. Controllo ciò che è avvenuto _offline_:
```sh
suricata -c /etc/suricata/suricata.yaml -r tracciato_ping.pcapng

# trovo ciò che è successo su:
tail -f /var/log/suricata/fast.log
```

# Creazione di regole custom:

- alert	Azione: alert, drop, reject, pass, log
- protocol	tcp, udp, icmp, ip, http, tls
- any		IP o porta: puoi usare IP specifici (es. 192.168.1.10) o subnet (10.0.0.0/8)
- msg		Descrizione dell’alert, visibile in fast.log
- flow		Direzione e stato della connessione
- content	Cerca stringa nel payload
- pcre		Cerca tramite espressione regolare PCRE
- http_*	Modificatori come http_uri, http_host, http_header, http_method, ecc.
- tls_sni	Verifica il campo SNI nel traffico TLS
- sid		Identificativo univoco (non deve ripetersi!)
- rev		Numero versione: incrementalo se modifichi la regola
- classtype	Categoria dell’attacco (rende più leggibile il log)
- priority	Importanza dell’alert: 1 (alta), 2 (media), 3 (bassa)
- metadata	Info libere come autore, data, riferimento

Esempio:
```rules
alert icmp any any -> any any (
    msg:"Ping Detected";
    itype:8;                         # Tipo ICMP (8 = Echo Request)
    sid:1000002;
    rev:1;
)

```


# Esercizio 1: Blocca il traffico in uscita verso netflix.com

1. Aprire wireshark, richiesta a netflix.com e filtro su
```
tls.handshake.extensions_server_name == "netflix.com"

tcp.port == 443 && ip.addr == <ip-trovato>

dns # per filtrqre le richieste dns
# Cerca richieste di tipo A o AAAA (IPv4/IPv6), del tipo:
# Standard query 0x2b3c A www.netflix.com
# Standard query response A netflix.map.fastly.net
# ...
```

2. Trovo le regole e aggiungo la regola suricata

# Esercizio 2: Trova la flag mqtt

1. Imposto la regola
```
alert tcp any any -> any 1883 (msg:"MQTT FLAG DETECTED"; content:"flag"; nocase; sid:1000100; rev:1;)
```

2. Vado nel file di configurazione suricata.yaml e abilito in "eve.json" 
payload e payload-printable (sotto type)

3. leggo i log di ```eve.json``` filtrando la presenza di "SEC{" ...
