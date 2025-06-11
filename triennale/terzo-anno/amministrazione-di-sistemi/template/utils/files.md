## General
/root/.bash_history  <br>
/etc/hostmane

/dev/zero <br>
/dev/null <br>
/dev/random <br>

## Networking
### Server
/etc/network/interfaces
### Router
/etc/dnsqmasq.conf <br>
/etc/sysctl.conf(forward)

## Mounting
### Partizionamento 

### Fstab/NFS

/etc/fstab (tiene la corrisp
ondenza tra partizione e mountpoint, può essere usato per automatizzare il mount remoto) <br>
<br>
127.56.186.26:/home/${USERNAME} /home/$USERNAME nfs defaults 0 0"
<br>
<br>
/etc/exports (lanciare exportfs dopo le modifiche) <br>
<br>
[/home/$USERNAME 192.168.56.111(rw,no_subtree_check) ]


## Service
/etc/service/systemd/system/x.service  <br>
[
    /etc/inittab
]

## Cron
/etc/crontab (system wide)<br>
/var/spool/cron/crontabs/\<user>  (per utente, usare il comando crontab)<br>
<br>
di fatto, usare crontab -e da root: */20 8-19 * * 1-5 /root/count.sh

[ <br>
/etc/cron.hourly <br>
/etc/cron.daily <br>
/etc/weekly <br>
/etc/monthly <br>
]
## Logging
/etc/rsyslog.conf (generale)  <br> 
/etc/rsyslog.d (specifico)

## LDAP
/etc/ldap/ldap.conf <br>(BASE dc=labammsis<br> URI ldap://SERVERIP/ )<br> 
<br>
/etc/nsswitch.conf

## SNMPD
/etc/snmp/snmp.conf (commentare mibs)<br>
/etc/snmp/snmpd.conf