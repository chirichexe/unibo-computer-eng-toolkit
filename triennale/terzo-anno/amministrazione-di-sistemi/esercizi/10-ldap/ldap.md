# LDAP

Diventa sudo, poi:

```sh
apt install slapd # devo impostare una password gennaio.marzo

dpkg-reconfigure slapd # no, labammsis, Unibo, gennaio.marzo, yes, yes
```

Per collegarsi al server **LDAP** per interrogare:

- ```-Y EXTERNAL -H ldapi:///```: utilizza l'utente che invoca il comando per autenticarsi su socket Unix locale
- ```-x -H ldap:// IP.DEL.SERVER /```: 

Esempio di comando che ci dà il risultato (file ldif) che dentro ha una sola entry 
```sh
ldapsearch -x  \                # -x attiva autenticazione, 
-D "cn=admin,dc=labammsis" \    # -D username
-w "gennaio.marzo" \            # -w password
-H ldap://10.0.2.15/ \          # ip macchina 
-b "dc=labammsis" \                  
-s sub
```

Il risultato del file **ldif** sono coppie attribute-type:nome-attributo.

[Link](https://oav.net/mirrors/LDAP-ObjectClasses.html) per gli objectclasses. 

Per poter usare LDAP come strumento standard per autenticare gli utenti, dobbiamo avere un 
**nodo intermedio** sotto il quale vengono autenticati tutti gli utenti simile a /etc/passwd

Per questo vengono creati nella gerarchia di LDAP diverse Organizational Unit (ou), di default

- ou=People,dc=labammsis per gli **utenti**
- ou=Groups,dc=labammsis per i **gruppi**

L'ldif ha:

```js
// PRIMA RIGA: distinguished name
dn: ou=People,dc=labammsis

// objectclass, la entry è tipo ou, quindi ou=Peole
objectClass: organizationalunit
ou: People

// descrizione
description: system users
```

Come faccio a inserire la entry nella directory? Innanzitutto lo salvo in un file people.ldif

```sh
ldapadd -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://10.0.2.15/ -f people.ldif
#output
adding new entry "ou=People,dc=labammsis"
```
Rifacendo l'ldapsearch vediamo che c'è un'altra entry:

```
# People, labammsis 
dn: ou=People,dc=labammsis //stessa cosa con Groups
objectClass: organizationalUnit
ou: People //stessa cosa con Groups
description: system users
```

Per ```eliminare ``` faccio ldapdelete, sempre con autenticazione, e dò il **distinguished name**

# Utilizzo del template

Guardando il template, ricordiamoci che dobbiamo scegliere due numeri inutilizzati come uid e gid:

```
uidNumber: 10000
gidNumber: 10000
```

Quindi avrebbe senso prima cercarli tutti e incrementarlo proceduralmente.

Esempio di query filtrata: 

```sh
ldapsearch -x -H ldap://10.0.2.15/ -b "dc=labammsis" -s one '(|(uid=anna)(uidNumber=10003))' sn
```

# Configurazione di NSS 

```sh
sudo apt install libnss-ldapd

echo "passwd: files systemd ldap
group: files systemd ldap
shadow: files ldap
# opzionalmente: gshadow: files ldap" >> /etc/nsswitch.conf && sudo systemctl restart nscd.service

sudo systemctl restart nscd.service
```

Con ```getent passwd``` verranno mostrati. 

# Configurazione di PAM

Aggiungere su /etc/pam.conf:

	BASE    dc=labammsis
URI     ldapi:///

# Modificare una entry

```ldapmodify -x -D cn=admin,dc=labammsis -w gennaio.marzo -f chsh.ldif```

# Aggiungere una password a un utente
```ldappasswd -D cn=admin,dc=labammsis -w gennaio.marzo uid=davide,ou=People,dc=labamsis -s ciaociao```

# Permessi SUDO
```sh
sudo apt install sudo-ldap


```

> Sono arrivato al 14

