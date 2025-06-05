# Suricata 2

## Consegna

```
Il file di tipo pcap assegnato è il tracciato di un traffico mqtt tra un subscriber e un publisher sul broker mosquitto.

( Per informazioni su mqtt e mosquitto riprendere le slide su TLS)

Vostro compito è quello di creare una regola suricata che scateni un alert ogni volta che nel contenuto del pacchetto MQTT ci sia il contenuto “flag”

Se predisposta correttamente, nei log di suricata dovreste essere in grado di vedere il contenuto dei pacchetti

Nel contenuto dei pacchetti è possibile trovare “pezzi” di una flag nel formato SEC{qualcosa}, che potete ricostruire e sottomettere (insieme alla regola!) sul portale virtuale.

ATTENZIONE: Per poter vedere il contenuto dei pacchetti nei log di suricata è necessario abilitare la funzionalità “payload-printable”. Cercare nel file di configurazione di suricata la suddetta feature e abilitarla se disabilitata.

Modalità di consegna:
- Consegnare il file report.txt che contiene:
-- La regola usata per identificare il traffico con suricata.
-- lo script/comando usato per parsare il log di suricata e ricostruire la flag
-- La flag
```

## Soluzione

**ATTENZIONE!!**: Ricorda che `fast.log` è il luogo dove si trovano i log più semplici e "veloci", se vogliamo avere un log espressivo, dobbiamo usare `eve.json`. Inoltre, la config è leggermente diversa dall'esercizio precedente, siccome, come chiede la consegna, abbiamo attivato l'opzione _payload-printable_.

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