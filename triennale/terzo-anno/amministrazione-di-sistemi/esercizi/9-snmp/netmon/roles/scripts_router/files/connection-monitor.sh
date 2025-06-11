#!/bin/bash

LOG_FILE="/var/log/newconn"
TMP_DIR="/tmp/conn-mon"
mkdir -p "$TMP_DIR"

tail -F $LOG_FILE | while read -r line; do
    # Parse tipo (START o END), IP sorgente e destinazione
    TYPE=$(echo "$line" | awk '{print $4}')
    SRC=$(echo "$line" | grep -oP 'IP \K[\d\.]+(?=\.)')
    DST=$(echo "$line" | grep -oP ' > \K[\d\.]+(?=\.)')

    CONN_ID="${SRC}_${DST}"

    if [[ "$TYPE" == "START" ]]; then
        echo "Starting monitor for $CONN_ID"
        ./traffic-monitor.sh "$SRC" "$DST" "$CONN_ID" &
        echo $! > "$TMP_DIR/$CONN_ID.pid"
    elif [[ "$TYPE" == "END" ]]; then
        if [[ -f "$TMP_DIR/$CONN_ID.pid" ]]; then
            PID=$(cat "$TMP_DIR/$CONN_ID.pid")
            echo "Stopping monitor for $CONN_ID (PID $PID)"
            kill $PID
            rm "$TMP_DIR/$CONN_ID.pid"
        fi
    fi
done
