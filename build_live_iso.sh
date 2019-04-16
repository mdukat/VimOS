#!/bin/bash

if [ $(whoami) != "root" ]
then
	echo "Run me as root!"
	exit
fi

# Dependencies
apt-get update
## Kernel, Syslinux, Busybox
apt-get -y install bison flex gcc make exuberant-ctags bc libssl-dev libelf-dev nasm uuid-dev
## Neovim
apt-get -y install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip git
## Tools
apt-get -y install genisoimage perl

# Download and build Neovim
if [ ! -d "neovim" ]; then
	git clone https://github.com/neovim/neovim
fi

if [ ! -f "neovim/build/bin/nvim" ]; then
	cd neovim
	make CMAKE_BUILD_TYPE=Release
	cd ..
fi
# Neovim is in neovim/build/bin/nvim

# Download and build Kernel
if [ ! -d "linux-5.0.7" ]; then
	wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.0.7.tar.xz
	tar xvf linux-5.0.7.tar.xz
fi

if [ ! -f "linux-5.07/arch/x86_64/boot/bzImage" ]; then
	cd linux-5.0.7
	make defconfig
	make -j4
	cd ..
fi
# Kernel is in linux-5.0.7/arch/x86_64/boot/bzImage

# Download and build Syslinux
if [ ! -d "syslinux-6.03" ]; then
	wget https://mirrors.edge.kernel.org/pub/linux/utils/boot/syslinux/6.xx/syslinux-6.03.tar.xz
	tar xvf syslinux-6.03.tar.xz
fi

if [ ! -f "syslinux-6.03/bios/core/isolinux.bin" ]; then
	cd syslinux-6.03
	make bios installer -j4
	cd ..
fi
# Syslinux files are:
#	- syslinux-6.03/bios/core/isolinux.bin
#	- syslinux-6.03/bios/com32/elflink/ldlinux/ldlinux.c32

# Download and build Busybox
if [ ! -d "busybox-1.30.1" ]; then
	wget https://www.busybox.net/downloads/busybox-1.30.1.tar.bz2
	tar xvf busybox-1.30.1.tar.bz2
fi

if [ ! -f "busybox-1.30.1/busybox" ]; then
	cd busybox-1.30.1
	make defconfig
	make -j4
	cd ..
fi
# Busybox is in busybox-1.30.1/busybox

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
ln -s busybox mknod
ln -s busybox chvt
ln -s busybox openvt
ln -s busybox ls
ln -s busybox clear
ln -s busybox echo
cd ..

# Build initramfs
find . -print0 | cpio --null --create --verbose --format=newc | gzip --best > ../isoroot/initramfs.cpio.gz

# Exit from initrdroot directory
cd ..

# Build VimOS.iso image
genisoimage -o VimOS.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -J -R -V VimOS ./isoroot/

# Apply MBR to VimOS.iso image
perl ./syslinux-6.03/bios/utils/isohybrid.pl VimOS.iso
