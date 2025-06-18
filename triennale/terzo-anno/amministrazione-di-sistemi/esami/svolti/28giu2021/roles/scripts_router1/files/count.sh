#!/bin/bash

declare -A LEN
declare -A COUNT

OLD_LOG=/var/log/nfs.log
NEW_LOG=/var/log/nfs.log.last
ALERT_PATH=/home/vagrant/alert.sh

# effettui uno spostamento corretto ed efficiente di quanto contenuto in /var/log/nfs.log in
# /var/log/nfs.log.last, in modo che contestualmente il log di nuovi messaggi riprenda nel file
# (nuovo) /var/log/nfs.log

mv $OLD_LOG $NEW_LOG
systemctl restart rsyslog

# analizzi /var/log/nfs.log.last calcolando, per ogni IP della rete dei Client presente nel log:

cat $NEW_LOG | while read G D HR HS US SRC_IP DEST_IP LENGTH ; do

    [[ $SRC_IP =~ ^10.111.111.*$ ]] && IP="$SRC_IP"
    [[ $DEST_IP =~ ^10.111.111.*$ ]] && IP="$DEST_IP"

    (( LEN[$IP]     += $LENGTH  ))
    (( COUNT[$IP]   += 1        ))

done

for C in ${!LEN[$@]} ; do

    [[ ${LEN[$C]} -gt 20000000 && ${COUNT[$C]} -gt 10000 ]] && $ALERT_PATH $C
    
done

