# VimOS Handbook  
*Initless, Vim-oriented, Linux operating system.*
##### v0.1  
  
## Spis treści  
0. Podziękowania
1. Wprowadzenie  
	 - 1.1. Jak czytać ten dokument  
	 - 1.2. Pieprzenie o systemie  
	 - 1.3. Założenia systemu  
2. Zapoznanie z systemem  
	 - 2.1. Pobranie obrazu Live  
	 - 2.2. Przygotowanie środowiska wirtualnego  
	 - 2.3. Opis interfejsu użytkownika  
3. Krótkie wprowadzenie do Neovim  
	 - 3.1. Przedstawienie interfejsu  
	 - 3.2. Podstawowe tryby  
		 - 3.2.1. Tryb Normal  
		 - 3.2.2. Tryb Insert  
		 - 3.2.3. Tryb Visual  
	 - 3.3. Podstawowe komendy i wyłowywanie komend systemowych  
4. Budowanie ze źródeł  
	- 4.1. Dependency-hell  
	- 4.2. Szybka kompilacja  
	- 4.3. Kompilacja krok po kroku  
		 - 4.3.1. `build_binaries.sh`
		 - 4.3.2. `build_development.sh`  
		 - 4.3.3. `build_initramfs.sh`  
		 - 4.3.4. `build_live_iso.sh`  
5. Instalacja na dysku 
	 - 5.1. Stworzenie dysku wirtualnego
	 - 5.2. Bootujemy VimOS z dyskiem
	 - 5.3. Urządzenia `/dev/*`
	 - 5.4. Partycje i formatowanie
	 - 5.5. Rootfs, extlinux, initramfs, i kopiowanie plików
	 - 5.6. Wgranie MBR na dysk
> Kategorie niżej są nadal w trakcie budowy.
6. Modyfikacja i rozwijanie systemu  
	 - 6.1. Aktualizacja jądra Linux  
		 - 6.1.1. Z poziomu VimOS  
		 - 6.1.2. Z poziomu Development  
	 - 6.2. `mount` vs `/etc/fstab`  
	 - 6.3. Daemony  
	 - 6.4. Portowanie oprogramowania na VimOS  
7. VimOS od podszewki, czyli co w initramfs piszczy  
	 - 7.1. Bootup  
	 - 7.2. Syslinux/Extlinux  
	 - 7.3. Linux kernel  
	 - 7.4. `/init`  
	 - 7.5. Neovim  
  
## 0. Podziękowania
W tym miejscu chciałbym podziękować wszystkim, którzy przyczynili się do budowy systemu VimOS, jak i moich innych projektów.
  
## 1. Wprowadzenie  

### 1.1. Jak czytać ten dokument  
Jeśli chcesz tylko dowiedzieć się jak uruchomić, lub zbudować system VimOS: przeczytaj punkt *2. Zapoznanie z systemem*, oraz *4.2. Szybka kompilacja*.  

### 1.2. Pieprzenie o systemie  
VimOS powstał z idei żartu, w którym edytor tekstu Emacs jest stosowany jako cały system operacyjny. Pomysł przerodził się w bootujący system w jeden wieczór, a jego rozwój spowodował przypływ nowych informacji na temat tego, jak działają systemy operacyjne oparte na jądrze Linux, dla przynajmniej 3 osób które pomagały w czasie budowy.  
  
Dodatkowo, system VimOS nie jest typową dystybucją opartą na jądrze Linux. Znany wcześniej układ katalogów w "root'cie" jest tutaj delikatnie zmieniony. Nie istnieje tutaj również pojęcie "użytkownika"; jedynym użytkownikiem jesteś *Ty* i masz kontrolę nad całym systemem!  
  
### 1.3. Założenia systemu  
- Brak init'u (systemd, OpenRC, etc.)  
- Vim jedynym interfejsem użytkownika  
- Możliwość rozwijania VimOS, na nim samym  
- Minimalizm systemu i konfiguracji  
- Maksymalnie otwartoźródłowy system operacyjny (100% nie jest możliwe ze względu na sterowniki sprzętowe oraz dostępność i licencje kodu źródłowego)

## 2. Zapoznanie z systemem

### 2.1. Pobranie obrazu Live  
Aby pobrać obraz Live systemu VimOS, na stronie projektu należy kliknąć zakładkę "Releases" i wybrać wersję systemu którą chcemy pobrać.

