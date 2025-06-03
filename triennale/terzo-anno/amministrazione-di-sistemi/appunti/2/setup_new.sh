#!/bin/bash

STUDENT_ID="$(whoami)"

mount | grep -q large || { echo "La directory ~/large necessaria per le VM non è stata montata correttamente, è necessario riavviare il sistema" ; exit 1 ; }

mkdir -p ~/large/"VirtualBox VMs"

vboxmanage setproperty machinefolder "/home/LABS/$STUDENT_ID/large/VirtualBox VMs"

echo "Sto per ripulire le precedenti istanze di VM vagrant, per interrompere premere CTRL-C, per proseguire premere Invio"

read a

rm -rf ~/.vagrant.d ~/large/.vagrant.d

mkdir -p ~/large/.vagrant.d/boxes/

ln -s ~/large/.vagrant.d ~/.vagrant.d

mkdir -p ~/large/.vagrant.d/boxes/debian-VAGRANTSLASH-bookworm64/12.20250126.1/amd64/virtualbox/

ln -s /opt/vagrant/boxes/debian-VAGRANTSLASH-bookworm64/metadata_url ~/large/.vagrant.d/boxes/debian-VAGRANTSLASH-bookworm64/metadata_url

ln -s /opt/vagrant/boxes/debian-VAGRANTSLASH-bookworm64/12.20250126.1/amd64/virtualbox/* ~/large/.vagrant.d/boxes/debian-VAGRANTSLASH-bookworm64/12.20250126.1/amd64/virtualbox/

echo '# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box_check_update = false

  config.vm.provider "virtualbox" do |vb|
     vb.memory = "512"
     vb.linked_clone = true
  end
end
' > ~/large/.vagrant.d/Vagrantfile


