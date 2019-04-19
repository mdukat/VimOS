liveiso: initramfs
	chmod +x build_live_iso.sh
	./build_live_iso.sh

deps:
	apt-get update
	## Kernel, Syslinux, Busybox
	apt-get -y install bison flex gcc make exuberant-ctags bc libssl-dev libelf-dev nasm uuid-dev
	## Neovim
	apt-get -y install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip git
	## Tools
	apt-get -y install genisoimage perl

binaries: deps
	chmod +x build_binaries.sh
	./build_binaries.sh

development: binaries
	chmod +x build_development.sh
	./build_development.sh

initramfs: development
	chmod +x build_initramfs.sh
	./build_initramfs.sh
