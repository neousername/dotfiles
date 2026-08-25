# Personal Arch Linux Installation Guide

To change the color theme, ask an agent to use `.CHANGE_THEME_WITH_AGENT.md`.

This setup uses an Intel CPU, NVIDIA graphics without hibernation, encrypted
Btrfs, Snapper, Hyprland, and my own dotfiles.

# First Steps

Get your device name: `lsblk`

Wipe the disk (the `-s` option might not be available):

`blkdiscard -s -v -f /dev/device_name`

Sometimes the boot manager still registers the old boot path,
so I reboot into the ISO again to be sure.

Run these commands:

```bash
loadkeys de-latin1 
setfont ter-132n
```

This command should return `64`: `cat /sys/firmware/efi/fw_platform_size`

Connect to Wi-Fi using `iwctl`.

Partition, encrypt, and format:

```bash
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

```bash
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@var_log
btrfs subvolume create /mnt/@var_cache
```

Mount and configure the subvolumes with `zstd:1` compression.

```bash
umount /mnt
mount -o compress=zstd:1,noatime,subvol=@ /dev/mapper/root /mnt
mount --mkdir -o compress=zstd:1,noatime,subvol=@home /dev/mapper/root /mnt/home
mount --mkdir -o compress=zstd:1,noatime,subvol=@var_log /dev/mapper/root /mnt/var/log
mount --mkdir -o compress=zstd:1,noatime,subvol=@var_cache /dev/mapper/root /mnt/var/cache
mount --mkdir /dev/nvme0n1p1 /mnt/boot
```

# Installing Arch

Install the core packages:

```bash
pacman -Syy
pacstrap -K /mnt base base-devel linux linux-firmware btrfs-progs efibootmgr \
util-linux intel-ucode sof-firmware cryptsetup limine sudo networkmanager firewalld reflector \
avahi bluez bluez-utils bluetui acpi acpi_call acpid alsa-utils pipewire pipewire-alsa \
pipewire-pulse pipewire-jack wireplumber rtkit pulsemixer bash-completion \
openssh neovim terminus-font man 
```

Enter the chroot environment and configure the time:

```bash
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
```

Configure the language:

Run `nvim /etc/locale.gen` and uncomment the locale you want.

```bash
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf 
```

Configure the user accounts:

```bash
echo yourhostname > /etc/hostname 
passwd 
useradd -mG wheel neousername
passwd neousername 
```

Run `EDITOR=nvim visudo` and uncomment the following line:

```text
%wheel ALL=(ALL:ALL) ALL
```

Create `/etc/vconsole.conf`:

```ini
KEYMAP=de-latin1
FONT=ter-132b
```

In `/etc/mkinitcpio.conf`:

```bash
MODULES=(btrfs)
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt filesystems resume)
```

Regenerate the initramfs images: `mkinitcpio -P`

## Limine Setup

Run the following:

```bash
mkdir -p /boot/EFI/limine 
cp /usr/share/limine/BOOTX64.EFI /boot/EFI/limine/
```

Create a Limine boot entry:

```bash
efibootmgr --create --disk /dev/nvme0n1 --part 1 \
         --label "Arch Linux Limine Bootloader" \
         --loader '\EFI\limine\BOOTX64.EFI' \
         --unicode
```

Get the encrypted partition's UUID: `cryptsetup luksUUID /dev/nvme0n1p2`.

Configure Limine in `/boot/EFI/limine/limine.conf`:

```ini
timeout: 5
 
/Arch Linux
        protocol: linux
        path: boot():/vmlinuz-linux
        cmdline: quiet cryptdevice=UUID=<device-UUID>:root:allow-discards root=/dev/mapper/root rw rootflags=subvol=@ rootfstype=btrfs 
        module_path: boot():/initramfs-linux.img
```

`allow-discards` is required for `fstrim.timer` to work on an encrypted partition.

## Finalizing the Arch Installation

Run the following:

```bash
btrfs subvolume create /swap
btrfs filesystem mkswapfile --size 16g --uuid clear /swap/swapfile
swapon -p 0 /swap/swapfile
```

Configure networking:

Edit `/etc/NetworkManager/conf.d/dns.conf` with Neovim:

```ini
[main]
dns=systemd-resolved
```

```bash
systemctl enable systemd-resolved 
systemctl enable firewalld 
systemctl enable NetworkManager.service
systemctl enable reflector.timer
systemctl enable bluetooth.service
```

Exit the chroot, generate `fstab`, disable swap, and power off:

```bash
exit
genfstab -U /mnt >> /mnt/etc/fstab
nvim /mnt/etc/fstab
swapoff /mnt/swap/swapfile
umount -R /mnt
cryptsetup close root
poweroff
```

Remove the Arch installation USB drive and boot the system.

# First Launch

Run the following:

```bash
timedatectl
timedatectl set-ntp true
swapon --show
nmcli device wifi connect SSID_or_BSSID password actual_password 
```

Enable the `fstrim` timer:

```bash
systemctl enable --now fstrim.timer
```

Install Snapper and create the snapshot configurations. `create-config`
automatically creates a nested `.snapshots` subvolume inside `@` and `@home`.
It requires no dedicated subvolume or `fstab` entry and inherits `zstd:1` from `@`:

```bash
pacman -Syu snapper
snapper -c root create-config /
snapper -c home create-config /home
```

Configure Snapper in `/etc/snapper/configs`:

```ini
TIMELINE_MIN_AGE="1800"
TIMELINE_LIMIT_HOURLY="0"
TIMELINE_LIMIT_DAILY="7"
TIMELINE_LIMIT_WEEKLY="0"
TIMELINE_LIMIT_MONTHLY="0"
TIMELINE_LIMIT_YEARLY="0"
```

Create an override directory for the service settings:

```bash
SYSTEMD_EDITOR=nvim systemctl edit snapper-timeline.timer
```

Add these settings:

```ini
[Timer]
OnCalendar=
OnCalendar=daily
```

Enable `snapper-timeline.timer` and `snapper-cleanup.timer`.

Add a pacman hook for Limine in `/etc/pacman.d/hooks/99-limine.hook`.
The `hooks` directory must be created manually:

```ini
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