### 2.2. Przygotowanie środowiska wirtualnego  
Najprostszym sposobem na uruchomienie systemu, jest zrobienie tego przy użyciu `qemu`. Qemu jest lekką maszyną wirtualną, którą możemy uruchomić z konsoli. W naszym przypadku, wszystkie obrazy systemu są budowane pod architekturę 64bitową, więc należy uruchomić program `qemu-system-x86_64`, i wybrać odpowiednie argumenty. Przykład poniżej:
```bash
qemu-system-x86_64 -enable-kvm -cdrom VimOS.iso -boot d
```
 - Argument `-enable-kvm` ma za zadanie wykorzystać [moduł wirtualizacji KVM](https://en.wikipedia.org/wiki/Kernel-based_Virtual_Machine), aby system w maszynie wirtualnej chodził płynniej.
 - Argument `-cdrom VimOS.iso` wskazuje, jaki obraz płyty powinien być "wsadzony" do wirtualnego napędu CD-ROM.
 - Argument `-boot d` wskazuje, aby maszyna wirtualna rozpoczęła proces bootowania z napędu CD-ROM.

Po otwarciu okna maszyny wirtualnej, powinien nam się ukazać mniej-więcej taki tekst:
```
SeaBIOS (version 1.10.2-1ubuntu1)

iPXE (http://ipxe.org) 00:03.0 C980 PCI2.10 PnP PMM+07F8DCF0 C980


Booting from DVD/CD...

ISOLINUX 6.03 2014-10-06 ETCD Copyright (C) 1994-2014 H. Peter Anvin et al
boot: _
```
W tym miejscu, możemy nacisnąć klawisz `TAB` aby wyświetlić możliwe opcje do zabootowania, lub po prostu nacisnąć klawisz `ENTER` który spowoduje uruchomienie pierwszego systemu z listy.

### 2.3. Opis interfejsu użytkownika

Po wybraniu systemu z listy, przeleci bardzo dużo informacji. Są to informacje dotyczące bootowania, które daje nam jądro Linux. Po chwili powinniśmy ujrzeć ekran powitalny VimOS.
```

	Welcome in VimOS!

		total	used	free
Mem:		101	16	57
Swap:		0	0	0

Linux (none) 5.0.7 #1 SMP Tue Apr 16 18:22:28 UTC 2019 x86_64 GNU/Linux

rootfs on / type rootfs (rw,size=45260k,nr_inodes=11315)
none on /proc type proc (rw,relatime)
none on /sys type sysfs (rw,relatime)
none on /dev type tmpfs (rw,relatime)
~
~
~
~
/user/welcome.txt				1,0-1	All

```
W tym momencie, jesteś w systemie VimOS! Miłej zabawy!

## 3. Krótkie wprowadzenie do Neovim  

### 3.1. Przedstawienie interfejsu  
Interfejs Neovim jest zbudowany z trzech pól:
 - Pola tekstu
 - Pola informacji
 - Pola komend

Czarna linia na samym dole ekranu, to pole komend. Tutaj będą wpisywane komendy zarówno systemowe, jak i specyficzne dla edytora Vim.

Jasna linia, nad polem komend, jest polem informacji. Tutaj wyświetlane są informacje co właśnie robisz, w którym miejscu jest kursor, oraz ewentualnie inne dane.

Pozostałe miejsce to pole tekstu. Tutaj widzisz i edytujesz swój tekst.

### 3.2. Podstawowe tryby  
#### 3.2.1. Tryb Normal  
W trybie Normal, jesteś w stanie wpisywać komendy w polu komend, a pole informacji nie wyświetla żadnego trybu. W tym trybie nie możesz edytować tekstu ręcznie, natomiast możesz usuwać całe linie, dane znaki, kopiować i wklejać tekst. Aby wyjść do trybu Normal, wystarczy nacisnąć przycisk `ESC`. Przy każdym uruchomieniu edytora, standardowo rozpoczynasz pracę właśnie w tym trybie.

#### 3.2.2. Tryb Insert 
W trybie Insert, jesteś w stanie edytować tekst który właśnie masz otworzony. Wchodzisz do niego z każdego innego trybu, wciskając klawisz `i`. Kursorem możesz poruszać strzałkami klawiatury, lub jak na prawdziwego Linuxiarza przystało, klawiszami `h`, `j`, `k`, oraz `l`.

#### 3.2.3. Tryb Visual 
W trybie Visual, jesteś w stanie zaznaczać tekst który później możesz skopiować, usunąć lub zamienić. Tryb Visual dzieli się na podtryby `Visual`, `Visual Line`, oraz `Visual Block`.
 - W trybie `Visual`, który otwierasz naciskając klawisz `v`, możesz zaznaczać tekst dokładnie tak, jak standardową myszką.
 - W trybie `Visual Line`, który otwierasz naciskając kombinacje klawiszy `SHIFT`+`v`, zaznaczasz całe linie tekstu.
 - W trybie `Visual Block`, który otwierasz naciskając kombinacje klawiszy `CTRL`+`v`, możesz zaznaczać bloki tekstu.

### 3.3. Podstawowe komendy i wyłowywanie komend systemowych
- `:w` - zapisuje otworzony plik
- `:e jakis_plik` - edytuje określony plik
- `:q` - zamyka Vim
- `:q!` - rozwiązuje wszystkie problemy
- `:!echo "Wykonalem komende systemowa!"` - wykonuje komendę systemową (`:!komenda`)

## 4. Budowanie ze źródeł  

### 4.1. Dependency-hell  
Zbudowanie wszystkich potrzebnych plików binarnych, wymaga sporej ilości narzędzi, oraz bibliotek. W przypadku budowania systemu VimOS na Debianie, wszystkie potrzebne paczki są instalowane przez skrypt `DebianBuild.sh`. Nie wstydź się zajrzeć do niego!

### 4.2. Szybka kompilacja  
```bash
git clone https://github.com/d3suu/VimOS
cd VimOS
chmod +x DebianBuild.sh
./DebianBuild.sh
qemu-system-x86_64 -enable-kvm -cdrom VimOS.iso -boot d
```

### 4.3. Kompilacja krok po kroku  
Na początku musimy pobrać branch master (stabilny):
```bash
git clone https://github.com/d3suu/VimOS
cd VimOS
```

Następnie, potrzebujemy narzędzi i bibliotek wymaganych do zbudowania plików binarnych. Dla Debiana, są to:
```bash
apt-get update
## Kernel, Syslinux, Busybox
apt-get -y install bison flex gcc make exuberant-ctags bc libssl-dev libelf-dev nasm uuid-dev
## Neovim
apt-get -y install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip git
## Tools
apt-get -y install genisoimage perl
```

#### 4.3.1. `build_binaries.sh`
Skrypt `build_binaries.sh` zbuduje dla nas jądro Linuxa, pliki binarne Syslinux, Busybox, oraz Neovim. Możemy go wykonać tylko raz, później wszystkie pliki już będą na miejscu.
```bash
chmod +x build_binaries.sh
./build_binaries.sh
```

#### 4.3.2. `build_development.sh`  
Skrypt `build_development.sh` zbuduje brakujące katalogi dla obrazu Live oraz initramfs, oraz skopiuje do nich potrzebne pliki binarne, zbudowane przez skrypt `build_binaries.sh`.
```bash
chmod +x build_development.sh
./build_development.sh
```

> W przypadku chęci modyfikacji (rozszerzenia) skryptu `build_development.sh`, możemy go wykonać kilka razy, w celu sprawdzenia czy poprawki działają poprawnie.

#### 4.3.3. `build_initramfs.sh`
Skrypt `build_initramfs.sh` zbuduje dla nas initramdisk, prosto do katalogu obrazu Live.  
```bash
chmod +x build_initramfs.sh
./build_initramfs.sh
```

> W przypadku chęci modyfikacji obrazu initramdisk, możemy dokonać naszych zmian w katalogu `initrdroot`, po czym wykonać skrypt `build_initramfs.sh`.

#### 4.3.4. `build_live_iso.sh` 
Skrypt `build_live_iso.sh` finalizuje wszystkie zmiany, i buduje obraz Live pod nazwą `VimOS.iso`.
```bash
chmod +x build_live_iso.sh
./build_live_iso.sh
```

## 5. Instalacja na dysku
### 5.1. Stworzenie dysku wirtualnego
Gdy już mamy zbudowany obraz Live, możemy przejść do jego instalacji na dysku. W tym przykładzie, stworzymy wirtualny dysk o wielkości 2GB. Instrukcja ta powinna odnosić się również do dysku fizycznego, więc nie będzie większego problemu w instalacji na prawdziwym sprzęcie.

Rozpoczynamy od stworzenia dysku:
```bash
qemu-img create dysk.img 2G
```

`qemu-img` pozwala nam na stworzenie oraz modyfikacje dysku wirtualnego. Tworzy on plik który będzie naszym "dyskiem". Co najlepsze, plik ten później możemy przegrać na prawdziwy dysk (korzystając z `dd`), i nadal powinien działać!

### 5.2. Bootujemy VimOS z dyskiem
Do tego wystarczy że dodamy argument `-hda` dla maszyny wirtualnej. Przykład wygląda tak:
```bash
qemu-system-x86_64 -enable-kvm -cdrom VimOS.iso -boot d -hda dysk.img
```

Teraz przechodzimy do prawdziwej zabawy.

### 5.3. Urządzenia `/dev/*`
Gdy już VimOS Live uruchomi się, przejdziemy do terminala. Zrobimy to za pomocą komendy `chvt` dzięki której przejdziemy do terminala nr. 1.
> Na fizycznym sprzęcie, możesz to również zrobić za pomocą kombinacji klawiszy `CTRL`-`ALT`-`F1`!
```vim
:!chvt 1
```

Będąc w terminalu, mamy większą prostote wykorzystywania potencjału komend. Pierwsze co musimy zrobić, to dowiedzieć się do jakich urządzeń, jądro przypisało nasz dysk, oraz obraz Live. Dowiemy się tego, korzystając z logu jądra, do którego mamy dostęp dzięki komendzie `dmesg`. Mimo że wykonamy tą komende, przez nasz terminal przeleci duuuuuuuużo informacji, które w większości nas nie interesują. Możemy je przesortować, korzystając z narzędzia o nazwie `grep`. Wyszukajmy więc, do jakiego urządzenia, przypisany jest nasz dysk:
```bash
/ # dmesg | grep "disk"
[1.042040] sd 0:0:0:0: [sda] Attached SCSI disk
```

Jak widzimy, nasz dysk został przypisany do urządzenia `sda`. VimOS nie obsługuje automatycznego montowania urządzeń, więc będziemy musieli zrobić to sami. Korzystając z narzędzia `mknod` możemy stworzyć plik urządzenia (wszystko w Linuxie jest plikiem!) na którym będziemy mogli pracować.
```bash
mknod /dev/sda b 8 0
mknod /dev/sda1 b 8 1
```

> Więcej o urządzeniach mknod, możesz poczytać tutaj: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/admin-guide/devices.txt

Jak mógłbyś zauważyć, tworzymy dwa urządzenia: `/dev/sda` oraz `/dev/sda1`. `/dev/sda` jest urządzeniem dysku, kiedy `/dev/sda1` jest urządzeniem pierwszej partycji którą stworzymy w kolejnym podrozdziale.

W tym momencie, przyda nam się jeszcze urządzenie stacji płyt w której mamy obraz Live naszego systemu. Znajdźmy go:
```bash
/ # dmesg | grep "CD-ROM"
[1.003278] scsi 1:0:0:0: CD-ROM QEMU DVD_ROM 2.5+ PQ: 0 ANSI: 5
[1.006034] cdrom: Uniform CD-ROM driver Revision: 3.20
[1.006783] sr 1:0:0:0: Attached scsi CD-ROM sr0
```

Wiemy więc że nasza stacja płyt została przydzielona do urządzenia sr0. stwórzmy je:
```bash
mknod /dev/sr0 b 11 0
```

### 5.4. Partycje i formatowanie
Czas na stworzenie partycji na dysku. W tym przypadku użyjemy narzędzia `fdisk`.
```bash
/ # fdisk /dev/sda
 
 The number of cylinder for this disk is set to 11915.
 There is nothing wrong with that, but this is larger than 1024,
 and could in certain setups cause problems with:
 1) software that runs at boot time (e.g., old versions of LILO)
 2) booting and partitioning software from other OSs
    (e.g., DOS FDISK, OS/2 FDISK)

Command (m for help):
```

Pierwsze co musimy zrobić to stworzyć naszą partycje. Dokonujemy tego komendą `n`. Podczas wykonywania komendy, `fdisk` zapyta nas o typ partycji (primary lub extended, my wybierzemy primary), numer partycji (w naszym przypadku 1), pierwszy sektor i ostatni sektor.

```fdisk
Command (m for help): n						// tutaj wpisujemy "n" i enter
Partition type
	p	primary partition (1-4)
	e	extended
p								// "p" i enter
Partition number (1-4): 1					// "1" i enter
First sector (16-4194303, default 16):				// enter
Using default value 16
Last sector or +size{,K,M,G,T} (16-4194303, default 4194303):	// enter
Using default value 4194303

Command (m for help):
```

Jako że stworzyliśmy naszą partycje, musimy ustawić flagę bootowania. Ustawimy ją dzięki komendzie `a`:
```fdisk
Command (m for help): a
Partition number (1-4): 1

Command (m for help):
```

Robota z partycjami zakończona, możemy podejrzeć jak wygląda nasz układ partycji komendą `p`, i zapisać prace komendą `w`.
```fdisk
Command (m for help): p
Disk /dev/sda: 2048MB, 2147483648 bytes, 4194304 sectors
11915 cylinders, 22 heads, 16 sectors/track
Units: sectors of 1 * 512 = 512 bytes

Device		Boot	StartCHS	EndCHS		StartLBA	EndLBA
/dev/sda1	*	0,1,1		261,21,16	63		4194303

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table
/ # _
```

Kolejnym krokiem jest sformatowanie naszej partycji. W tym przypadku wykorzystamy system plików `ext2`. Może wydawać się on starym rozwiązaniem, ale w naszym przypadku będzie wystarczający.
```bash
/ # mkfs.ext2 /dev/sda1
mke2fs 1.44.1 (24-Mar-2018)
Discarding device blocks: done                            
Creating filesystem with 262144 4k blocks and 65536 inodes
Filesystem UUID: 30544712-2b45-4604-a27b-829ca49d779f
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376

Allocating group tables: done                            
Writing inode tables: done                            
Writing superblocks and filesystem accounting information: done
```

### 5.5. Rootfs, extlinux, initramfs, i kopiowanie plików
Nasz dysk jest przygotowany pod instalacje systemu. Stwórzmy teraz dwa foldery: `/cdrom` oraz `/dysk`. Posłużą one do montowania naszego dysku, oraz obrazu Live.
```bash
mkdir /cdrom /dysk
mount /dev/sda1 /dysk
mount /dev/sr0 /cdrom
```

Standardowo, na naszym dysku powstanie folder `lost+found`, nie będzie on nam tutaj potrzebny, więc możemy się go pozbyć.
```bash
rm -rf /dysk/lost\+found/
```

> Więcej na temat `lost+found`: https://www.howtogeek.com/282374/what-is-the-lostfound-folder-on-linux-and-macos/

W tym momencie, przygotowaliśmy nasz `rootfs` do pracy. Pierwsze co zrobimy, to zainstalujemy bootloader o nazwie `extlinux`. Dzięki niemu nasz system będzie mógł bootować.
```bash
# extlinux --install /dysk
/dysk is device /dev/sda1
```

Teraz możemy skonfigurować opcje bootloadera. Przejdźmy do terminala nr. 2 i stwórzmy plik konfiguracyjny.
```bash
Terminal 1:
# chvt 2
```
```vim
Terminal 2:
:e /dysk/extlinux.conf
```

Korzystając z magii vima, napiszemy prostą konfiguracje, ale jeśli chcesz, możesz ją rozbudować.
```extlinux
prompt 1
default VimOS
timeout 10

label VimOS
	kernel /bzImage
	append initrd=/initramfs.cpio.gz
```

Zapisujemy zmiane i bierzemy się za kolejne pliki.
```vim
:w
:!chvt 1
```

Pierwszy plik który będzie nam potrzebny to jądro Linux. Bez problemu przekopiujemy je z obrazu Live.
```bash
cp /cdrom/bzImage /dysk/bzImage
```

Teraz czeka nas trochę zabawy. Bierzemy się za initramfs. W tym momencie porozmawiajmy o tym, jakie będzie miał zadanie:
 - Uruchomić system z ramu
 - Stworzyć pliki urządzeń (dysk, stacja cd-rom)
 - Zamontować je
 - Uruchomić środowisko (neovim)
 - Uruchomić terminal (terminal 1)

Może wydawać się to trudne, ale większość roboty jest już zrobiona. Stwórzmy sobie nowy folder na naszym dysku o nazwie "initramfs", i rozpakujmy obecny initramfs z obrazu Live.
```bash
mkdir /dysk/initramfs
cd /dysk/initramfs/
cat /cdrom/initramfs.cpio.gz | gunzip | cpio --extract
```

W tym momencie, w katalogu /dysk/initramfs mamy nasz rozpakowany initramfs. Czas wprowadzić zmiany! Tak się składa że wystarczy zmodyfikować plik `init`, który wykonuje wszystkie polecenia podczas bootowania. Otwórzmy go w Vimie.
```bash
Terminal 1:
chvt 2
```
```vim
Terminal 2:
:e /dysk/initramfs/init
```

Aktualny init powinien wyglądać mniej-więcej tak:
```bash
#!/bin/ash

mount -t proc none /proc
mount -t sysfs none /sys

mount -nvt tmpfs none /dev
mknod -m 600 /dev/console c 5 1
mknod -m 666 /dev/null c 1 3
mknod -m 666 /dev/tty c 5 0
mknod -m 666 /dev/tty0 c 4 0
mknod -m 666 /dev/tty1 c 4 1
mknod -m 666 /dev/tty2 c 4 2

# Userspace
mount -t tmpfs none /user size=10m

# This fixes kernel output to console
echo "3	4	1	3" > /proc/sys/kernel/printk

echo "" > /user/welcome.txt
echo "	Welcome in VimOS!" >> /user/welcome.txt
echo "" >> /user/welcome.txt
busybox free -m >> /user/welcome.txt
echo "" >> /user/welcome.txt
busybox uname -a >> /user/welcome.txt
echo "" >> /user/welcome.txt
busybox mount >> /user/welcome.txt

openvt -c 2 nvim /user/welcome.txt
chvt 2
sh
```

Według naszej listy, wystarczy że dodamy w okolicy bloku `mknod`, taki kod:
```bash
mknod /dev/sda b 8 0
mknod /dev/sda1 b 8 1
mknod /dev/sr0 b 11 0
mkdir /dysk
mount /dev/sda1 /dysk
```

Nasz init powinien wyglądać teraz tak:
```bash
#!/bin/ash

mount -t proc none /proc
mount -t sysfs none /sys

mount -nvt tmpfs none /dev
mknod -m 600 /dev/console c 5 1
mknod -m 666 /dev/null c 1 3
mknod -m 666 /dev/tty c 5 0
mknod -m 666 /dev/tty0 c 4 0
mknod -m 666 /dev/tty1 c 4 1
mknod -m 666 /dev/tty2 c 4 2

mknod /dev/sda b 8 0
mknod /dev/sda1 b 8 1
mknod /dev/sr0 b 11 0
mkdir /dysk
mount /dev/sda1 /dysk

# Userspace
mount -t tmpfs none /user size=10m

# This fixes kernel output to console
echo "3	4	1	3" > /proc/sys/kernel/printk

echo "" > /user/welcome.txt
echo "	Welcome in VimOS!" >> /user/welcome.txt
echo "" >> /user/welcome.txt
busybox free -m >> /user/welcome.txt
echo "" >> /user/welcome.txt
busybox uname -a >> /user/welcome.txt
echo "" >> /user/welcome.txt
busybox mount >> /user/welcome.txt

openvt -c 2 nvim /user/welcome.txt
chvt 2
sh
```

Wyjdźmy, i spakujmy go spowrotem.
```vim
:w
:!chvt 1
```

Operacja pakowania jest delikatnie skomplikowana, ale wystarczy pewien ciąg komend aby tego dokonać. ***Upewnij się że jesteś w katalogu /dysk/initramfs!***

```bash
cd /dysk/initramfs
find . -print0 | cpio --null --create --verbose --format=newc | gzip --best > /dysk/initramfs.cpio.gz
```

Przed nami już ostatni krok!

### 5.6. Wgranie MBR na dysk

Zanim będziemy mogli dumnie odpalić system z dysku, będziemy musieli wgrać MBR który pozwoli nam z niego zabootować. Zrobimy to dzięki plikowi `mbr.bin` który daje nam `syslinux`.

> Standardowo w obrazie Live VimOS, plik `mbr.bin` znajduje się w katalogu `/user/mbr.bin`

```bash
cd /
umount /dev/sda1
cat /user/mbr.bin > /dev/sda
```

Teraz możemy wyłączyć system, i zabootować z naszego dysku!
