#!/bin/bash
# please report bugs to marco.prandini@unibo.it


function repline() {
	# 1=regex 2=user 3=lab 4..=files
	# regex = lines to purge
	# STDIN = new lines
	#
	R=$1
	U=$2
	L=$3
	shift 3

	if [ $U = 'root' ] ; then P=sudo ; else P="" ; fi

	N=$(cat)
	
	for F in "$@" ; do
		T=$(mktemp)
		echo "purging /$R/i from $F"
		$P grep -vi $R $F 2>/dev/null > $T
		if [[ $LAB != 'N' ]] ; then 
			echo "adding lines to $F"
			echo "$N" >> $T
		fi
		cat $T | $P tee $F
		echo 
		echo ............................................................
		echo
		rm -f $T
	done
}
	
LAB=$1
if ! [[ $LAB =~ ^[0,2,3,4,9,N]$ ]] ; then
	echo 'Usage: setup_lab.sh [0,2,3,4,9,N]
	(use N to remove proxy configuration for home use)'
	exit 1
fi

echo 'Acquire::http::Proxy "http://192.168.12'$LAB'.249:8080/";
Acquire::https::Proxy "http://192.168.12'$LAB'.249:8080/";' | 
	repline proxy root $LAB /etc/apt/apt.conf.d/proxy.conf

echo 'export http_proxy="http://192.168.12'$LAB'.249:8080" 
export https_proxy="http://192.168.12'$LAB'.249:8080"
export HTTP_PROXY="http://192.168.12'$LAB'.249:8080" 
export HTTPS_PROXY="http://192.168.12'$LAB'.249:8080"' |
	repline proxy kali $LAB ~/.bashrc ~/.zshrc

echo 'export http_proxy="http://192.168.12'$LAB'.249:8080" 
export https_proxy="http://192.168.12'$LAB'.249:8080"
export HTTP_PROXY="http://192.168.12'$LAB'.249:8080" 
export HTTPS_PROXY="http://192.168.12'$LAB'.249:8080"' |
	repline proxy root $LAB ~root/.bashrc ~root/.zshrc

echo 'user_pref("network.proxy.backup.ssl", "");
user_pref("network.proxy.backup.ssl_port", 0);
user_pref("network.proxy.http", "192.168.12'$LAB'.249");
user_pref("network.proxy.http_port", 8080);
user_pref("network.proxy.no_proxies_on", "192.168.0.0/16, 172.16.0.0.12, 10.0.0.0/8");
user_pref("network.proxy.share_proxy_settings", true);
user_pref("network.proxy.ssl", "192.168.12'$LAB'.249");
user_pref("network.proxy.ssl_port", 8080);
user_pref("network.proxy.type", 1);' | 
	repline network.proxy kali $LAB $(find ~ -name prefs.js | sed -e 's/prefs/user/')

sudo mkdir -p /etc/systemd/system/docker.service.d
echo '[Service]' | sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf

if [[ $LAB != 'N' ]] ; then 
	sudo sed -i -e 's/http\.kali\.org/kali.mirror.garr.it/g' /etc/apt/sources.list
	echo 'Environment="HTTP_PROXY=http://192.168.12'$LAB'.249:8080"
Environment="HTTPS_PROXY=http://192.168.12'$LAB'.249:8080"' | sudo tee -a /etc/systemd/system/docker.service.d/http-proxy.conf
fi

sudo systemctl daemon-reload
sudo systemctl restart docker


