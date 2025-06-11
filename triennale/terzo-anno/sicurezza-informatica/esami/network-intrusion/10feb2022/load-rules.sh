#!/bin/bash

test $# -lt 1 && { echo "usage: $0 <file.pcapng>"; exit 1; }

sudo suricata -c /etc/suricata/suricata.yaml -l logs -s seclab.rules -r $1 -i enp0s31f6
