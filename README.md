# VimOS
Or as I've recently taken to calling it, Vim + Linux

## Download
Check "Releases" page!

## How do i power off my machine?
In vim: `:!poweroff -f`. In future i want to make some sort of daemon which will check if nvim stopped running, and power off the system.

## Quick build
On debian live image, execute `Debian_Build.sh`. It will download all needed files and build live image.

```bash
git clone https://github.com/d3suu/VimOS
cd VimOS
chmod +x Debian_Build.sh
./Debian_Build.sh
qemu-system-x86_64 -enable-kvm -cdrom VimOS.iso -boot d
```

### Emulation
Simply use qemu.

```bash
qemu-system-x86_64 -enable-kvm -cdrom VimOS.iso -boot d
```

### Running on real hardware
You can simply put it on pendrive using dd. (In example `/dev/sdX' should be your pendrive device)

```bash
dd if=VimOS.iso of=/dev/sdX bs=1M status=progress
```

## Development
For development its best to run `./build_binaries.sh` and `./build_development.sh`. These will build everything that is needed, and make root trees. From there, you can make whatever changes to the system that you like, and simply build live image using `./build_initramfs.sh` and `./build_live_iso.sh`.

At this moment, list of things i would like to make is pretty long (networking, daemons, hard drive installer), but if you think you made something cool, feel free to make pull request! This OS is made purely for fun, and its not the best example of how Linux distribution should be made.
