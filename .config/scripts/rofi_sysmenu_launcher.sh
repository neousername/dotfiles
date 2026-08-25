#!/usr/bin/env bash
BASE="/usr/share/icons/Papirus-Dark/22x22/apps"

declare -A ICONS=(
    [WiFi]="$BASE/nm-device-wireless.svg"
    [Bluetooth]="$BASE/preferences-bluetooth.svg"
    [Sound]="$BASE/preferences-sound.svg"
    [Displays]="$BASE/cs-display.svg"
    [Storage]="$BASE/filelight.svg"
    [Performance]="$BASE/utilities-system-monitor.svg"
    [Sleep]="$BASE/system-suspend.svg"
    [Logout]="$BASE/xfsm-logout.svg"
)

declare -A CMDS=(
    [WiFi]="uwsm app -- ghostty -e nmtui"
    [Bluetooth]="uwsm app -- ghostty -e bluetui"
    [Sound]="uwsm app -- ghostty -e pulsemixer"
    [Displays]="uwsm app -- nwg-displays"
    [Storage]="uwsm app -- filelight"
    [Performance]="uwsm app -- ghostty -e btop"
    [Sleep]="systemctl suspend-then-hibernate"
    [Logout]="uwsm stop"
)

NAMES=(WiFi Bluetooth Sound Displays Storage Performance Sleep Logout)

SELECTED=$(for name in "${NAMES[@]}"; do
    printf "%s\0icon\x1f%s\n" "$name" "${ICONS[$name]}"
done | rofi -dmenu \
    -i \
    -show-icons \
    -p "System:" \
    -theme "$HOME/.config/rofi/config.rasi")

[[ -z $SELECTED ]] && exit 0

[[ -n ${CMDS[$SELECTED]+_} ]] && bash -c "${CMDS[$SELECTED]}"
