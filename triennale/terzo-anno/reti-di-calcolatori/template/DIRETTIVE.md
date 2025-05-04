# Intestazione file
```
cd Desktop/LABS/s0001071430

//COGNOME NOME 0001071430

(normalmente gcc nomeFile -o nomeEseguibile)
```
---
# RPC
```bash
rpcgen RPC_xFile.x

#compilazione client: 
gcc -I /usr/include/tirpc RMI_Client.c RMI_xFile_clnt.c RMI_xFile_xdr.c -o client -ltirpc

#compilazione server: 
gcc -I /usr/include/tirpc RMI_Server.c RMI_xFile_svc.c RMI_xFile_xdr.c -o server -ltirpc
```

# RMI
```bash
javac Server.java Client.java Interface.java 

rmic -vcompat Server

rmiregistry &

# in caso di problemi fare 
lsof -i :1099
kill -9 <PID>

java Server

java Client
```
---
# JAVA 11 per RMI

1. nano ~/.bashrc (aprire/creare il file con un editor es. nano) 

2. export PATH=/usr/lib/jvm/openjdk-11/bin:$PATH (inserire la linea di import)

3. Salvare e controllare che la versione di java sia giusta con il comando java --version

OPPURE

1. vim ~/.bashrc

2. export PATH=/usr/lib/jvm/openjdk-11/bin:$PATH

3. source ~/.bashrc (per applicare le modifiche immediatamente)

4. java --version

