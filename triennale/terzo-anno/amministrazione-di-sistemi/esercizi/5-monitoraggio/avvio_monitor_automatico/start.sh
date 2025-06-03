# Rendi attivo all’avvio
sudo systemctl enable mylog.service

# Avvia il servizio (aggiunge la configurazione)
sudo systemctl start mylog.service

# Verifica che il file sia stato creato e che rsyslog funzioni
cat /etc/rsyslog.d/sd.conf
logger -p local1.info "Test da local1"
tail /var/log/sd.log

# Arresta il servizio (rimuove la configurazione)
sudo systemctl stop mylog.service

