# Suricata

## Reminder
Ricordati di mettere in /etc/suricata/suricata.yaml il payload printable a true

# Costruire le regole

**Opzioni "esterne"**
- alert	Azione: alert, drop, reject, pass, log
- protocol	tcp, udp, icmp, ip, http, tls
- any		IP o porta: puoi usare IP specifici (es. 192.168.1.10) o subnet (10.0.0.0/8)

**Opzioni "interne"**
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

# Analisi con Wireshark

- Protocollo del traffico (lo vedo dalla scritta "protocol")
- Gli IP in gioco li vedo separati con una ->
- La/Le porte in gioco le vedo nelle info, quando alla negoziazione fanno [PORTA_CLIENT] -> [PORTA_SERVER]

## TIPS
- Se si notano una grande quantita di pacchetti tutti provenienti dallo stesso IP ma a porte diversi: port scan
- Se si notano una grande quantita di pacchetti tutti proveniente da IP variabili ma alla stessa porta: DDoS
- In generale COMMENTARE ciò che si nota (risposte da server (es: Unauthorized ), tipologie di richeiste (http GET)...)

## Regole offline

Dopo aver scritto una regola che analizza il traffico in base ai parametri desiderati, la applico a un file di cattura (pcap) con il comando:

```sh
sudo suricata -c /etc/suricata/suricata.yaml -l $LOGDIR -s esame.rules -r file.pcapng -k none
```

L'output sarà generato nei file di log, in particolare in `fast.log` e `eve.json`, dove `fast.log` contiene i log più semplici e veloci, mentre `eve.json` contiene i log più complessi e dettagliati.

# Esempio con esercizio su mqtt

Prima di tutto, carichiamo il file `mqtt_suricata_exercise.pcapng` dentro wireshark, e filtriamo i pacchetti mqtt. Noteremo che alcuni pacchetti hanno la stringa "flag" all'interno.

Scriviamo la regola in modo che ci avvisi quando ci sono dei pacchetti mqtt.

```
alert mqtt any any -> any any (msg:"Flag_fragm"; sid:300000301; rev:1;)
```

A questo punto, usiamo questo comando per caricare le regole e il file wireshark dentro suricata.

```
suricata -c suricata.yaml -l logs -s seclab.rules -r mqtt_suricata_exercise.pcapng -i enp0s31f6
```

Dopo questo passaggio, suricata avrà generato dei log pronti per essere analizzati. In questo caso saranno dentro `eve.log`, siccome è il log più complesso.

Filtriamo i dati in modo che vediamo solo le parti del log di `eve.json` che ci interessanto

```
cat eve.json | jq 'select(.payload_printable|contains("flag"))'.payload_printable
```

Notiamo che ognuna delle parti ha segnata la posizione all'interno del flag finale (es. first, second...).
Il flag ottenuto sarà:`SEC{suricata_mqtt_nids}`