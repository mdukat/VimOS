# TODO
## Absolutely highest priority
 - [ ] - Build in docker

## High Priority
 - [x] - All hard drive devices ~~automount~~ *mknod* script at init (read from dmesg)
 - [x] - All busybox links
 - [ ] - Build configuration:
    - [ ] - 32/64bit
    - [ ] - vi/vim/nvim/both
    - [ ] - iso/rootfs
 - [ ] - Easier "from git to development" stage (bzLinux, syslinux binaries, ld-linux, glibc...)
 - [x] - User scripts executed from init (on installed OS - `handbook`) `(/etc/scripts ?)`
 - [ ] - Easy keys rebind at OS level
 - [ ] - Run vim in screen, instead of baremetal tty
    
## Low Priority
 - [ ] - VimOS logo
 - [ ] - VimOS Handbook `(this one needs to be rewritten :c)`
   - [ ] - English translation
 - [ ] - Building kernel within VimOS
 - [ ] - Compiler collection
 - [ ] - Python3
 - [ ] - Building *everything* from scratch (glibc, ld-linux...)
 - [ ] - Networking `(at this moment i was able to transfer some files with netcat over ethernet, but DHCP and routing to the WWW does not work properly)`
 - [ ] - Chroot on installed VimOS (handbook "how-to"?)
