for i in dev proc sys /dev/pts run ; do mount --bind /$i windev/$i; done
chroot windev <<EOF
DOCKER_BUILDKIT=1 docker build -t ghcr.io/fabceolin/windev:latest -f Dockerfile .
EOF
for i in /dev/pts dev proc sys run ; do umount -l windev/$i; done
