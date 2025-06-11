#!/bin/bash

sudo tail --pid=$$ -f /var/log/newconn.log | while read M G H HOST PROC TS PROTO SRC DIR DST FLAG OTHER; do 
    echo "$PROTO"; 
done