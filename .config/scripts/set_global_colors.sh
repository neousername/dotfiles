#!/usr/bin/env bash
set -euo pipefail

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
L1='$col_outer = rgba(255, 255, 255, 0.35)'
L2='$col_inner = rgba(255, 255, 255, 0.12)'
L3='$col_text  = rgb(255, 255, 255)'
L4='$col_check = rgb(174, 174, 178)'        # macOS graphite gray
L5='$col_label = rgba(242, 243, 244, 0.65)'

sed -i "1s|.*|$L1|" ~/.config/hypr/hyprlock.conf
sed -i "2s|.*|$L2|" ~/.config/hypr/hyprlock.conf
sed -i "3s|.*|$L3|" ~/.config/hypr/hyprlock.conf
sed -i "4s|.*|$L4|" ~/.config/hypr/hyprlock.conf
sed -i "5s|.*|$L5|" ~/.config/hypr/hyprlock.conf

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

echo "Done."
