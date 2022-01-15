# Quickstart

Download the docker image (available tags: office, usb, qt, latest, experimental, minimal) :

```
docker pull ghcr.io/fabceolin/windev:latest
```

Creating the container with 4 CPUs and 2 GB RAM using kvm (to use without virtualization acceleration, use DRIVER=qemu instead and remove --device=/dev/kvm parameter) called windev:

```
git clone git@github.com:fabceolin/windev.git
cd windev
docker run -p 5900:5900 -p 3389:3389 -p 32022:22 -eDRIVER=kvm -eCPU=4 -eRAM=2048 --privileged -it --name windev --device=/dev/kvm --device=/dev/net/tun -v /sys/fs/cgroup:/sys/fs/cgroup:rw --cap-add=NET_ADMIN --cap-add=SYS_ADMIN --cap-add=DAC_READ_SEARCH -v /lib/modules/:/lib/modules/ -v $HOME:/build -v $PWD/Vagrantfile:/Vagrantfile -v $PWD/startup.sh:/startup.sh ghcr.io/fabceolin/windev:latest bash
```

SSH to Windows Machine

```
sshpass -pvagrant ssh -p 32022 -o StrictHostKeyChecking=no vagrant@localhost
```

VNC to Windows Machine (to view BIOS and Windows Boot)

```
xtightvncviewer localhost:5900
```

RDP to Windows Machine (to access Windows after boot)

```
xfreerdp /u:vagrant /p:vagrant  /d:workgroup /v:localhost:3389
```

Accessing linux home from Windows:
```
sshpass -pvagrant ssh -p 32022 vagrant@localhost
net use s: \\172.17.0.3\home /user:root root
s:
```


# Introduction

I create this docker image inspired by work from Microsoft here https://developer.microsoft.com/pt-br/windows/downloads/virtual-machines/, allowing creating fresh Windows installation inside container instantly with difference that we can personalize the Windows before usage.

The Windows 2019 license is valid for 180 days and Office for 5 days after the first boot. 

# Features

* Windows has opengl 4.1 enabled via software with mesa drivers

# Pre installed (branch master) on :latest
* msys2 environment
    * base-devel
    * dos2unix
    * git
    * libbz2-devel
    * mingw-w64-x86_64-binutils
    * mingw-w64-x86_64-boost
    * mingw-w64-x86_64-bzip2
    * mingw-w64-x86_64-cmake
    * mingw-w64-x86_64-extra-cmake-modules
    * mingw-w64-x86_64-gcc
    * mingw-w64-x86_64-iconv
    * mingw-w64-x86_64-icu
    * mingw-w64-x86_64-libtool
    * mingw-w64-x86_64-libzip
    * mingw-w64-x86_64-python
    * mingw-w64-x86_64-toolchain
    * mingw-w64-x86_64-tools
    * mingw-w64-x86_64-zlib
    * p7zip
    * pv
    * python3-pip
    * rsync
    * unzip
* Visual Studio 2019 buildtools (cli)
* Firefox 
* 7zip.portable
* busybox (gnu commands under msdos prompt)
* cmake
* conemu
* git
* innosetup
* firefox
* microsoft-office-deployment
* msys2
* ninja
* rapidee
* sed
* vim
* wget
* dependencywalker

# Other branches

You can check what is installed on the file windev_Ansible.yml

* :qt - The same the master, but some qt tools
* :usb - Same as office, but configured to use a specific usb device inside Windows. You can change de Vagrantfile to change the usb device
* :experimental - Same as qt, but used for testing more things
* :office - Chrome and Microsoft Office installed
* :minimal - Only firefox, 7zip and python installed with software 3d drivers
* :latest - image of master branch

# Pre requisites do build a image
You need debootstrap, docker, sshpass, python3, python3-pip installed on host
## on ubuntu
```
sudo apt-get install -y debootstrap docker.io sshpass python3 python3-pip
```

# Building docker image

You need to run the commands below as root:

```
# Bind some dirs inside chroot
bash pre-setup-host.sh
#The command below can take some hours to run. You need 300GB free on the device (I will improve this on the future)
ansible-playbook -i chroot -c chroot setup-host.yml
# Unmount binded dirs
bash pos-setup-host.sh
```

# Known bugs

You need to login over VNC, open the browser and try to access the internet to enable the internet. If you discover how to avoid this to access internet over ssh only, let me know.
