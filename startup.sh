#!/bin/bash


[ -z "$CPU" ] && export CPU=4
[ -z "$RAM" ] && export RAM=4096
[ -z "$DRIVER" ] && export DRIVER=kvm
set -eou pipefail
chown root:kvm /dev/kvm || true

service libvirtd start
service virtlogd start
service smbd start
VAGRANT_DEFAULT_PROVIDER=libvirt vagrant up
iptables-save > $HOME/firewall.txt
sysctl -w net.ipv4.conf.all.route_localnet=1
rsyslogd
IP=$(vagrant ssh-config | grep HostName | awk '{ print $2 }')
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

iptables -A FORWARD -i eth0 -o virbr1 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i virbr1 -o eth0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

iptables -A FORWARD -i eth0 -o virbr1 -p tcp --syn --dport 3389 -m conntrack --ctstate NEW -j ACCEPT
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 3389 -j DNAT --to-destination $IP
iptables -t nat -A POSTROUTING -o virbr1 -p tcp --dport 3389 -d $IP -j SNAT --to-source 192.168.121.1

iptables -A FORWARD -i eth0 -o virbr1 -p tcp --syn --dport 22 -m conntrack --ctstate NEW -j ACCEPT
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 22 -j DNAT --to-destination $IP
iptables -t nat -A POSTROUTING -o virbr1 -p tcp --dport 22 -d $IP -j SNAT --to-source 192.168.121.1

iptables -t nat -A OUTPUT -m addrtype --src-type LOCAL --dst-type LOCAL -p tcp --dport 32023 -j DNAT --to-destination $IP:22
iptables -t nat -A OUTPUT -m addrtype --src-type LOCAL --dst-type LOCAL -p tcp --dport 3390 -j DNAT --to-destination $IP:3389
iptables -t nat -A POSTROUTING -m addrtype --src-type LOCAL --dst-type UNICAST -j MASQUERADE

iptables -D FORWARD -o virbr1 -j REJECT --reject-with icmp-port-unreachable
iptables -D FORWARD -i virbr1 -j REJECT --reject-with icmp-port-unreachable
iptables -D FORWARD -o virbr0 -j REJECT --reject-with icmp-port-unreachable
iptables -D FORWARD -i virbr0 -j REJECT --reject-with icmp-port-unreachable

exec "$@"
