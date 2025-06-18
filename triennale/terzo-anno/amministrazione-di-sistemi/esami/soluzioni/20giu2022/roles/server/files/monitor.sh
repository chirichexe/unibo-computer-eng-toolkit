#!/bin/bash

function GETLOAD() {
	snmpwalk -v 1 -c public "$1" .1.3.6.1.4.1.2021.10.1.101 | grep -qi "Load Average too high" && logger -n "$1" -p "local5.info" "STOP"
}

# coi parametri forniti per eth1 si deduce che la subnet
# occupa il range 10.100.0.1 .. 10.100.7.254
# i client iniziano da 10.100.2.1

PREFIX="10.100."
for HOSTID in 2.{1..255} {3..6}.{0..255} 7.{0..254} ; do
	GETLOAD "$PREFIX$HOSTID"  & 
done      
