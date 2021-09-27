docker run  -p 3389:3389 -p 32022:22 --privileged -it --name kvmcontainer1 --device=/dev/kvm --device=/dev/net/tun -v /sys/fs/cgroup:/sys/fs/cgroup:rw --cap-add=NET_ADMIN --cap-add=SYS_ADMIN --cap-add=DAC_READ_SEARCH -v /lib/modules/$(uname -r):/lib/modules/$(uname -r) -v /home/ceolin/src:/build ubuntukvm:latest bash

