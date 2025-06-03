#!/bin/bash

echo "local4.info /var/log/sd.log" > /etc/rsyslog.d/sd.conf
systemctl restart rsyslog 
