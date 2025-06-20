# NFT: architettura:

- table: contenitore, taggruppa più chaiinrule
- chain: raccolta di regole con un hook (input, output, forward)
	- input: pacchetti per sistema locale
	- output: pacchetti generati localmente
	- pacchetti che passano attraverso il sistema

	- Come strutturare un chain:

- rule: la singola regola che decide cosa fare, se scartare loggare, etc...

# Inoltrare la rete del traffico tra Client e Server

- **Obiettivo**: Generare traffico tra CLIENT ed S1 controllandolo su R1 ed R2

- **Strategia**:

1. Controllare tra i due router il traffico
```sh
sudo tcpdump -i eth1
```

2. Creare una configurazione che restringa le regole di routing:

"flush chain filter FORWARD" -> Svuota la chain FORWARD nella tabella filter, cancella le regole precedenti
"table ip filter" -> Crea o modifica una tabella chiamata filter per il protocollo IP
"chain FORWARD { type filter hook forward priority filter; policy drop; " -> Crea una chain chiamata FORWARD che intercetta il traffico instradato attraverso la macchina (da client a server passando per i router) e imposta una policy predefinita DROP che blocca tutto di default
"righe con gli ip" -> accetta i pacchetti dagli ip specificati (ip del client e dei due server)

```js
sudo nft flush chain filter FORWARD # Svuota la chain FORWARD nella tabella filter, cancella le regole precedenti
table ip filter {
  chain FORWARD { 
// la catena chiamata forward intercetta il traffico instradato attraverso la macchina

    type filter hook forward priority filter; policy drop; 

// la politica di default "drop" blocca tutto di base

    ip saddr 10.1.1.0/24 ip daddr 10.2.2.0/24 accept
    ip daddr 10.1.1.0/24 ip saddr 10.2.2.0/24 accept
    ip saddr 10.1.1.0/24 ip daddr 10.3.3.0/24 accept
    ip daddr 10.1.1.0/24 ip saddr 10.3.3.0/24 accept
// accetto i pacchetti da questi ip
 }
}
```

lo carico nel packet filter con ```nft -f FILENAME```

```sh
sudo nft add rule filter FORWARD tcp dport 2222 drop  
# blocca il traffico TCP in transito destinato alla porta 2222

```

# Operazioni comuni
## Lista
- Lista delle regole: ```nft list ruleset```, con il flag ```-a``` per avere anche gli indirizzi
- Lista delle tabelle: ```nft list tables```

# Setup tabelle e chain
- Aggiungere una tabella: ```nft add table ip filter```
- Aggiungere una chain: ```nft add chain filter input { type filter hook input priority 0 \; policy drop \; }```

- Lista dei filtri: ```nft list table ip filter``` 

- Aggiungere una regola: ```nft add rule filter FORWARD tcp dport 2222 drop```
- Rimuovere una regola: ```nft delete rule filter FORWARD tcp dport 2222 drop```
- Rimuovere una tabella: ```nft delete table ip filter```

## Aggiunta regole
Template:   
```sh
nft add rule inet filter <chain> \
  ip saddr <ip-sorgente> \ # IP sorgente
  ip daddr <ip-destinazione> \ # IP destinazione
  iifname <interfaccia-ingresso> \ # Interfaccia di ingresso, es. eth0
  oifname <interfaccia-uscita> \ # Interfaccia di uscita, es. eth1
  protocol [tcp/udp/icmp] \ # Protocollo
  <opzioni-porta> \ # Opzioni porta, ad esempio tcp dport 80
  ct state [new,established] \ # Stato della connessione, ad esempio new o established
  accept # Azione da eseguire, ad esempio accept o drop
```


# Differenza tra iptables e nftables

- IPTABLES lavora con tabelle predefinite (filter, nat, ecc.) e catene (INPUT, OUTPUT, FORWARD).

- NFTABLES unifica tutte queste funzionalità in una sintassi coerente e modulare.

# Esercizio
- **Obiettivo**: Permettere la connessione sulla porta 22 dal client ad S2 impedendo 
ogni altra connessione

- **Strategia**:

1. Configurazione di NFTABLES

```sh
# creo tabella e relative chain
nft add table ip filter
nft add chain ip filter output { type filter hook output priority 0 \; }
nft add chain ip filter input { type filter hook input priority 0 \; }

# aggiungo la regola
nft add rule ip filter output oifname "eth1" ip saddr 10.1.1.1 ip daddr 10.3.3.1 tcp dport 22 counter accept
nft add rule ip filter input iifname "eth1" ip daddr 10.1.1.1 ip saddr 10.3.3.1 tcp sport 22 ct state established counter accept
```

# Logging
volendo vedere quali pacchetti non vengono accettati (vengono scartati) , 
subito prima che vengano scartati dalla default policy DROP, possiamo ad esempio usare 

```
sudo nft add rule filter INPUT log prefix " input_end "
sudo nft add rule filter OUTPUT log prefix " output_end "
sudo nft add rule filter FORWARD log prefix " forward_end "
```

Per vedere i log sui router eseguiamo
```journalctl -k -f```


# NAT
Facciamo in modo che R1 finga di accettare connessioni ssh da Client, ridirigendole su S1

```
table nat {
        chain PREROUTING {
                type nat hook prerouting priority dstnat
                iif eth1 ip saddr 10.1.1.1 ip daddr 10.1.1.254 tcp dport 22 dnat to 10.2.2.1
        }
}
```

