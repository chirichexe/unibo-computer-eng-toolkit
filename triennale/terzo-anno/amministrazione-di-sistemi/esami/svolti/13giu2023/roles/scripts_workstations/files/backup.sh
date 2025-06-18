#!/bin/bash

IP=172.16.0.1
HOST_IP=$(hostname -I | awk '{ print $2 }')

# invia al Manager via syslog, con etichetta local1.notice
# la stringa _EXIT_USERNAME_IP_ essendo USERNAME l'utente che lo esegue e IP l’indirizzo della workstation su eth1.

logger -p local1.notice -n $IP "_EXIT_${USER}_${HOST_IP}_" 