Architettura

(link)[https://virtuale.unibo.it/mod/book/view.php?id=1865522&chapterid=12389]

# Fasi DHCP

Fasi del DHCP (DORA Process)

- Discover: Il client manda una richiesta in broadcast ("C'è un server DHCP?").

- Offer: Il server DHCP risponde ("Ecco un IP che puoi usare").

- Request: Il client accetta l’offerta ("Voglio questo IP!").

- Acknowledge: Il server conferma ("Ok, ora sei 10.1.1.1").

Se il server è configurato con dhcp-host, salta direttamente all’assegnazione dell’IP statico.

*IP dinamico*: Assegnato casualmente dal range DHCP (es. 10.1.1.100-10.1.1.200).

*IP statico*: Assegnato sempre allo stesso dispositivo, basato sul suo MAC address.



# Logica:
1. Definisco le macchine con eventuali loop
2. Per ogni macchina, specifico tante LAN quante sono le interfacce di rete, righe:

```
machine.vm.network "private_network", virtualbox__intnet: "LAN2", auto_config: false
```

3. Confgura il site-yml per i roles ansible (ognuno dovrà implementare common e set-proxy)

4. Per attivare **dnsmasq**:
Devo configurare il file dnsmasq.conf, dire di prenderlo e poi riavviare dnsmaq con l'handler

```
interface=eth1                            # mette il server in ascolto sull'interfaccia
dhcp-range=10.1.1.129,10.1.1.190,12h      # definisce il range di indirizzi da erogare
dhcp-option=3                             # inibisce il comportamento di default, che indicherebbe 
                                          # a Client di prendere come default gateway Router (10.1.1.254) 
                                          # mentre noi vogliamo che resti quello di VirtualBox (10.0.2.2)
dhcp-option=option:ntp-server,10.1.1.254
dhcp-option=option:dns-server,10.1.1.254
dhcp-option=121,10.2.2.0/24,10.1.1.254    # consegna a Client la rotta statica per raggiungere Server
```

- Assegna indirizzi in un range specifico

- Fornisce ai client le informazioni su server NTP e DNS

- Aggiunge una rotta specifica per raggiungere la rete 10.2.2.0/24

5. Configurare dhcp (nel file ```etc/network/interfaces.d/eth1 ``` )

```
auto eth1
iface eth1 inet dhcp
```

# Modifica (dhcp-2): assegnazione di ip statici a client e a server

```
# Client ip (10.1.1.1)
# Server ip (10.2.2.2)

# Ascolto sulle interfacce
interface=eth1  # eroga al server
interface=eth2  # eroga al client

# Assegnazioni statiche
dhcp-host=08:00:27:a0:c0:03,10.1.1.1 # client
dhcp-host=08:00:27:6b:c0:bf,10.2.2.2 # server

dhcp-option=3                             # inibisce il comportamento di default, che indicherebbe 
                                          # a Server di prendere come default gateway Router2 (10.2.2.254) 
                                          # mentre noi vogliamo che resti quello di VirtualBox (10.0.2.2)
# Opzioni
dhcp-option=option:ntp-server,10.2.2.254
dhcp-option=option:dns-server,10.2.2.254
dhcp-option=121,10.1.1.1,10.2.2.2    # consegna a Server la rotta statica per raggiungere i Client
dhcp-option=eth1,3,10.1.1.1         # Force gateway for clients

# Range DHCP
dhcp-range=eth2,10.1.1.0,static,255.255.255.0,12h
dhcp-range=eth1,10.2.2.0,static,255.255.255.0,12h
```

# Modifica (dhcp-3): DHCP che possa erogare indirizzi IP a due client su subnet diverse

I due Client una volta configurati dovranno poter comunicare attraverso il Router usato 
come gateway, tale Router dovrà avere quindi due interfacce di rete distinte una per la 
subnet 10.1.1.0/24 e una per la subnet 10.2.2.0/24. 

Gli indirizzi del Router su entrambe le subnet dovranno essere definiti in modo statico 
attraverso la modifica del del file /etc/network/interfaces. 

## 1. Configurare dnsmasqr2




## 2. Configurare netr1

1. Aggiungere nel vagrantfile la riga per l'altra LAN r1: 
```
    machine.vm.network "private_network", virtualbox__intnet: "LAN3", auto_config: false
```
2. configurare opportunamente netr1
```
auto eth3
iface eth3 inet static
    address 10.2.2.254
    netmask 255.255.255.0
```

3. controllare che l'ipforwarding su r1 sia abilitato 



# Comandi utili per il debug
```
# forzare una nuova richiesta dhcp
sudo dhclient -r eth1   # rilascia lease
sudo dhclient eth1      # ottiene nuovo lease

# mostrare ip di una certa int. di rete
ip a show eth1


# riavviare solo una macchina vagrant
vagrant reload [macchina]
```
