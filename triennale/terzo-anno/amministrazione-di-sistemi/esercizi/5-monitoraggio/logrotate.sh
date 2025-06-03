#!/bin/bash
#
# Realizzare uno script dal comportamento dipendente dal contesto di invocazione.
# Se logrotate.sh  si rileva lanciato da terminale (man tty), 
# - configura rsyslog per dirigere i messaggi etichettati local1 con priorità non inferiore a warning sul file /var/log/my.log
# - configura la cron table di root per esegure se stesso ogni giorno lavorativo alle 23:00

# In caso contrario, effettua la "rotazione" del file /var/log/my.log 
# - rinomina eventuali file /var/log/my.log.N.bz2 in /var/log/my.log.N+1.bz2 (per ogni N esistente)
# - rinomina /var/log/my.log in /var/log/my.log.1 e lo comprime con bzip2
# - ricarica rsyslogd (più in generale il processo che vi sta scrivendo man fuser)
