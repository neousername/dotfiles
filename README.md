To install CatchyOS follow the official guide at https://wiki.cachyos.org.
When installing choose Hyprland. 

Clone my dotfiles from this repository and simlink the configuration with stow. 
Delete .bashrc and other conflicting stow files. 

Install my neovim dependencies: 
pacman -S tree-sitter-cli unzip npm

Install yazi file manager:
pacman -S file ffmpeg 7zip jq poppler fd ripgrep fzf \
zoxide resvg imagemagick yazi 

Install other apps I favour:
pacman -S \
    firefox libreoffice-still opencode lazygit obs-studio \
    telegram-desktop signal-desktop discord steam blender ark
