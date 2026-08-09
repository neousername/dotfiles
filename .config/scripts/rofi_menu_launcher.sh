#!/usr/bin/env bash
BASE="/usr/share/icons/Papirus-Dark/22x22/apps"

declare -A ICONS=(
    [Firefox]="$BASE/firefox.svg"
    [Signal]="$BASE/signal-desktop.svg"
    [OBS]="$BASE/obs.svg"
    [KdenLive]="$BASE/kdenlive.svg"
    [LibreOffice]="$BASE/libreoffice7.6-startcenter.svg"
    [Gimp]="$BASE/gimp.svg"
)

declare -A CMDS=(
    [Firefox]="firefox"
    [Signal]="signal-desktop"
    [OBS]="obs"
    [KdenLive]="kdenlive"
    [LibreOffice]="libreoffice"
    [Gimp]="gimp"
)

NAMES=(Firefox Signal OBS KdenLive LibreOffice Gimp)

SELECTED=$(for name in "${NAMES[@]}"; do
    printf "%s\0icon\x1f%s\n" "$name" "${ICONS[$name]}"
done | rofi -dmenu \
    -i \
    -show-icons \
    -p "Launch:" \
    -theme "$HOME/.config/rofi/config.rasi")

[[ -z "$SELECTED" ]] && exit 0

[[ -n "${CMDS[$SELECTED]+_}" ]] && uwsm app -- ${CMDS[$SELECTED]} 
