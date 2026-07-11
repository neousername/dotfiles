# Personal Arch Linux Installation Guide

NVIDIA with no hibernation; Intel CPU;
BTRFS with encryption; secure boot;
snapper; hyprland; my own dotfiles.

# First Steps

Get your device's name: `lsblk`

Wipe the disk (the `-s` option might not be available):

`blkdiscard -s -v -f /dev/device_name`

Sometimes the boot manager still registers the old boot path,
so I reboot into the ISO again to be sure.

Run these commands:

```
loadkeys de-latin1 
setfont ter-132n
```

This should return `64`: `cat /sys/firmware/efi/fw_platform_size`

Connect to the wifi with **iwctl**.

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

Mount and configure the subvolumes with `zstd:1` compression.

```
umount /mnt
mount -o compress=zstd:1,noatime,subvol=@ /dev/mapper/root /mnt
mount --mkdir -o compress=zstd:1,noatime,subvol=@home /dev/mapper/root /mnt/home
mount --mkdir -o compress=zstd:1,noatime,subvol=@var_log /dev/mapper/root /mnt/var/log
mount --mkdir -o compress=zstd:1,noatime,subvol=@var_cache /dev/mapper/root /mnt/var/cache
mount --mkdir /dev/nvme0n1p1 /mnt/boot
```

# Installing Arch

Install the core packages:

```
pacman -Syy
pacstrap -K /mnt base base-devel linux linux-firmware btrfs-progs efibootmgr \
util-linux intel-ucode cryptsetup limine sbctl sudo networkmanager firewalld reflector \
avahi bluez bluez-utils bluetui acpi acpi_call acpid alsa-utils pipewire pipewire-alsa \
pipewire-pulse pipewire-jack wireplumber pulsemixer sof-firmware bash-completion \
git docker openssh keychain neovim alacritty terminus-font man 
```

Chroot and configure the time:

```
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc
```

Configure the language:

`nvim /etc/locale.gen` — uncomment the locale you want.

``` 
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf 
```

Configure the users:

```
echo yourhostname > /etc/hostname 
passwd 
useradd -mG wheel neousername
passwd neousername 
```

`EDITOR=nvim visudo` — uncomment the following:

```
%wheel ALL=(ALL:ALL) ALL
```

Create `/etc/vconsole.conf`:

```
KEYMAP=de-latin1
FONT=ter-132b
```

In `/etc/mkinitcpio.conf`:

```
MODULES=(btrfs)
BINARIES=(/usr/bin/btrfs) 
HOOKS=(base udev autodetect microcode modconf kms keyboard
keymap consolefont block encrypt filesystems fsck)
```

Regenerate the mkinitcpio files: `mkinitcpio -P`

## Limine setup

Run the following:

```
mkdir -p /boot/EFI/limine 
cp /usr/share/limine/BOOTX64.EFI /boot/EFI/limine/
```

Create an entry for Limine:

```
efibootmgr --create --disk /dev/nvme0n1 --part 1 \
         --label "Arch Linux Limine Bootloader" \
         --loader '\EFI\limine\BOOTX64.EFI' \
         --unicode
```

Get your UUID: `cryptsetup luksUUID /dev/nvme0n1p2`.

Configure Limine in `/boot/EFI/limine/limine.conf`:

```
timeout: 0
 
/Arch Linux
        protocol: linux
        path: boot():/vmlinuz-linux
        cmdline: quiet nowatchdog modprobe.blacklist=iTCO_wdt,intel_oc_wdt \
                 cryptdevice=UUID=<device-UUID>:root:allow-discards root=/dev/mapper/root rw \
                 rootflags=subvol=@ rootfstype=btrfs
        module_path: boot():/initramfs-linux.img
```

Adjust the `modprobe.blacklist` argument based on the CPU. This disables the *watchdog* service.
`allow-discards` is needed so that `fstrim.timer` works on an encrypted partition.

## Finalizing the Arch installation

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

Exit from the chroot, generate fstab, swap off and power off:

```
exit
genfstab -U /mnt >> /mnt/etc/fstab
nvim /mnt/etc/fstab
swapoff /mnt/swap/swapfile
umount -R /mnt
cryptsetup close root
poweroff
```

Take the USB Arch ISO out and boot.

# First launch

Run the following:

```
timedatectl
timedatectl set-ntp true
swapon --show
nmcli device wifi connect SSID_or_BSSID password actual_password 
```

Enable the fstrim service:

```
systemctl enable --now fstrim.timer
```

Install Snapper and create the snapshot configs. `create-config` makes a
nested `.snapshots` subvolume inside `@` (and inside `@home`) automatically —
no dedicated subvolume, no fstab entry, and it inherits `zstd:1` from `@`:

```
pacman -Syu snapper
snapper -c root create-config /
snapper -c home create-config /home
```

