# Contare quanti file esistono con una certa estensione, definita come la stringa 
# posta dopo l'ultimo carattere "punto" presente nel nome del file, per tutte le 
# estensioni trovate nei file presenti nel direttorio corrente e nei sottodirettori

[ -z "$1" ] && { echo "usage: $0 <dirname>"; exit 1; }

cd "$1" || exit 1

ls -R 2>/dev/null | #  lista ricorsiva
grep -v '/$' |      #  filtra solo i file escludendo le directory
grep '\.' |         #  filtra solo i file con almeno un punto
rev |               #  inverte il nome del file
cut -d. -f1 |       #  prende la parte dopo l'ultimo punto (estensione)
rev |               #  inverte di nuovo il nome del file
sort |              #  ordina le estensioni
uniq -c |           #  conta le occorrenze di ogni estensione
sort -nr |          #  ordina in ordine decrescente
head -n 5           #  mostra le prime 5 righe  

ls -R 2>/dev/null | grep -v '/$' | grep '\.' | rev | cut -d. -f1 | rev | sort |uniq -c |sort -nr | head -n 5