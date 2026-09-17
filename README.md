To install CachyOS, follow the official guide at https://wiki.cachyos.org.

During installation, choose Hyprland. After the installation is complete:

* Tinker .config/hypr files to suit your language and hotkeys
* Change the default shell to Bash: `chsh -s /usr/bin/bash`
* Enable Secure Boot
* Configure discard support for the encrypted partition.

Clone my dotfiles from this repository and symlink the configuration files using GNU Stow.

```bash
sudo pacman -S stow
stow {folder-name}  
```

Add this option to the /var/lib/noctalia-greeter/greeter.toml manually: 
[keyboard]
layout = "de"

Install my Neovim dependencies:

```bash
pacman -S tree-sitter-cli unzip npm
```

Install the Yazi file manager and its dependencies:

```bash
pacman -S file ffmpeg 7zip jq poppler fd ripgrep fzf \
zoxide resvg imagemagick yazi
```

Install the other applications I use regularly:

```bash
pacman -S \
    firefox libreoffice-still opencode lazygit obs-studio \
    telegram-desktop signal-desktop discord steam blender ark uv \
    ttf-jetbrains-mono-nerd
```