Configure the Snapper configs in `/etc/snapper/configs`:

```
TIMELINE_MIN_AGE="1800"
TIMELINE_LIMIT_HOURLY="0"
TIMELINE_LIMIT_DAILY="7"
TIMELINE_LIMIT_WEEKLY="0"
TIMELINE_LIMIT_MONTHLY="0"
TIMELINE_LIMIT_YEARLY="0"
```

Create an override folder for the service settings:

```
mkdir -p /etc/systemd/system/snapper-timeline.timer.d
```

Inside `override.conf`, in the directory created above, set these settings:

```
[Timer]
OnCalendar=
OnCalendar=daily
```

Enable *snapper-timeline.timer* and *snapper-cleanup.timer*.

Add a pacman hook for Limine in `/etc/pacman.d/hooks/99-limine.hook`.
The *hooks* directory must be created manually:

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

Uncomment the multilib options in `/etc/pacman.conf`.

Run this:

```
pacman -Syu linux-headers nvidia-open-dkms nvidia-utils lib32-nvidia-utils egl-wayland
```

Sleep should work out of the box. In my experience, hibernation on NVIDIA on Wayland
is broken. If you do not use hibernation,
add the following settings in `/etc/systemd/sleep.conf` so that
the PC stays in sleep and does not power off after a while:

```
[Sleep]
AllowHibernation=no
AllowSuspendThenHibernate=no
AllowHybridSleep=no
```

## Installing apps

I consider these my "system" packages:

```
pacman -S uwsm greetd greetd-tuigreet hyprland hyprlock hypridle hyprpaper \
hyprsunset mako xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
nwg-displays waybar rofi-wayland btop cliphist wl-clipboard grim slurp qt6ct \
nwg-look ttf-jetbrains-mono-nerd inter-font papirus-icon-theme tmux \
zathura-pdf-mupdf imv mpv cups celluloid filelight
```

Yazi file manager:

```
pacman -S file ffmpeg 7zip jq poppler fd ripgrep fzf \
zoxide resvg imagemagick yazi
```

```
ya pkg add yazi-rs/plugins:moun
```

Then there are the apps I personally favour (ollama-cuda for NVIDIA):

```
pacman -S signal-desktop telegram-desktop thunderbird \
firefox gimp libreoffice-still kdenlive obs-studio discord steam \
opencode ollama ollama-cuda lazygit
```

## Configuring apps

I use a uwsm-managed Hyprland.
I store and maintain my config files in a git repo.
I pull them into my home directory.
Essentially all apps require specific configuration
with specific environment variables.

## Greetd setup

Enable greetd with `systemctl enable greetd.service`.

Configure greetd in `/etc/greetd/config.toml`:

```
[default_session]
command = "tuigreet -w 70 --asterisks --remember --remember-session"
```

Reboot. When logging in for the first time, choose the user
and the **uwsm-managed** session for **Hyprland**.

## Finalizing my setup

Enter another TTY with CTRL+ALT+F2.
Go to `.config/hypr/hypr.conf` and add a binding for
Alacritty and Firefox.
Set up the correct input in the generated config:

```
input {
    kb_layout = de
}
```

Generate an SSH key: `ssh-keygen -t ed25519 -C "your_email@example.com"`

Add the public key to GitHub through Firefox.

Fork my repository on GitHub.

Fetch the forked repository into your home directory:

```
git init
git remote add origin git@github.com:USERNAME/REPONAME.git
git pull origin main
```

- Enable hypridle: `systemctl --user enable hypridle.service`
- Install dependencies for the nvim plugins after running the `checkhealth` command.
- Clean up junk files created by dependencies if you see them.
- Configure nwg-look and qt6ct to use inter-font.
- Run the opencode server via bash aliases when vibe-coding (guarantees virginity till 30).
- Run Ollama with an alias; do not enable autostart.

# Secure boot

The following definitely works on ASUS motherboards.

Enter the UEFI setup menu: `systemctl --firmware-setup reboot`

Do not change the OS Type to Custom from Windows mode. Instead, open the
sub-menu *Key Management*. Use `Clear Secure Boot Keys` to enter Setup Mode.

Secure boot should be disabled now. Exit the firmware with the save and reset option,
even if it says no changes have been performed.

Confirm that setup mode is enabled: `sudo sbctl status`

Create custom secure boot keys: `sudo sbctl create-keys`

Enroll the custom secure boot keys: `sudo sbctl enroll-keys --microsoft`

Sign the bootloader and kernel with sbctl.
The `-s` flag saves the path so that sbctl re-signs it
automatically on updates via its pacman hook:

```
sudo sbctl sign -s /boot/EFI/limine/BOOTX64.EFI
sudo sbctl sign -s /boot/vmlinuz-linux
```

Reboot.

Confirm that setup mode is disabled now: `sudo sbctl status`
