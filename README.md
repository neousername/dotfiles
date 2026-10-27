# CachyOS Post-Installation Guide

Btrfs; encrypted partition; limine; secure boot; niri; de locale

Use vim to edit files

## First Steps

Noctalia settings to be enabled:

- Rose Pine Theme (Dunkel)
- Templates for GTK3, GTK4, Qt and Niri
- Anonymer Start-Ping
- Bildschirmzeit
- Reines Schward (für OLED monitors)
- Standort - Calendar
- All settings in **Energie/Inaktivität** section
- Configure **Widget-Liste**, **Widgets** and **Layout** to be big and wide
- Configure **UI Skalierung**

Niri settings:

- Adjust monitor layout manually
- Set **geometry-corner-radius** to 0
- In **Layout** set **gaps** to 10 and **focus-ring/width** to 2
- In **misc** file inside of **cursor** option set property **hide-when-typing**

## Pull dotfiles from the github repository

- Use `git clone https://github.com/neousername/dotfiles.git`
- Download **stow** package with shelly
- Using stow command, symlink config files from the cloned repo
- Set wallpapers from noctalia menu for **Sperrbildschirm** and **Schreibtisch**
- Set wallpaper for firefox

## Additional steps

### Git config

- Set a git username: `git config --global user.name <name>`
- Set a git email: `git config --global user.email <email>`
- Change shell to bash: `chsh -s /usr/bin/bash`

### SSH config

Create ssh keys (name differently if multipule):

- `ssh-keygen -t ed25519 -C <email>`

Create a config file **config** in **.ssh** using the following format:

```
Host github.com-personal
    HostName github.com 
    user git
    IdentityFile ~/.ssh/id_ed25519
```

## Apps to install with shelly

telegram-desktop, signal-desktop, discord, steam, gedit, neovim,
tmux, opencode, ttf-jetbrains-mono-nerd, uv, npm
