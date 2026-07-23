#!/usr/bin/env bash
set -euo pipefail

# ── global font ───────────────────────────────────────────────────────────────
# Change this to switch the font everywhere at once (waybar, rofi, mako, hyprlock).
# Alacritty keeps its own monospace/Nerd Font setting on purpose.
FONT="Inter"

# ── hyprland (~/.config/hypr/style.lua) ──────────────────────────────────────
L1='local col_active_border_1 = "rgba(6e6e73cc)"'
L2='local col_active_border_2 = "rgba(3a3a3c88)"'
L3='local col_inactive_border = "rgba(d1d1d6aa)"'
L4='local col_shadow         = 0xee0d0d0f'

sed -i "1s|.*|$L1|" ~/.config/hypr/style.lua
sed -i "2s|.*|$L2|" ~/.config/hypr/style.lua
sed -i "3s|.*|$L3|" ~/.config/hypr/style.lua
sed -i "4s|.*|$L4|" ~/.config/hypr/style.lua

# ── hyprlock (~/.config/hypr/hyprlock.conf) ───────────────────────────────────
L1='    inner_color = rgba(0, 0, 0, 0.0) # no fill'
L2='    outer_color = rgba(6e6e7359) rgba(3a3a3c59) 45deg'
L3="    check_color=rgba(6e6e73ee) rgba(3a3a3cee) 120deg"
L4='    fail_color=rgba(ff3b30ee) rgba(ff3b30ee) 40deg'
L5='    font_color = rgb(28, 28, 30)'
L6="    font_family = $FONT"

sed -i "5s|.*|$L1|"  ~/.config/hypr/hyprlock.conf
sed -i "7s|.*|$L2|"  ~/.config/hypr/hyprlock.conf
sed -i "8s|.*|$L3|"  ~/.config/hypr/hyprlock.conf
sed -i "9s|.*|$L4|"  ~/.config/hypr/hyprlock.conf
sed -i "11s|.*|$L5|" ~/.config/hypr/hyprlock.conf
sed -i "12s|.*|$L6|" ~/.config/hypr/hyprlock.conf

# ── waybar (~/.config/waybar/style.css) ───────────────────────────────────────
L1='@define-color bg        #FFFFFF;'
L2='@define-color bg_alt    #F2F2F7;'
L3='@define-color bg_hover  #E5E5EA;'
L4='@define-color fg        #1C1C1E;'
L5='@define-color fg_bright #000000;'
L6='@define-color fg_dim    #8E8E93;'
L7='@define-color accent    #6E6E73;'      # macOS graphite (light)
L8='@define-color urgent    #FF3B30;'

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

# ── rofi (~/.config/rofi/config.rasi) ─────────────────────────────────────────
L1='    bg:        #FFFFFF;'
L2='    bg-alt:    #F2F2F7;'
L3='    bg-hover:  #E5E5EA;'
L4='    border:    #E5E5EA;'
L5='    fg:        #1C1C1E;'
L6='    fg-bright: #000000;'
L7='    fg-dim:    #8E8E93;'
L8='    accent:    #6E6E73;'               # macOS graphite (light)
L9='    urgent:    #FF3B30;'

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
L1='background-color=#FFFFFFFF'
L2='text-color=#1C1C1EFF'
L3='border-color=#6E6E73FF'                # macOS graphite (light)
L4='progress-color=#6E6E73FF'
L5="font=$FONT 10"
L6='border-color=#FF3B30FF'                # urgency=critical override

sed -i "1s|.*|$L1|" ~/.config/mako/config
sed -i "2s|.*|$L2|" ~/.config/mako/config
sed -i "3s|.*|$L3|" ~/.config/mako/config
sed -i "4s|.*|$L4|" ~/.config/mako/config
sed -i "5s|.*|$L5|" ~/.config/mako/config
sed -i "8s|.*|$L6|" ~/.config/mako/config

echo "Done."
