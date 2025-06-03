# Creazione rete
- **Obiettivo**: Configurare Client (10.1.1.1), Router e Server(10.2.2.2) (così)[https://virtuale.unibo.it/mod/book/view.php?id=1865521]

- **Strumenti**:
    - Journal
    - Ping
    - Tracepath da installare con iputils-tracepath
    - TCPDUMP da installare con tcpdump 

- **Strategia**:

> NOTA: dopo ogni modifica al file /etc/network/interfaces, per applicarle eseguire
> systemctl restart networking

1. Creo il Vagrantfile come indicato

2. Aggiungo gli IP manualmente con 

**Client**
```sh
sudo ip a add 10.1.1.1/24 dev eth1
sudo ip link set dev eth1 up

# rendo persistente la configurazione
# nel file /etc/network/interfaces

auto eth1
iface eth1 inet static
    address 10.1.1.1
    netmask 255.255.255.0
    up /usr/sbin/ip route add 10.2.2.0/24 via 10.1.1.254
```

**Router**

```
# nel file /etc/network/interfaces
auto eth1
iface eth1 inet static
    address 10.1.1.254
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 10.2.2.254
    netmask 255.255.255.0

# nel file /etc/sysctl.conf
net.ipv4.ip_forward=1

# applico con 
sysctl -p
```

**Server**

```
auto eth1
iface eth1 inet static
    address 10.2.2.2
    netmask 255.255.255.0
    up /usr/sbin/ip route add 10.1.1.0/24 via 10.2.2.254
```

**Controllare**

```
sudo tcpdump -i eth1 icmp
```


# Comandi utili per il debug
```sh
ip route # visualizza le rotte
```

# Configurazione rete attraverso Ansible
```
- name: Set eth3 netmask
  community.general.interfaces_file:
    iface: eth3
    option: 'netmask'
    value: '255.255.255.0'
    backup: yes
    state: present
  when: ansible_facts['os_family'] in ['Debian']
  notify: Restart Networking
            
handlers:
  - name: Restart Networking
    ansible.builtin.service:
       name: networking
       state: restarted

# oppure copia del file della config. di rete

- name: Copy a new network configuration "interfaces" file into place, after passing validation with ifup 

  ansible.builtin.copy:
    src: eth3
    dest: /etc/network/interfaces.d/eth3
    validate: /usr/sbin/ifup --no-act -i %s eth3
  notify: Restart Networking

handlers:
  - name: Restart Networking
    ansible.builtin.service:
      name: networking
      state: restarted

```

# Configurazione rete a interfaccia completa
Attivare sulle VM un'ulteriore interfaccia interna, collocandole tutte su LAN3.

Il nome dell'interfaccia cambierà a seconda di quante sono già attive: se su Client e Server sono presenti eth0 (navigazione) e eth1 (inserita per la configurazione client-router-server) la nuova interfaccia sarà eth2, mentre sul Router che usa due interfacce per l'esercizio già svolto sarà eth3.

# Configurazione DHCP

Abilitare su Router l'erogazione di indirizzi per Client

Nel file /etc/dnsmasq.conf aggiungere:

```sh

interface=eth1                            # mette il server in ascolto sull'interfaccia
dhcp-range=10.1.1.10,10.1.1.20,12h        # definisce il range di indirizzi da erogare
dhcp-option=3                             # inibisce il comportamento di default, che indicherebbe 
                                          # a Client di prendere come default gateway Router (10.1.1.254) 
                                          # mentre noi vogliamo che resti quello di VirtualBox (10.0.2.2)
dhcp-option=option:ntp-server,10.1.1.254
dhcp-option=option:dns-server,10.1.1.254
dhcp-option=121,10.2.2.0/24,10.1.1.254    # consegna a Client la rotta statica per raggiungere Server
```

Sostituire le quattro righe sotto "auto eth1" con la singola riga

```iface eth1 inet dhcp```

N.B il lease del DHCP lato Router è stato impostato ogni 12h, qualora voleste fare delle prove continue per forzare il DHCP dal client ed ottenere un nuovo indirizzo è possibile tramite privilegi di amministratore usare il comando:

sudo dhclient -v
