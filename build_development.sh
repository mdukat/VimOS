#!/bin/bash

# Change working directory to isoroot
cd isoroot

# Copy Kernel to isoroot
cp ../linux-5.0.7/arch/x86_64/boot/bzImage .

# Copy Isolinux to isoroot
cp ../syslinux-6.03/bios/core/isolinux.bin ./isolinux/isolinux.bin
cp ../syslinux-6.03/bios/com32/elflink/ldlinux/ldlinux.c32 ./isolinux/ldlinux.c32

# Exit from isoroot
cd ..

# Change working directory to initrdroot
cd initrdroot

# Make directories
mkdir -p bin dev lib/x86_64-linux-gnu lib64 proc sys user usr/local/share/nvim

# Make init executable
chmod +x init

# Make udhcpc script executable
chmod +x usr/share/udhcpc/default.script

# Copy Busybox to initrdroot
cp ../busybox-1.30.1/busybox ./bin/

# Copy Neovim to initrdroot
cp ../neovim/build/bin/nvim ./bin/
cp -r ../neovim/runtime/* ./usr/local/share/nvim/

# Copy shared dependencies to initrdroot
cp /lib64/ld-linux-x86-64.so.2 ./lib64/
cp /lib/x86_64-linux-gnu/librt.so.1 /lib/x86_64-linux-gnu/libpthread.so.0 /lib/x86_64-linux-gnu/libnsl.so.1 /lib/x86_64-linux-gnu/libdl.so.2 /lib/x86_64-linux-gnu/libutil.so.1 /lib/x86_64-linux-gnu/libgcc_s.so.1 /lib/x86_64-linux-gnu/libc.so.6 /lib/x86_64-linux-gnu/libm.so.6 /lib/x86_64-linux-gnu/libresolv.so.2 ./lib/x86_64-linux-gnu/

# Generate Busybox links
cd bin
ln -s busybox ash
ln -s busybox sh
ln -s busybox mount
ln -s busybox umount
ln -s busybox rm
ln -s busybox cd
ln -s busybox mknod
ln -s busybox chvt
ln -s busybox openvt
ln -s busybox ls
ln -s busybox clear
ln -s busybox echo
ln -s busybox ip
ln -s busybox ifconfig
ln -s busybox udhcpc
ln -s busybox route
ln -s busybox exit
ln -s busybox ps
ln -s busybox poweroff
ln -s busybox mkfs.ext2
ln -s busybox cp
ln -s busybox mv
ln -s busybox grep
ln -s busybox dmesg
ln -s busybox find
ln -s busybox cpio
ln -s busybox gzip
ln -s busybox gunzip
ln -s busybox mkdir
ln -s busybox cat
ln -s busybox fdisk
ln -s busybox df
cd ..

# Copy mbr.bin and extlinux binaries from syslinux
cp ../syslinux-6.03/bios/mbr/mbr.bin ./user/mbr.bin
cp ../syslinux-6.03/bios/extlinux/extlinux ./bin/extlinux

# Exit from initrdroot directory
cd ..

