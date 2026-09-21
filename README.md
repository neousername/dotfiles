# CachyOS Installation and Setup Guide

To install CachyOS, follow the official guide at [wiki.cachyos.org](https://wiki.cachyos.org).

During installation, select **Hyprland**. Once the installation is complete, follow the post-install setup steps below.

---

## 1. Initial Configuration

* Adjust the configuration files in `~/.config/hypr` to match your language and monitor layout.
* Configure Nautilus settings with `SUPER + Z` and disable auto-theming in Alacritty.
* Clone your dotfiles repository and symlink configuration files using GNU Stow:

```bash
sudo pacman -S stow
stow <folder-name>
stow --adopt <existing-folder-name>
```

* After symlinking, reset the Git working tree to apply the configuration:

```bash
git reset --hard HEAD
```

* Change the default login shell to Bash:

```bash
chsh -s /usr/bin/bash
```

* Configure .gitconfig, bashrc and generate ssh-keys according to ssh-config in cloned dotfiles.

* Manually append the keyboard layout to `/var/lib/noctalia-greeter/greeter.toml`:

```toml
[keyboard]
layout = "de"
```

---

## 2. Package Installation

### Neovim and Dependencies

```bash
sudo pacman -S neovim tree-sitter-cli unzip npm
```

### Additional Daily Applications

```bash
sudo pacman -S \
  libreoffice-still opencode lazygit obs-studio-browser \
  telegram-desktop signal-desktop discord steam blender ark uv \
  ttf-jetbrains-mono-nerd tmux
```

---

## 3. Post-Installation Checklist

Refer to the CachyOS and Arch wikis for detailed procedures on the following:

* **Firmware Management:** Install `fwupd` to handle device firmware updates (refer to the ArchWiki).
* **Secure Boot:** Enable Secure Boot (note: this process can be complex and time-consuming).
* **Storage Maintenance:** Configure `discard` (TRIM) support for encrypted partitions.
* **System Optimization:** Review and apply suggestions from the **General System Tweaks** chapter.
* **Gaming Setup:** If gaming on this machine, follow the steps in the **Gaming** chapter.
