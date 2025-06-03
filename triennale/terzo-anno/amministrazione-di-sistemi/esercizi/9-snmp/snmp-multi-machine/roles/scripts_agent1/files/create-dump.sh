#!/bin/bash

FILENAME=/home/vagrant/file.pcap

sudo /usr/bin/tcpdump -i eth1 -c 4 -w $FILENAME 

logger -p local4.info -n 10.1.1.1 $FILENAME