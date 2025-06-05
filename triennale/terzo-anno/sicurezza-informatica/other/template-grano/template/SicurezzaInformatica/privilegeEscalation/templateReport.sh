L'esercizio richiede l'esecuzione di un file che apportera delle modifiche ad alcuni file.
Prima di tutto ci assicuriamo che l'immagine del db sia giusta.

Eseguiamo il comando sudo aideinit per creare un immagine del database affinchè aide possa 
rilevare le differenze apportate dal comando che verra successivamente eseguito

Eseguiamo lo script 
chmod +x ./change1
sudo ./change1

Verifichiamo le modifiche apportate dallo script appena eseguito con il comando
sudo aide -c /etc/aide/aide.conf -C

Notiamo modifiche ai seguenti comandi :
- /etc/passwd
- /etc/shadow
- /etc/sudoers
- tee
- find
- grep
- cp
- chmod
- vim.tiny

Controlliamo ogni modifica file per file

-----------------------MODIFICA CAPABILITIES-----------------------------------

getcap PATH_COMANDO

- cap_dac_override=ep
Ignora i permessi di lettura, scrittura ed esecuzione di un file

In alcuni casi può non essere stata modificata alcuna capabilities

ES : getcap /usr/bin/grep
/usr/bin/grep =
