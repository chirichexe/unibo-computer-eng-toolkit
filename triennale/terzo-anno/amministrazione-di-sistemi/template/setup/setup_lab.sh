#!/bin/bash

STUDENT_ID="$(whoami)"

mkdir -p ~/large/"VirtualBox VMs"

vboxmanage setproperty machinefolder "/home/LABS/$STUDENT_ID/large/VirtualBox VMs"

mkdir -p ~/large/.vagrant.d

ln -s ~/large/.vagrant.d ~/.vagrant.d

mkdir -p ~/large/.vagrant.d/boxes
mkdir -p ~/large/.vagrant.d/boxes/debian-VAGRANTSLASH-bookworm64
mkdir -p ~/large/.vagrant.d/boxes/debian-VAGRANTSLASH-bookworm64/12.20231211.1
mkdir -p ~/large/.vagrant.d/boxes/debian-VAGRANTSLASH-bookworm64/12.20231211.1/virtualbox 

ln -s /opt/vagrant/boxes/debian-VAGRANTSLASH-bookworm64/metadata_url ~/large/.vagrant.d/boxes/debian-VAGRANTSLASH-bookworm64/metadata_url

ln -s /opt/vagrant/boxes/debian-VAGRANTSLASH-bookworm64/12.20231211.1/virtualbox/* ~/large/.vagrant.d/boxes/debian-VAGRANTSLASH-bookworm64/12.20231211.1/virtualbox/
