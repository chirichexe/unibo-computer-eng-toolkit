# cerca tutto
ldapsearch -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://10.0.2.15/ -b "dc=labammsis" -s sub

# elimina l'utente con uid=davide
ldapdelete -x -H ldapi:/// -D "cn=admin,dc=labammsis" -w "gennaio.marzo" "uid=davide,ou=People,dc=labammsis"

# ottiene tutti gli utenti
ldapsearch -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://10.2.2.1/ -b "ou=People,dc=labammsis" "(objectClass=posixAccount)"

# ottiene solo l'utente con uid=dave
ldapsearch -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://10.0.2.15/ -b "ou=People,dc=labammsis" "(uid=dave)"

# modifica solo la mail
echo "dn: uid=dave,ou=People,dc=labammsis
changetype: modify
replace: mail
mail: nuovo.indirizzo@unibo.it" >> change_mail.ldif

ldapmodify -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://10.2.2.1/ -f change_mail.ldif

ldappasswd -x -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -H ldap://10.2.2.1/ -S "uid=filo,ou=People,dc=labammsis"

sudo ldappasswd -x -H ldapi:/// -D "cn=admin,dc=labammsis" -w "gennaio.marzo" -s "pippo" "uid=dave,ou=People,dc=labammsis"
