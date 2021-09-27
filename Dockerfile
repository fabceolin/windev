# syntax=docker/dockerfile:experimental
FROM ubuntu:18.04
RUN sed -i -e 's/http:\/\/archive\.ubuntu\.com\/ubuntu\//mirror:\/\/mirrors\.ubuntu\.com\/mirrors\.txt/' /etc/apt/sources.list
RUN apt-get update -y
RUN apt-get install -y qemu-kvm 
RUN apt-get install -y libvirt-daemon-system
RUN apt-get install -y libvirt-dev
RUN apt-get install -y rsyslog
RUN apt-get install -y curl 
RUN apt-get install -y net-tools
RUN apt-get install -y busybox-static 
RUN apt-get autoclean
RUN apt-get autoremove
RUN --mount=type=bind,target=/tmp/vagrant_2.2.16_x86_64.deb,source=vagrant_2.2.16_x86_64.deb,rw \
    dpkg -i /tmp/vagrant_2.2.16_x86_64.deb
RUN vagrant plugin install vagrant-libvirt
RUN --mount=type=bind,target=/tmp/windows_2019_libvirt.box,source=windows_2019_libvirt.box,rw \
    vagrant box add windev /tmp/windows_2019_libvirt.box
RUN vagrant init windev
COPY Vagrantfile /
COPY startup.sh /
COPY exports /etc/exports
VOLUME /exports
EXPOSE 111/udp 111/tcp 2049/tcp 2049/udp 5900/tcp 5900/udp
ENTRYPOINT ["/startup.sh"]

