# Personal Arch Linux Installation Guide

NVIDIA with no hibernation; Intel CPU;
BTRFS with encryption; secure boot; 
snapper; hyprland; my own dotfiles;


# First Steps

Get your device' name: `lsblk`

Wipe the disk (-s option might not be available):
`blkdiscard -s -v -f /dev/device_name`

Sometimes the bootmanager still register old boot path,
so I reboot into ISO again to be sure.

Run these commands:
```
loadkeys de-latin1 
setfont ter-132n
```

This should return 64: `cat /sys/firmware/efi/fw_platform_size`

Connect to the wifi with **iwctl**

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
git docker openssh keychain neovim ghostty terminus-font man 
```
 
Chroot and configure time:
```
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
```

Configure language:

`nvim /etc/locale.gen` - uncomment the locale you want.

``` 
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf 
```

Configure users:
```
echo yourhostname > /etc/hostname 
passwd 
useradd -mG wheel neousername
passwd neousername 
```

`EDITOR=nvim visudo` - uncomment the following:
%wheel ALL=(ALL:ALL) ALL

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

Get your UUID: `cryptsetup luksUUID /dev/nvme0n1p2`.
Configure limine in */boot/EFI/limine/limine.conf*:
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

Adjust modprobe.blacklist argument based on the CPU. This disables *watchdog* service


## Finalizing arch installation

Run the following:
```
btrfs subvolume create /swap
btrfs filesystem mkswapfile --size 16g --uuid clear /swap/swapfile
swapon -p 0 /swap/swapfile
```

Networking:
```
systemctl enable systemd-resolved 
systemctl enable firewalld 
systemctl enable NetworkManager.service
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

## Installing NVIDIA drivers

Uncomment multilib options in */etc/pacman.conf*

Run this:
```
pacman -Syu linux-headers nvidia-open-dkms nvidia-utils lib32-nvidia-utils egl-wayland
```

Sleep should work outside of the box. Hibernation on NVIDIA on Wayland 
is broken in my experience. If you do not use hibernation,
add the following settings in the `/etc/systemd/sleep.conf`, so that 
the pc stays in sleep and does not power off after a while:
```
[Sleep]
AllowHibernation=no
AllowSuspendThenHibernate=no
AllowHybridSleep=no
```


## Installing Apps

I consider these my "system" packages:
```
pacman -S uwsm greetd greetd-tuigreet hyprland hyprlock hypridle hyprpaper \
hyprsunset mako xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
nwg-displays waybar rofi-wayland btop cliphist wl-clipboard grim slurp qt6ct \
nwg-look ttf-jetbrains-mono-nerd inter-font papirus-icon-theme tmux \
zathura-pdf-mupdf imv mpv cups celluloid
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
opencode ollama ollama-cuda lazygit
```


## Configuring apps

I use uwsm-managed hyprland

I store and maintain my config files in a git repo.
I pull it into my home directory

Essentially all apps require specific configuration
with specific environmental variables


## Greetd setup

Enable greetd with `systemctl enable greetd.service`

Configure greetd in */etc/greetd/config.toml*:
```
[default_session]
command = "tuigreet -w 70 –-asterisks --remember --remember-session"
```

Reboot. When logging in for the first time choose the user
and the **uwsm-managed** session for **hyprland**


## Finalizing my setup

Enter another TTY with CTRL+ALT+F2 

Go to *.config/hypr/hypr.conf* and add a binding for 
alacritty and firefox.

Set up correct input in the generated config:
```
input {
    kb_layout = de
}
```

Generate ssh key: `ssh-keygen -t ed25519 -C "your_email@example.com"`
Add the public key to the GitHub through firefox

Fork my repository on GitHub

Fetch the forked repository into your home directory:
```
git init
git remote add origin git@github.com:USERNAME/REPONAME.git
git fetch
git checkout -f master
```

- Enable hypridle: `systemctl --user enable hypridle.service`
- Make .sh-files executables inside of *scripts* directory
- Install dependencies for nvim plugings after running `checkhealth` command
- Clean up garbage files like steampath links in *home* and user-dirs configuration in .config
- Configure nwg-look and qt6ct to use inter-font
- Run opencode server when vibe-coding with bash aliases (guarantees virginity till 30)
- Run ollama with alias not a service


# Secure boot

The following definitely works on ASUS motherboards

Enter UEFI setup menu: `systemctl --firmware-setup reboot`

Do not change OS Type to Custom from Windows mode. Instead, open the 
sub menu: *Key Managment*. Use `Clear Secure Boot Keys` to enter Setup Mode

Secure boot should be disabled now. Exit the firmware with save and reset option,
even if it says no changes have been performed

Confirm that setup mode is enabled: `sudo sbctl status`
Create custom secure boot keys: `sudo sbctl create-keys`
Enroll custom secure boot keys: `sudo sbctl enroll-keys --microsoft`

Sign bootloader and kernel with sbctl.
The -s flag saves the path so sbctl re-signs it
automatically on updates via its pacman hook:
```
sudo sbctl sign -s /boot/EFI/limine/BOOTX64.EFI
sudo sbctl sign -s /boot/vmlinuz-linux
```

Reboot

Confirm that setup mode is disabled now: `sudo sbctl status`
