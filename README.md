# VimOS
Or as I've recently taken to calling it, Vim + Linux

## Download
Check "Releases" page!

## Building
`build_live_iso.sh` is meant to be runned on live debian distribution. It will download Linux kernel, Neovim, Syslinux and Busybox, build them, and make `VimOS.iso` image.
```bash
git clone https://github.com/d3suu/VimOS
cd VimOS
chmod +x build_live_iso.sh
./build_live_iso.sh
qemu-system-x86_64 -enable-kvm -cdrom VimOS.iso -boot d
```
