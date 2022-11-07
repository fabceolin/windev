#!/usr/bin/env bash

# Script to install python3-pip, sshpass and ansible on the host machine

# Considering the mininum installation after focal debotstrapped chroot variant buildd
mkdir windev
sudo debootstrap --variant=buildd jammy windev
python3 -m pip install pip --upgrade
python3 -m pip install ansible
for i in dev proc sys /dev/pts run ; do mount --bind /$i windev/$i; done
chroot windev <<EOF
cd /root
apt-get update
apt-get upgrade -y
apt-get install software-properties-common -y || true
apt-add-repository universe
mv /var/lib/dpkg/info/systemd.postinst /var/lib/dpkg/info/systemd.postinst.orig
dpkg --configure --pending
add-apt-repository multiverse
apt-get install -y sshpass sudo python3 python3-distutils wget python3-pip
python3 -m pip install pip --upgrade
python3 -m pip install ansible
EOF
# for i in /dev/pts dev proc sys run ; do umount -l windev/$i; done
