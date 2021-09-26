#!/bin/bash

# Script to install python3-pip, sshpass and ansible on the host machine

# Considering the mininum installation after focal debotstrapped chroot variant buildd
mkdir windev
sudo debootstrap --variant=buildd focal windev
for i in dev proc sys /dev/pts do mount --bind /$i windows/$i; done
chroot windev <<EOF
cd /root
apt-get update
apt-get upgrade -y
apt-get install -y sshpass sudo python3 python3-distutils wget
wget https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py

python3 -m pip install pip --upgrade
python3 -m pip install ansible
EOF
