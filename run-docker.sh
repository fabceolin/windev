docker run -p 445:445 -p 5900:5900 -p 3389:3389 -p 32022:22 -eCPU=4 -eRAM=4096 --privileged -it --name usb --device=/dev/kvm --device=/dev/net/tun -v /sys/fs/cgroup:/sys/fs/cgroup:rw --cap-add=NET_ADMIN --cap-add=SYS_ADMIN --cap-add=DAC_READ_SEARCH -v /lib/modules/:/lib/modules/ --device=/dev/bus/usb --device=/dev/usb -v $HOME:/build ghcr.io/fabceolin/windev:usb bash

