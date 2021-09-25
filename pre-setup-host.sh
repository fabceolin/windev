#!/bin/bash

# Script to install python3-pip, sshpass and ansible on the host machine

apt-get update
apt-get install -y python3-pip sshpass sudo

python3 -m pip install pip --upgrade
python3 -m pip install ansible
