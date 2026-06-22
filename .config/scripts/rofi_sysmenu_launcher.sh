#!/usr/bin/env bash
BASE="/usr/share/icons/Papirus-Dark/22x22/apps"

declare -A ICONS=(
    [WiFi]="$BASE/nm-device-wireless.svg"
    [Bluetooth]="$BASE/preferences-bluetooth.svg"
    [Sound]="$BASE/preferences-sound.svg"
    [Performance]="$BASE/utilities-system-monitor.svg"
    [Display]="$BASE/preferences-desktop-display.svg"
    [Sleep]="$BASE/system-suspend.svg"
    [Logout]="$BASE/xfsm-logout.svg"
)

declare -A CMDS=(
    [WiFi]="uwsm app -- alacritty -e nmtui"
    [Bluetooth]="uwsm app -- alacritty -e bluetui"
    [Sound]="uwsm app -- alacritty -e pulsemixer"
    [Performance]="uwsm app -- alacritty -e btop"
    [Display]="uwsm app -- nwg-displays"
    [Sleep]="hyprctl dispatch dpms off && systemctl suspend"
    [Logout]="uwsm stop"
)

NAMES=(WiFi Bluetooth Sound Performance Display Sleep Logout)

SELECTED=$(for name in "${NAMES[@]}"; do
    printf "%s\0icon\x1f%s\n" "$name" "${ICONS[$name]}"
done | rofi -dmenu \
    -i \
    -show-icons \
    -p "System:" \
    -theme "$HOME/.config/rofi/config.rasi")

[[ -z "$SELECTED" ]] && exit 0

[[ -n "${CMDS[$SELECTED]+_}" ]] && bash -c "${CMDS[$SELECTED]}" & disown
