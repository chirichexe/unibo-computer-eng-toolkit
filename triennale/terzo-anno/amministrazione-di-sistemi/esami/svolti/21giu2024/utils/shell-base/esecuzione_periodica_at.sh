
!/bin/bash

test -f "$1" || {
   echo il primo parametro deve essere un file calendario esistente
   exit 1
}

CALENDARIO="$1"
test -f "OLD-$CALENDARIO" || touch "OLD-$CALENDARIO"

cat "$CALENDARIO" | while read DATA ORA DESCRIZIONE 
do
   SCADENZA=$(date +%s -d "$DATA $ORA") 
   GIORNOPRIMA="$(date '+%Y%m%d%H%M' -d @$(( SCADENZA - 24*60*60 )) )"
   ORAPRIMA="$(date '+%Y%m%d%H%M' -d @$(( SCADENZA - 60*60 )) )"

#Se l’evento non è già presente nel file OLD, usa il comando at per pianificare due notifiche 
#(una il giorno prima, una un’ora prima). 
#Le notifiche scrivono nel file $HOME/promemoria, usando flock per evitare scritture concorrenti.

   grep -qx "$DATA $ORA $DESCRIZIONE" "OLD-$CALENDARIO" || {
      at -t "$GIORNOPRIMA" <<< "flock $HOME/promemoria echo '$DESCRIZIONE scade il $DATA alle $ORA' >> $HOME/promemoria"
      at -t "$ORAPRIMA" <<< "flock $HOME/promemoria  echo '$DESCRIZIONE scade il $DATA alle $ORA' >> $HOME/promemoria"
   }
done 
cat "$CALENDARIO" > "OLD-$CALENDARIO" 


#ESECUZIONE CON cron

#Lo script dovrebbe essere eseguito regolarmente da cron, ad esempio una volta all’ora o al giorno, in modo da rilevare nuovi eventi 
#nel file calendario e pianificare i promemoria.
#Esempio di entry in crontab per esecuzione ogni giorno alle 8:00:
#0 8 * * * /percorso/assoluto/script.sh /percorso/assoluto/mio_calendario.txt
