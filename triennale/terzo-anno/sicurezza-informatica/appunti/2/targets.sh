#!/bin/bash

function setuplab() {
	STUDENTID="$(whoami)"
    	mkdir -p ~/large/"VirtualBox VMs"
    	vboxmanage setproperty machinefolder "/home/LABS/$STUDENTID/large/VirtualBox VMs"
    
    	mkdir -p ~/large/.vagrant.d
    	test -L ~/.vagrant.d || { rm -rf ~/.vagrant.d ; ln -s ~/large/.vagrant.d ~/.vagrant.d ; }

	mkdir -p ~/large/.vagrant.d/boxes
	mkdir -p ~/large/.vagrant.d/boxes/debian-VAGRANTSLASH-bookworm64
	mkdir -p ~/large/.vagrant.d/boxes/debian-VAGRANTSLASH-bookworm64/12.20231211.1
	mkdir -p ~/large/.vagrant.d/boxes/debian-VAGRANTSLASH-bookworm64/12.20231211.1/virtualbox 

	test -L ~/large/.vagrant.d/boxes/debian-VAGRANTSLASH-bookworm64/metadata_url || { 
		ln -s /opt/vagrant/boxes/debian-VAGRANTSLASH-bookworm64/metadata_url ~/large/.vagrant.d/boxes/debian-VAGRANTSLASH-bookworm64/metadata_url
		ln -s /opt/vagrant/boxes/debian-VAGRANTSLASH-bookworm64/12.20231211.1/virtualbox/* ~/large/.vagrant.d/boxes/debian-VAGRANTSLASH-bookworm64/12.20231211.1/virtualbox/
    	}
	cd ~/large
}


hostname -I | grep -q '192\.168\.12.\.' && setuplab

mkdir scantargets
SKIP=$(awk '/^__TARFILE_FOLLOWS__/ { print NR + 1; exit 0; }' $0)
tail -n +${SKIP} $0 | base64 -d | tar -C scantargets -xzf -

cd scantargets
vagrant up

exit 0
# NOTE: Don't place any newline characters after the last line below.
__TARFILE_FOLLOWS__
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
