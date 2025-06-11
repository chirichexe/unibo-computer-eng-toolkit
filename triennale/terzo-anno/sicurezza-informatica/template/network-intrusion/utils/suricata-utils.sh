#!/bin/bash

LOGDIR="/logs"
LOGFILE="/logs/eve.json"

# ========================================================================
# Carica le regole su un pcapng 

sudo suricata -c /etc/suricata/suricata.yaml -l $LOGDIR -s exam.rules -r file.pcapng -k none

# ========================================================================
# Cerca nel log gli eventi 
# esempio 1
cat $LOGFILE | jq 'select(.payload_printable|contains("flag"))'.payload_printable 2>/dev/null

# esempio 2
tail -f $LOGFILE | jq 'select(.event_type="alert")'

