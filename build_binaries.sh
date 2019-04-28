#!/bin/bash

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
	# VesaFB and hostname fix
	sed -i 's/# CONFIG_FB_VESA is not set/CONFIG_FB_VESA=y/' .config
	sed -i 's/(none)/VimOS/' .config
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
