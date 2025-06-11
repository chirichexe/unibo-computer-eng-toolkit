# NFTABLES

Ci sono diversi comandi a riga per aggiungere regole dettagliate,
ma il miglior modo rimane quello di inserire un set di regole tramite file.

La relazione che segue nftables è:
**tabelle** --contengono--> **catene** --contengono--> **regole**

**IMPORTANTE**:
Vanno create ed applicate delle regole su tutte le macchine per completezza,
aumentando il più possibile la robustezza del sistema di filtri.

Es:
se tra C1 <-> R1 <-> C2 ci si può solo scambiare pacchetti udp,
metto filtri per accettare udp su tutte le macchine:
su C1 e C2 di inviare e ricevere, su R1 per inoltrare.

---

```bash
## applica l'intera configurazione da file
nft -f <file.nftc>
```

si possono vedere le proprie modifiche effettuate con:
```bash
nft list ruleset
```

questi sono invece comandi per operazioni singole, necessarie se l'infrastuttura è già stata creata e bisogna modificarla.
```bash
# creazione
nft (add | create) chain [<family>] <table> <name>
[ \{ type <type> hook <hook> [device <device>] priority
<priority> \; [policy <policy> \;] \} ]

# manipolazione
nft (delete | list | flush) chain [<family>] <table> <name>

# rinomina
nft rename chain [<family>] <table> <name> <newname>

# GESTIONE REGOLE:
# aggiunta (in fondo)
nft add rule [<family>] <table> <chain> <matches> <statements>
# inserimento
nft insert rule [<family>] <table> <chain> [position <handle>] <matches> <statements>
# rimpiazzare
nft replace rule [<family>] <table> <chain> [handle <handle>] <matches> <statements>
# eliminare
nft delete rule [<family>] <table> <chain> [handle <handle>]

# ESEMPIO:
# a loro volta, i caratteri speciali e gli “a capo” vanno protetti da per farli interpretare
# letteralmente e non col significato speciale che avrebbero per la shell;
# l’intero comando può essere passato a nft come un unico parametro
nft 'add chain ip foo bar {
 type filter hook input priority 0; policy drop;
}'
```





## SINTASSI FILE CONFIGURAZIONE


```bash

# rimuove una catena da una tabella se esiste
# (da utilizzare in caso di setup, altrimenti perdi il setup attuale)
flush chain <nomeTabella> <nomeCatena>

# definisce una tabella
# famiglie disponibili: ip, arp, ip6, bridge, inet, netdev
table [family] <nome> {

  # HOOK:
  # l'hook stabilisce quando le regole della chain verranno esaminate dal s.o.
  # 
  # - INPUT : pacchetto arrivato destinato al sistema locale
  # - OUTPUT : pacchetto generato localmente e in fase di invio
  # - PREROUTING : pacchetto da inoltrare che è appena arrivato
  # - FORWARD : pacchetto in fase di inoltro verso un altro host
  # - POSTROUTING : pacchetto da inoltrare che sta per essere inviato

  chain <hook> {

    # -------------------------------------------------------------
    # TYPE
    # descrive funzionalmente la chain
    # -------------------------------------------------------------

    # MANIPOLAZIONI:
    # - filter : per filtrare pacchetti
    # - nat : per modificare indirizzi e porte dei pacchetti per servizio nat
    #         (es. server pubblici, instradamento forzato senza rotte)
    # - route : avanzato, prevede modifiche alle rotte di routing

    # PRIORITA':
    # indicano in che ordine il sistema operativo deve analizzare
    # chain agganciate allo stesso hook.
    # Vengono eseguite prima le chain con la PRIORITY PIU' BASSA (vabbè odio il mondo).
    #
    # In base a quando eseguirle, potrebbero essere saltate o anticipate azioni
    # che andranno svolte dal sistema operatio.
    #
    # Rappresentate da un intero, possiamo attingere ad un enum per una
    # dichiarazione più formale:
    #
    # - raw = -300                  (disabilita connection tracking)
    # - mangle = -200               (modifiche avanzate ai pacchetti)
    # - dstnat = -150               (pacchetto a cui si applicherà il nat - su prerouting)
    # - conntrack = -100            (connection tracking / ct state)
    # - filter = 0                  (consigliata)
    # - srcnat / masquerade = 100   (pacchetto con nat applicato - su postrouting)

    # POLICY: verdetto di default, applicato se non si ricade in nessuna regola.
    #         si mette SEMPRE, e all'inizio della chain.

    # nota: l'hook va ripetuto
    type <manipolazione> hook <hook> priority <tipoPriority>; policy <tipoPolicy>;
    



    # -------------------------------------------------------------
    # LISTA DI REGOLE
    # applicate dall'alto verso il basso.
    # ci si ferma se viene trovato un match e se ne applica il verdetto.
    # se finito di scorrere la lista, viene applicata la policy.
    # -------------------------------------------------------------

    # una regola è formata in una riga così:
    [insieme di condizioni] [monitoraggio] <verdetto>

    # DATA LINK:
    ether [saddr/daddr] <mac_address>

    # PROTOCOLLO:
    ip <protocol> # --> { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp }

    # IP:
    ip [saddr/daddr] <indirizzo>

    # INTERFACCE:
    # indica l'interfaccia da cui è uscito (input) o entrato (output) un pacchetto nel PROPRIO HOST.
    # raffina la selezione in aggiunta all'ip (un ip potrebbe derivare anche da un'interfaccia non autorizzata)
    #
    # su table filter, chain Input e Output, di solito si mettono sempre questi due:
    # - eth0 per quelli di Vagrant
    # - lo per il loopback
    #
    # iif [saddr <ip>] eth0 accept
    # iif lo accept
    # 
    # oif [saddr <ip>] eth0 accept
    # oif lo accept
    #
    [iif/oif] <nomeInterfaccia>

    # MATCH COMUNI PER PROTOCOLLI
    tcp sport / dport <port_spec>
    # port_spec può essere
    #   • PORTA
    #   • range Pstart-Pend
    #   • elenco { P1, P2, … }
    #   • negato con != port_spec
    # idem per udp
    tcp flags # --> { fin, syn, rst, psh, ack, urg, ecn, cwr }
    # è possibile scrivere espressioni logiche anche con bit mask es:
    tcp flags & (syn | ack) == syn | ack
    # si può specificare il tipo di pacchetto icmp
    icmp type <tipo>  # ---> { echo-request, echo-reply }


    # VERDETTI:
    # agiscono sul pacchetto
    #
    # - accept:        accetta il pacchetto e interrompe la valutazione
    # - drop:          elimina il pacchetto e interrompe la valutazione
    # - queue:         accoda il pacchetto nello spazio utente
    #                  e interrompe la valutazione
    # - continue:      continua la valutazione del set di regole
    #                  con la regola successiva.
    # - jump <catena>: continua alla prima regola di <catena>.
    #                  Continuerà alla regola successiva dopo che è stata emessa
    #                  un'istruzione return
    # - goto <catena>: simile a jump, ma dopo la nuova catena la
    #                  valutazione continuerà all'ultima catena anziché a quella
    #                  contenente l'istruzione goto
    # - return:        torna dalla catena corrente e continua alla regola successiva
    #                  dell'ultima catena. In una catena di base è equivalente ad accept


    # VERDETTI PER NAT:
    # cambia ip sorgente su pacchetto
    snat to <src_addr>
    # cambia ip destinatario su pacchetto
    dnat to <dest_addr>

    # MONITORAGGIO:
    log [level <lvl>] [prefix <string>]
    # – può essere seguito da
    #   • level { emerg, alert, crit, err, warn, notice, info, debug }
    #   • prefix <string>
    
    counter
    # – può inizializzare il contatore
    # • packets <num_p> bytes <num_b>

    # nft permette di eseguire più statement in una singola regola.
    # ovviamente uno solo può essere un verdict.
    
    # ES --- loggare pacchetto vietato e scartarlo:
    # nft add rule ip foo bar tcp dport !=80 log prefix "forbidden: " drop

  }

}
```


