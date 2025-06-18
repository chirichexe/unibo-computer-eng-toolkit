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

# Utilizzo di egrep per espressioni regolari avanzate
# +----+---------------------------------------------+-------------------------------------------------------------+
# | #  | Descrizione                                 | Comando                                                     |
# +----+---------------------------------------------+-------------------------------------------------------------+
# | 1  | Parola semplice (case-insensitive)          | egrep -i 'error' logfile.txt                                |
# | 2  | Parola intera (\b confine parola)           | egrep -E '\buser\b' file.txt                                |
# | 3  | Interi (una o più cifre)                    | egrep -E '[0-9]+' file.txt                                  |
# |    | Interi 1-3 cifre esatti                     | egrep -E '\b[0-9]{1,3}\b' file.txt                         |
# | 4  | Decimali semplici                           | egrep -E '\b[0-9]+(\.[0-9]+)?\b' file.txt                  |
# | 5  | Date ISO base YYYY-MM-DD                    | egrep -E '\b[0-9]{4}-[0-9]{2}-[0-9]{2}\b' file.txt         |
# | 6  | Indirizzi IPv4                              | egrep -E '\b((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\b' file.txt |
# | 7  | Indirizzi IPv6 semplificato                 | egrep -E '\b([0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4}\b' file.txt |
# | 8  | Email base                                  | egrep -E '\b[[:alnum:]._%+-]+@[[:alnum:].-]+\.[A-Za-z]{2,}\b' file.txt |
# | 9  | URL HTTP/HTTPS base                         | egrep -E '\bhttps?://[A-Za-z0-9./?=_-]+\b' file.txt        |
# | 10 | Stringhe formato _A_B_C_                    | egrep -E '^_[A-Z]+(_[A-Z]+)*_$' file.txt                   |
# | 11 | Hex color #RRGGBB                           | egrep -E '\b#[0-9A-Fa-f]{6}\b' file.txt                   |
# | 12 | UUID v4 base                                | egrep -E '\b[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}\b' file.txt |
# | 13 | Linee vuote                                 | egrep -E '^$' file.txt                                     |
# |    | Non-vuote                                   | egrep -Ev '^$' file.txt                                    |
# | 14 | Righe che iniziano per “WARN” o “ERROR”     | egrep -E '^(WARN|ERROR)' logfile.txt                      |
# | 15 | Righe che terminano con “done.”             | egrep -E 'done\.$' file.txt                                |
# | 16 | Righe con tab o spazi multipli              | egrep -E '[[:space:]]+' file.txt                           |
# | 17 | Doppia parola ripetuta                      | egrep -E '\b([a-zA-Z]+) \1\b' file.txt                     |
# | 18 | Liste CSV semplici                          | egrep -E '^[^,]+(,[^,]+)*$' file.csv                      |
# | 19 | Numeri binari                               | egrep -E '\b[01]+\b' file.txt                              |
# | 20 | Numeri ottali                               | egrep -E '\b[0-7]+\b' file.txt                             |
# | 21 | Numeri esadecimali                          | egrep -E '\b(0x)?[0-9A-Fa-f]+\b' file.txt                 |
# | 22 | Remove trailing whitespace                  | egrep -o -E '[[:space:]]+$' file.txt                      |
# | 23 | Password forte                              | egrep -E '^(?=.*[A-Za-z])(?=.*[0-9]).{8,}$' file.txt       |
# | 24 | Parola con caratteri accentati UTF-8        | egrep -E '[[:alpha:]]+' file.txt                          |
# | 25 | Path Linux assoluto                         | egrep -E '^/([^/ ]+/)*[^/ ]+$' file.txt                   |
# | 26 | Tag HTML di apertura semplice               | egrep -E '<[A-Za-z][A-Za-z0-9]*( [^>]*)?>' file.html       |
# | 27 | Time HH:MM 24h                              | egrep -E '\b([01][0-9]|2[0-3]):[0-5][0-9]\b' file.txt      |
# | 28 | Time HH:MM:SS 24h                           | egrep -E '\b([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]\b' file.txt |
# | 29 | Righe con parola “TODO” o “FIXME”           | egrep -E '\b(TODO|FIXME)\b' *.c                           |
# | 30 | Uso -n, -c, -l                              | egrep -n -E 'error' logfile.txt                           |
# |    |                                             | egrep -c -E '\buser\b' file.txt                           |
# |    |                                             | egrep -l -E '[0-9]{4}-[0-9]{2}-[0-9]{2}' *.log            |
# +----+---------------------------------------------+-------------------------------------------------------------+
