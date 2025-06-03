# Scheduling servizio 

```sh
# Scheduling servizio
ATJOB=$(mktemp)

echo "/bin/comando" | at now + 30 minutes 2>&1 | grep '^job ' | cut -f2 -d' ' > $ATJOB

# De-scheduling prima dell'esecuzione
atrm $(cat $ATJOB)
```

# watchdog

```sh

```

# crontab

```sh   
PERIODO='*/10 8-18 * * *'
COMANDO='/home/las/qualcosa.sh parametri vari"
TMPTAB=$(mktemp)
# dump della tabella e rimozione di eventuale riga che già contenga COMANDO, per evitare duplicati
crontab -l | grep -vF "$COMANDO" > $TMPTAB 
echo "$PERIODO $COMANDO" >> $TMPTAB
crontab $TMPTAB
rm $TMPTAB
```

# rsyslog

Un messaggio di log ha una facility e una priority:
- Facility: da dove arriva il messaggio (es. auth, cron, daemon, local0…)
- Priority: livello di gravità (es. debug, info, notice, warn, err, crit, alert, emerg)

Sintassi: ```FACILITY.PRIORITY    DESTINAZIONE```

Esempi: 
local4.info = messaggi informativi della facility local4
authpriv.* /var/log/auth.log = tutti i messaggi dal sistema di autenticazione
*.info /var/log/messages = tutto con priorità info o più grave
cron.warning /var/log/cron.warn = solo messaggi cron con priorità warning o più grave

```sh   
# per aggiungere facilty di log si può usare la directory /etc/rsyslog.d
# che contiene file di configurazione automaticamente inclusi

# es nuovo file:
echo "local4.=info  /var/log/myevents.log" > /etc/rsyslog.d/mylog.conf

# es. disattivazione della facility aggiunta
mv /etc/rsyslog.d/mylog.conf /etc/rsyslog.d/mylog.off

# la regola può essere testata con
logger -p local4.info "Messaggio di test"

# in ogni caso dopo qualsiasi modifica del genere mostrato sopra
systemctl restart rsyslog
```
# systemd

Per scoprire i parametri per gli UnitFile:
```man systemd.unit```

Preparare l'ambiente:
1. Crea il file in /etc/systemd/system/servizio.service

2. Scrivi il file 

3. Ricarica con systemctl daemon-reload

4. Abilita all'avvio con sudo systemctl enable servizio.service


naviga cercando /Service e n per l'occorrenza successiva
