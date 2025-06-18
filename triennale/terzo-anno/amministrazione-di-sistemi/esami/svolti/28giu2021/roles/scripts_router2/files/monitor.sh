#!/bin/bash

IP_ROUTER=10.111.111.1
NET_SERVER=10.111.111.0/24

tcpdump -i eth1 -nlp "(( dst net $NET_SERVER and dst port 2049 ) or ( src net $NET_SERVER and src port 2049 ))" | 
while read T IP SRC_IP DIR DEST_IP OTHER ; do
    
    LENGTH=$(echo "$RESTO" | awk -F'length ' '{ print $2 }' )

    logger -p local1.info -n $IP_ROUTER "${SRC_IP} ${DEST_IP} ${LENGTH}"

done