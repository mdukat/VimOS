#!/bin/bash

# Change working directory to initrdroot
cd initrdroot

# Build initramfs
find . -print0 | cpio --null --create --verbose --format=newc | gzip --best > ../isoroot/initramfs.cpio.gz

# Exit from initrdroot directory
cd ..

