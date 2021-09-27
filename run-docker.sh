docker run  -p 3389:3389 -p 32022:22 --privileged -it --name windev --device=/dev/kvm --device=/dev/net/tun -v /sys/fs/cgroup:/sys/fs/cgroup:rw --cap-add=NET_ADMIN --cap-add=SYS_ADMIN --cap-add=DAC_READ_SEARCH -v /lib/modules/:/lib/modules/ ghcr.io/fabceolin/windev:latest bash

