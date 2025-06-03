#!/bin/bash

FILE_LOG=/var/log/newusers
SNMP_AGENT=$(hostname -I | egrep -o "10\.(11|22).(11|22)").1


while read MON DAY TIME R USER USERNAME ; do

	if [[ ! -e /home/$USERNAME ]]
	then
		mkdir -p /home/$USERNAME/.ssh
		chown -R $USERNAME:$USERNAME /home/$USERNAME
		chmod -R 700 /home/$USERNAME
	fi

	PUBKEY=$(snmpget -Ovq -v 1 -c public $SNMP_AGENT NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"${USERNAME}_PUB\")

	if [[ $(hostname) =~ C[0-9]+ ]] 
	then
		# if on client
		snmpget -Ovq -v 1 -c public $SNMP_AGENT NET-SNMP-EXTEND-MIB::nsExtendOutputFull.\"${USERNAME}_PRIV\" > /home/$USERNAME/.ssh/id_rsa
		echo "$PUBKEY" > /home/$USERNAME/.ssh/id_rsa.pub

		chown $USERNAME:$USERNAME /home/$USERNAME/.ssh/id_rsa*
		chmod 400 /home/$USERNAME/.ssh/id_rsa
		chmod 444 /home/$USERNAME/.ssh/id_rsa.pub
	elif [[ $(hostname) =~ S[0-9]+ ]]
	then
		# if on server
		grep "$PUBKEY" /home/$USERNAME/.ssh/authorized_keys || echo "$PUBKEY" >> /home/$USERNAME/.ssh/authorized_keys
		# in case it did not exist before
		chown $USERNAME:$USERNAME /home/$USERNAME/.ssh/authorized_keys
		chmod 644 /home/$USERNAME/.ssh/authorized_keys
	fi


done < $FILE_LOG


