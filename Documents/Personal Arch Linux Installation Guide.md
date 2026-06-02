# Personal Arch Linux Installation Guide

NVIDIA with no hibernation/sleep; Intel CPU;
BTRFS with encryption; snapper; hyprland;

Install Arch-ISO on a usb, wipe the disk and reboot.


# First Steps

Get your device' name: `lsblk`

Wipe the disk (-s option might not be available):
`blkdiscard -s -v -f /dev/device_name`

Sometimes the bootmanager still register old boot path,
so I reboot into ISO again to be sure.

Run these commands:
```
loadkeys de-latin1 
setfont ter-132b
```

Connect to the wifi with **iwctl**.
This should return 64: `cat /sys/firmware/efi/fw_platform_size`

Partition, encrypt and format:
```
parted --script /dev/nvme0n1 \
        mklabel gpt \
        mkpart ESP fat32 1MiB 1537MiB \
        set 1 esp on \
        mkpart Linux btrfs 1537MiB 100%
        
cryptsetup luksFormat /dev/nvme0n1p2
cryptsetup open /dev/nvme0n1p2 root
mkfs.btrfs /dev/mapper/root
mkfs.fat -F 32 /dev/nvme0n1p1 
mount /dev/mapper/root /mnt
```

Create subvolumes:
```
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@var_log
btrfs subvolume create /mnt/@var_cache
```

Mount and configure subvolumes without compression:
```
umount /mnt
mount -o noatime,subvol=@ /dev/mapper/root /mnt
mount --mkdir -o noatime,subvol=@home /dev/mapper/root /mnt/home
mount --mkdir -o noatime,subvol=@var_log /dev/mapper/root /mnt/var/log
mount --mkdir -o noatime,subvol=@var_cache /dev/mapper/root /mnt/var/cache
mount --mkdir /dev/nvme0n1p1 /mnt/boot
```


# Installing Arch

Installing core packages:
```
pacman -Syy
pacstrap -K /mnt base base-devel linux linux-firmware btrfs-progs efibootmgr \
util-linux intel-ucode cryptsetup limine sbctl sudo networkmanager firewalld reflector \
avahi bluez bluez-utils bluetui acpi acpi_call acpid alsa-utils pipewire pipewire-alsa \
pipewire-pulse pipewire-jack wireplumber pulsemixer sof-firmware bash-completion \
git openssh keychain neovim alacritty terminus-font man 
```
 
Chroot and configure time:
```
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
```

Configure language:
``` 
nvim /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf 
nvim /etc/vconsole.conf
KEYMAP=de-latin1
FONT=ter-132n 
```

Configure users:
```
echo yourhostname > /etc/hostname 
passwd 
useradd -mG wheel neousername
passwd neousername 
EDITOR=nvim visudo
```

Inside of */etc/mkinitcpio.conf*:
```
MODULES=(btrfs)
BINARIES=(/usr/bin/btrfs) 
HOOKS=(base udev autodetect microcode modconf kms keyboard
keymap consolefont block encrypt filesystems fsck)
```

Regenerate mkinicpio files: `mkinitcpio -P`


## Limine setup

Run the following:
```
mkdir -p /boot/EFI/limine 
cp /usr/share/limine/BOOTX64.EFI /boot/EFI/limine/
```

Create entry for limine:
```
efibootmgr --create --disk /dev/nvme0n1 --part 1 \
         --label "Arch Linux Limine Bootloader" \
         --loader '\EFI\limine\BOOTX64.EFI' \ 
         --unicode
```

Configure limine in */boot/EFI/limine/limine.conf*.
Get your UUID: `cryptsetup luksUUID /dev/nvme0n1p2`
```
timeout: 0
 
/Arch Linux
        protocol: linux
        path: boot():/vmlinuz-linux
        cmdline: quiet nowatchdog modprobe.blacklist=iTCO_wdt,intel_oc_wdt \
                 cryptdevice=UUID=<device-UUID>:root root=/dev/mapper/root rw \
                 rootflags=subvol=@ rootfstype=btrfs
        module_path: boot():/initramfs-linux.img
```

Adjust modprobe.blacklist argument based on the CPU. This makes CPU faster.


## Finalizing arch installation

Run the following:
```
btrfs subvolume create /swap
btrfs filesystem mkswapfile --size 16g --uuid clear /swap/swapfile
swapon -p 0 /swap/swapfile
```

Networking:
```
systemctl enable NetworkManager
systemctl enable systemd-resolved 
systemctl enable firewalld 
systemctl enable reflector.timer
systemctl enable bluetooth.service
```

Exit from chroot, generate fstab, swapoff and poweroff:
```
exit
genfstab -U /mnt >> /mnt/etc/fstab
nvim /mnt/etc/fstab
swapoff /mnt/swap/swapfile
umount -R /mnt
cryptsetup close root
poweroff
```

Take USB Arch ISO out and boot


