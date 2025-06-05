#Per caricare un immagine
sudo docker load -i prove_web.tar

#Per visualizzare tutte le immagini
sudo docker images

#Per rimuovere tutti i container
sudo docker rm -f $(sudo docker ps -a -q)

#Avvio del docker
sudo docker run -i -t esami_web /bin/bash

#Controlliamo il nostro IP
hostname -I