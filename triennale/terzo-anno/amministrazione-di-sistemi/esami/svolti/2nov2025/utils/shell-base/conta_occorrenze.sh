

[ -z "$1" ] && { echo "usage: $0 filename"; exit 1; }

filename="$1"

grep -o -w -i 'sherlock' $filename | wc -l
echo "----"

grep -o -w '\w*a\w*' $filename | wc -l


echo "----"

# Utilizzo regex:
# +------+-------------------------------+-------------------------------------------+
# |Char  | Significato                   | Esempio                                   |
# |.     | Qualsiasi carattere singolo   | a.c → trova abc, acc, a9c                 |
# |*     | Ripetizione 0 o più volte     | lo*l → ll, lol, loool                     |
# |^     | Inizio della riga             | ^ciao → trova righe che iniziano con ciao |
# |$     | Fine della riga               | ciao$ → trova righe che finiscono con ciao|
# |[]    | Insieme di caratteri          | [aeiou] → trova una vocale                |
# |\     | Escape (toglie sign. speciale)| \. → cerca proprio il carattere .         |
# +------+-------------------------------+-------------------------------------------+
# Per usare logica negativa in grep: usa -v

grep -oE '\w+' $filename | # prende solo le parole (composte da lettere/numeri) una per riga 
sort |                     # ordina alfabeticamente, in pratica le raggruppa
uniq -c |                # conta le occorrenze di ogni parola, in pratica conta i raggruppamenti
sort -nr |               # ordina in ordine decrescente per frequenza
head -n 5                # mostra le prime 5 righe

grep -E -o '[a-zA-Z]{2,}' $filename | sort | uniq -c | sort -nr | head -n 5

