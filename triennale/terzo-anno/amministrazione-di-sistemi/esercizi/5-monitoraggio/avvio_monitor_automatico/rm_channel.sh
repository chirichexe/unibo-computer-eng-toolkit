#!/bin/bash

rm -f /etc/rsyslog.d/sd.conf
systemctl restart rsyslog
