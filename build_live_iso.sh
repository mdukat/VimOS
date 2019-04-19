#!/bin/bash

# Build VimOS.iso image
genisoimage -o VimOS.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -J -R -V VimOS ./isoroot/

# Apply MBR to VimOS.iso image
perl ./syslinux-6.03/bios/utils/isohybrid.pl VimOS.iso
