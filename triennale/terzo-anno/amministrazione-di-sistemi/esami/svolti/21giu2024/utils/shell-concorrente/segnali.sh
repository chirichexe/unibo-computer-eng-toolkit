#!/bin/bash

cat /dev/null > log

sleep 10 &
PRIMO=$!

sleep 20 &
SECONDO=$!

while sleep 5 ; do

        STATO1=`ps hp $PRIMO | awk '{ print $3 }'`
        STATO2=`ps hp $SECONDO | awk '{ print $3 }'`

        if test -z "$STATO1" ; then STATO1=terminato ; fi
        if test -z "$STATO2" ; then STATO2=terminato ; fi

        echo "Stato del processo $PRIMO: $STATO1, stato del processo $SECONDO: $STATO2" | tee -a log

        # if test "$STATO1" = "terminato" -a "$STATO2" = "terminato" ; then break ; fi
        if ! ps "$PRIMO" && ! ps "$SECONDO" ; then break ; fi
done
