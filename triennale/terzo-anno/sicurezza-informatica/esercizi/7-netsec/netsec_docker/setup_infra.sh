#!/bin/bash
sudo docker load -i ./netsec.tar
sudo docker-compose up > log 2>&1 &

echo "Configuring Aliases...."
echo "....."
if grep -q .zshrc_aliases ~/.zshrc
then
	echo "Aliases source file already present"

else
	echo "Adding aliases source file to .zshrc"
	echo "source ~/.zshrc_aliases" >> ~/.zshrc
fi

echo "....."

if [ -f ~/.zshrc_aliases ]; then
	echo "Removing aliases file"
	rm ~/.zshrc_aliases
fi

echo "alias hostA='sudo docker exec -it A-10.9.0.5 /bin/bash'" >> ~/.zshrc_aliases
echo "alias hostB='sudo docker exec -it B-10.9.0.6 /bin/bash'" >> ~/.zshrc_aliases
echo "alias hostM='sudo docker exec -it M-10.9.0.105 /bin/bash'" >> ~/.zshrc_aliases
echo "Import aliases with command:   . ~/.zshrc_aliases"

echo "Now you can open a shell as root in each docker using commands: hostA; hostB; hostM."



