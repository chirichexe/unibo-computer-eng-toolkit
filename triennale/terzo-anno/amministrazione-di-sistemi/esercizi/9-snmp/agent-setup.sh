#!bin/bash

apt update && apt install snmpd

# Copia del file...

systemctl restart snmpd
