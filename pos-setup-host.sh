#!/bin/bash
for i in /dev/pts dev proc sys run ; do umount -l windev/$i; done