Install firmware update tools without enabling automated updates:

```bash
pacman -Syu fwupd udisks2
fwupdmgr get-devices
```

# Hyprland Setup

## Installing NVIDIA Drivers

Uncomment the multilib options in `/etc/pacman.conf`.

Run this:

```bash
pacman -Syu linux-headers nvidia-open-dkms nvidia-utils lib32-nvidia-utils egl-wayland \
    libva-nvidia-driver libva-utils
```

Load the NVIDIA modules early by updating `/etc/mkinitcpio.conf`, then regenerate
the initramfs images:

```bash
MODULES=(btrfs nvidia nvidia_modeset nvidia_uvm nvidia_drm)
mkinitcpio -P
```

For a UWSM-managed session, create `~/.config/uwsm/env`:

```bash
export LIBVA_DRIVER_NAME=nvidia
export __GLX_VENDOR_LIBRARY_NAME=nvidia
```

`libva-nvidia-driver` provides the NVIDIA VA-API backend selected by
`LIBVA_DRIVER_NAME=nvidia`. Verify it with `vainfo` after starting a new session.

NVIDIA drivers do not officially support hibernation as of August 24, 2026,
but I still have the hibernation hook and kernel command-line arguments configured
in the hope that support will be fixed. Set up hibernation as follows:

```bash
sudo btrfs inspect-internal map-swapfile -r /swap/swapfile
findmnt -no UUID -T /swap/swapfile
```

The commands above return two values.
Append them to the Limine kernel command line:
`resume=UUID=YOUR_BTRFS_UUID resume_offset=YOUR_OFFSET`


## Installing Apps

I consider these to be my system packages:

```bash
pacman -S \
    uwsm greetd greetd-tuigreet \
    hyprland hyprlock hypridle hyprpaper hyprsunset \
    hyprpolkitagent \
    mako waybar rofi-wayland \
    xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
    qt6-wayland qt6ct \
    nwg-look nwg-displays \
    ttf-jetbrains-mono-nerd inter-font papirus-icon-theme \
    wl-clipboard cliphist grim slurp brightnessctl \
    btop tmux \
    xreader imv mpv celluloid filelight \
    cups uv docker git ghostty keychain
```

My Neovim dependencies:

```bash
pacman -S tree-sitter-cli rust unzip npm
```

Install the Yazi file manager:

```bash
pacman -S file ffmpeg 7zip jq poppler fd ripgrep fzf \
zoxide resvg imagemagick yazi 
```

Run these commands from your home directory:

```bash
ya pkg add yazi-rs/plugins:mount
xdg-mime default yazi.desktop inode/directory
```

This adds the mount plugin and makes Firefox use Yazi when selecting a folder
from the browser.

These are the applications I personally favour:

```bash
pacman -S \
    firefox libreoffice-still opencode lazygit obs-studio \
    telegram-desktop signal-desktop discord
```

## Configuring Apps

I use a UWSM-managed Hyprland session.
I store and maintain my configuration files in a Git repository and pull them
into my home directory. Nearly every app requires its own configuration and
environment variables.

To add a new app to the Rofi menu, edit `.config/scripts/rofi_menu_launcher.sh`
manually.

## Greetd Setup

Enable Greetd with `systemctl enable greetd.service`.

Configure Greetd in `/etc/greetd/config.toml`:

```toml
[default_session]
command = "tuigreet -w 70 --asterisks --remember --remember-session"
```

Reboot. When logging in for the first time, select your user account and the
**UWSM-managed** session for **Hyprland**.

## Finalizing My Setup

Open another TTY with <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>F2</kbd>.
Edit `.config/hypr/hypr.conf` and add a binding for
Alacritty and Firefox.
Set up the correct input in the generated config:

```hyprlang
input {
    kb_layout = de
}
```

Generate an SSH key: `ssh-keygen -t ed25519 -C "your_email@example.com"`

Add the public key to GitHub through Firefox.

Fork my repository on GitHub.

Pull the repository, removing any conflicting files first:

```bash
git init
git remote add origin git@github.com:USERNAME/REPONAME.git
git pull origin main
```

- Configure your monitor with `nwg-displays`.
- Enable Hyprland-related services:

```bash
systemctl --user enable --now \
    hyprpaper.service \
    waybar.service \
    hyprsunset.service \
    hypridle.service \
    hyprpolkitagent.service
```
- Install dependencies for the Neovim plugins after running the `checkhealth` command.
- Configure `nwg-look` and `qt6ct` to use the Inter font and Papirus icons.
- Open web apps with hotkeys (see `keybinds.lua` under `webapps`).
- Enable local network service discovery and printing:

```bash
sudo systemctl enable --now avahi-daemon.service cups.service
```

Avahi discovers services and devices over the local network, while CUPS manages
printers and print jobs.