# First launch

Run the following: 
```
timedatectl
timedatectl set-ntp true
swapon --show
nmcli device wifi connect SSID_or_BSSID password actual_password 
```

Enable *fstrim service* and create snapshot subvolumes.
Leave snapper at default settings:
```
systemctl enable --now fstrim.timer
pacman -Syu snapper
snapper -c root create-config /
snapper -c home create-config /home
```

Add pacman hook for limine in *etc/pacman.d/hooks/99-limine.hook*.
*hooks* directory must be created manually:
```
[Trigger]
Operation = Install
Operation = Upgrade
Type = Package
Target = limine              

[Action]
Description = Deploying Limine after upgrade...
When = PostTransaction
Exec = /usr/bin/cp /usr/share/limine/BOOTX64.EFI /boot/EFI/limine/
```

Firmware update tools (without automated updates):
```
pacman -Syu fwupd udisks2
fwupdmgr get-devices
```


# Hyprland setup

I consider these my "system" packages:
```
pacman -S uwsm greetd greetd-tuigreet hyprland hyprlock hypridle hyprpaper \
hyprsunset mako xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
nwg-displays waybar rofi-wayland cliphist wl-clipboard grim slurp qt6ct \
nwg-look ttf-jetbrains-mono-nerd ttf-montserrat papirus-icon-theme tmux \
zathura-pdf-mupdf imv mpv cups 
```

Yazi file manager:
```
pacman -S file ffmpeg 7zip jq poppler fd ripgrep fzf \
zoxideresvg imagemagick yazi
```

Then, there are favourite apps I use (ollama-cuda for NVIDIA): 
```
pacman -S signal-desktop telegram-desktop thunderbird \
firefox gimp libreoffice-still obs-studio discord steam \
opencode ollama ollama-cuda
```


Install dependencies for nvim plugings
after running `checkhealth` command.


## Configuring apps

I use uwsm-managed hyprland.

I store and maintain my config files in a git repo.
I pull it into my home directory.

Essentially all apps require specific configuration
with specific environmental variables.

Do not forget to:
- make the sh files executables inside of *scripts* directory;
- make zathura default pdf viewer with: 
  `xdg-mime default org.pwmt.zathura.desktop application/pdf`
- configure keychain


## Installing NVIDIA drivers

Uncomment multilib options in */etc/pacman.conf*.

Run this:
```
pacman -Syu linux-headers nvidia-dkms nvidia-utils \
lib32-nvidia-utils egl-wayland 
```

After launching Hyprland for the first time, 
add these environment variables to *.config/uwsm/env*:
```
export LIBVA_DRIVER_NAME=nvidia
export __GLX_VENDOR_LIBRARY_NAME=nvidia
```

Sleep should work outside of the box. Hibernation on NVIDIA on Wayland 
is broken in my experience. If you do not use hibernation,
add the following settings in the `/etc/systemd/sleep.conf`, so that 
the pc stays in sleep and does not power after a while:
```
[Sleep]
AllowHibernation=no
AllowSuspendThenHibernate=no
AllowHybridSleep=no
```


## Greetd setup

Enable greetd with `systemctl enable greetd.service`

Configure greetd in */etc/greetd/config.toml*:
```
[default_session]
command = "tuigreet -w 70 –-asterisks --remember --remember-session"
```

Reboot. When logging in for the first time choose the user
and the **uwsm-managed** session for **hyprland**.



## Finalizing my setup

Go to *.config/hypr/hypr.conf* and add a binding for 
alacritty and firefox.

Generate ssh key and add it to github.
Use `ssh-keygen -t ed25519 -C "your_email@example.com"`.
Add the public key to the GitHub.

Fetch my config:
```
git init
git remote add origin git@github.com:USERNAME/REPO-NAME.git
git fetch
git checkout -f main
```

Enable hypridle: `systemctl enable hypridle.service`
Enable ollama: `systemctl ollama.service`


# Secure boot

The following definitely works on ASUS motherboards.

Enter UEFI setup menu: `systemctl --firmware-setup reboot`.

Do not change OS Type to Custom from Windows mode. Instead, open the 
sub menu: *Key Managment*. Use `Clear Secure Boot Keys` to enter Setup Mode.

Secure boot should be disabled now. Exit the firmware with save and reset option,
even if it says no changes have been performed. 

Confirm that setup mode is enabled: `sudo sbctl status`
Create custom secure boot keys: `sudo sbctl create-keys`
Enroll custom secure boot keys: `sudo sbctl enroll-keys --microsoft`

Sign bootloader and kernel with sbctl before rebooting. the -s flag
saves the path so sbctl re-signs it automatically on updates via
its pacman hook:
```
sudo sbctl sign -s /boot/EFI/limine/BOOTX64.EFI
sudo sbctl sign -s /boot/vmlinuz-linux
```

Confirm that setup mode is disabled now: `sudo sbctl status`
