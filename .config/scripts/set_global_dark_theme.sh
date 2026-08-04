#!/usr/bin/env bash
set -euo pipefail

# ── global font ───────────────────────────────────────────────────────────────
# Change this to switch the font everywhere at once (waybar, rofi, mako, hyprlock).
# Alacritty keeps its own monospace/Nerd Font setting on purpose.
FONT="Inter"

# ── global icon theme ─────────────────────────────────────────────────────────
# Papirus panel icons are light-colored (#dfdfdf), meant for a dark panel.
ICON_THEME="Papirus"

# ── hyprland (~/.config/hypr/style.lua) ──────────────────────────────────────
L1='local col_active_border_1 = "rgba(aeaeb2cc)"'
L2='local col_active_border_2 = "rgba(6e6e7388)"'
L3='local col_inactive_border = "rgba(3a3a3caa)"'
L4='local col_shadow         = 0xee0d0d0f'

sed -i "1s|.*|$L1|" ~/.config/hypr/style.lua
sed -i "2s|.*|$L2|" ~/.config/hypr/style.lua
sed -i "3s|.*|$L3|" ~/.config/hypr/style.lua
sed -i "4s|.*|$L4|" ~/.config/hypr/style.lua

# ── hyprlock (~/.config/hypr/hyprlock.conf) ───────────────────────────────────
L1='    inner_color = rgba(0, 0, 0, 0.0) # no fill'
L2='    outer_color = rgba(aeaeb259) rgba(6e6e7359) 45deg'
L3="    check_color=rgba(aeaeb2ee) rgba(6e6e73ee) 120deg"
L4='    fail_color=rgba(ff453aee) rgba(ff453aee) 40deg'
L5='    font_color = rgb(229, 229, 234)'
L6="    font_family = $FONT"

sed -i "5s|.*|$L1|"  ~/.config/hypr/hyprlock.conf
sed -i "7s|.*|$L2|"  ~/.config/hypr/hyprlock.conf
sed -i "8s|.*|$L3|"  ~/.config/hypr/hyprlock.conf
sed -i "9s|.*|$L4|"  ~/.config/hypr/hyprlock.conf
sed -i "11s|.*|$L5|" ~/.config/hypr/hyprlock.conf
sed -i "12s|.*|$L6|" ~/.config/hypr/hyprlock.conf

# ── waybar (~/.config/waybar/style.css) ───────────────────────────────────────
L1='@define-color bg        #1C1C1E;'
L2='@define-color bg_alt    #2C2C2E;'
L3='@define-color bg_hover  #3A3A3C;'
L4='@define-color fg        #E5E5EA;'
L5='@define-color fg_bright #FFFFFF;'
L6='@define-color fg_dim    #8E8E93;'
L7='@define-color accent    #AEAEB2;'      # macOS graphite
L8='@define-color urgent    #FF453A;'

sed -i "1s|.*|$L1|" ~/.config/waybar/style.css
sed -i "2s|.*|$L2|" ~/.config/waybar/style.css
sed -i "3s|.*|$L3|" ~/.config/waybar/style.css
sed -i "4s|.*|$L4|" ~/.config/waybar/style.css
sed -i "5s|.*|$L5|" ~/.config/waybar/style.css
sed -i "6s|.*|$L6|" ~/.config/waybar/style.css
sed -i "7s|.*|$L7|" ~/.config/waybar/style.css
sed -i "8s|.*|$L8|" ~/.config/waybar/style.css

L9="    font-family: \"$FONT\";"
sed -i "13s|.*|$L9|" ~/.config/waybar/style.css

I1="    background-image: url('/usr/share/icons/$ICON_THEME/22x22/panel/audio-volume-low-panel.svg');"
I2="    background-image: url('/usr/share/icons/$ICON_THEME/22x22/panel/audio-volume-medium-panel.svg');"
I3="    background-image: url('/usr/share/icons/$ICON_THEME/22x22/panel/audio-volume-high-panel.svg');"
I4="    background-image: url('/usr/share/icons/$ICON_THEME/22x22/panel/audio-volume-muted-panel.svg');"
I5="    background-image: url('/usr/share/icons/$ICON_THEME/22x22/panel/network-wireless-signal-excellent.svg');"
I6="    background-image: url('/usr/share/icons/$ICON_THEME/22x22/panel/network-wired.svg');"
I7="    background-image: url('/usr/share/icons/$ICON_THEME/22x22/panel/network-offline.svg');"
I8="    background-image: url('/usr/share/icons/$ICON_THEME/22x22/panel/bluetooth-active.svg');"
I9="    background-image: url('/usr/share/icons/$ICON_THEME/22x22/panel/bluetooth-paired.svg');"

sed -i "68s|.*|$I1|"  ~/.config/waybar/style.css
sed -i "72s|.*|$I2|"  ~/.config/waybar/style.css
sed -i "76s|.*|$I3|"  ~/.config/waybar/style.css
sed -i "80s|.*|$I4|"  ~/.config/waybar/style.css
sed -i "90s|.*|$I5|"  ~/.config/waybar/style.css
sed -i "97s|.*|$I6|"  ~/.config/waybar/style.css
sed -i "104s|.*|$I7|" ~/.config/waybar/style.css
sed -i "112s|.*|$I8|" ~/.config/waybar/style.css
sed -i "120s|.*|$I9|" ~/.config/waybar/style.css

# ── rofi (~/.config/rofi/config.rasi) ─────────────────────────────────────────
L1='    bg:        #1C1C1E;'
L2='    bg-alt:    #2C2C2E;'
L3='    bg-hover:  #3A3A3C;'
L4='    border:    #3A3A3C;'
L5='    fg:        #E5E5EA;'
L6='    fg-bright: #FFFFFF;'
L7='    fg-dim:    #8E8E93;'
L8='    accent:    #AEAEB2;'               # macOS graphite
L9='    urgent:    #FF453A;'

sed -i "2s|.*|$L1|" ~/.config/rofi/config.rasi
sed -i "3s|.*|$L2|" ~/.config/rofi/config.rasi
sed -i "4s|.*|$L3|" ~/.config/rofi/config.rasi
sed -i "5s|.*|$L4|" ~/.config/rofi/config.rasi
sed -i "6s|.*|$L5|" ~/.config/rofi/config.rasi
sed -i "7s|.*|$L6|" ~/.config/rofi/config.rasi
sed -i "8s|.*|$L7|" ~/.config/rofi/config.rasi
sed -i "9s|.*|$L8|" ~/.config/rofi/config.rasi
sed -i "10s|.*|$L9|" ~/.config/rofi/config.rasi

L10="    font:             \"$FONT 22\";"
sed -i "20s|.*|$L10|" ~/.config/rofi/config.rasi

# ── mako (~/.config/mako/config) ─────────────────────────────────────────────
L1='background-color=#1C1C1EFF'
L2='text-color=#E5E5EAFF'
L3='border-color=#AEAEB2FF'                # macOS graphite
L4='progress-color=#AEAEB2FF'
L5="font=$FONT 10"
L6='border-color=#FF453AFF'                # urgency=critical override

sed -i "1s|.*|$L1|" ~/.config/mako/config
sed -i "2s|.*|$L2|" ~/.config/mako/config
sed -i "3s|.*|$L3|" ~/.config/mako/config
sed -i "4s|.*|$L4|" ~/.config/mako/config
sed -i "5s|.*|$L5|" ~/.config/mako/config
sed -i "8s|.*|$L6|" ~/.config/mako/config

echo "Done."
