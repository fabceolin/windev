#!/bin/bash

# Script to install python3-pip, sshpass and ansible on the host machine

# Considering the mininum installation after focal debotstrapped chroot variant buildd
apt-get update
apt-get upgrade -y
apt-get install -y sshpass sudo python3 python3-distutils wget
wget https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py

python3 -m pip install pip --upgrade
python3 -m pip install ansible
