echo "passwd: files systemd ldap
group: files systemd ldap
shadow: files ldap
# opzionalmente: gshadow: files ldap" >> /etc/nsswitch.conf

sudo systemctl restart nscd.service
