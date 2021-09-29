# Quickstart

Download the docker image:

```
docker pull ghcr.io/fabceolin/windev
```

Creating the container with 4 CPUs and 2 GB RAM called windev:

```
docker run -p 5900:5900 -p 3389:3389 -p 32022:22 -eCPU=4 -eRAM=2048 --privileged -it --name windev --device=/dev/kvm --device=/dev/net/tun -v /sys/fs/cgroup:/sys/fs/cgroup:rw --cap-add=NET_ADMIN --cap-add=SYS_ADMIN --cap-add=DAC_READ_SEARCH -v /lib/modules/:/lib/modules/ ghcr.io/fabceolin/windev:latest bash
```

SSH to Windows Machine

```
sshpass -pvagrant ssh -p 32022 -o StrictHostKeyChecking=no vagrant@localhost
```

VNC to Windows Machine

```
xtightvncviewer localhost:5900
```

RDP to Windows Machine

```
xfreerdp /u:vagrant /p:vagrant  /d:workgroup /v:localhost:3389
```



# Introduction

I create this docker image inspired by work from Microsoft here https://developer.microsoft.com/pt-br/windows/downloads/virtual-machines/ , allowing creating fresh Windows installation inside container instantly with difference that we can personalize the Windows before usage.


The Windows 2019 license is valid for 180 days and Office for 5 days after the first boot. 



   