## ESEMPI - CODICI UTILI

### NAT FORWARD

```bash

# RETE:   10.2.2.1 --- (router) 10.2.2.254 | 10.3.3.254 --- 10.3.3.1
# non ci sono rotte statiche tra le sottoreti

# Voglio instradare solo pacchetti PING da 10.2.2.1 verso 10.3.3.1.

# Non avendo rotte statiche o dinamiche tra le due sottoreti, posso instradare i pacchetti
# sfruttando il NAT sul ROUTER.
# si vuole inoltrare i pacchetti all'ip del router inviati dal client verso l'altro,
# è l'unico modo per creare una specie di "rotta virtuale".
# Quindi quando l'host contatta il router, il router fa da intermediario per parlare con
# l'altro host nella sottorete opposta.

# si creano due tabelle per il router:
# - una nat conteneree regole di nat
# - una filter per contenere filtraggio pacchetti

table ip nat {

    chain prerouting {
        type nat hook prerouting priority dstnat;
        # Riceve pacchetti ping dal client, cambia il destinatario
        iif "eth1" ip saddr 10.2.2.1 ip daddr 10.2.2.254 icmp type echo-request dnat to 10.3.3.1
    }

    chain postrouting {
        type nat hook postrouting priority srcnat;
        # Risposta ping da 10.3.3.1 > 10.2.2.1, cambia indirizzo sorgente
        oif "eth3" ip saddr 10.3.3.1 ip daddr 10.2.2.1 icmp type echo-reply snat to 10.2.2.254
    }
}


table ip filter {

    chain forward {
        type filter hook forward priority filter; policy drop;
        # Richiesta ping
        iif "eth1" oif "eth3" ip saddr 10.2.2.1 ip daddr 10.3.3.1 icmp type echo-request accept
        # Risposta ping (stateful)
        iif "eth3" oif "eth1" ip saddr 10.3.3.1 ip daddr 10.2.2.1 icmp type echo-reply ct state established accept
    }

    chain input {
        type filter hook input priority filter; policy drop;
        # con vagrant si mettono sempre
        iif "eth0" accept
        iif "lo" accept
    }

    chain output {
        type filter hook output priority filter; policy drop;
        # con vagrant si mettono sempre
        oif "eth0" accept
        oif "lo" accept
    }

}

```