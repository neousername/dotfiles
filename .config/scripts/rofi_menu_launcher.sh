#!/usr/bin/env bash
BASE="/usr/share/icons/Papirus-Dark/22x22/apps"

declare -A ICONS=(
    [Firefox]="$BASE/firefox.svg"
    [LibreOffice]="$BASE/libreoffice7.6-startcenter.svg"
)

declare -A CMDS=(
    [Firefox]="firefox"
    [LibreOffice]="libreoffice"
)

NAMES=(Firefox LibreOffice)

SELECTED=$(for name in "${NAMES[@]}"; do
    printf "%s\0icon\x1f%s\n" "$name" "${ICONS[$name]}"
done | rofi -dmenu \
    -i \
    -show-icons \
    -p "Launch:" \
    -theme "$HOME/.config/rofi/config.rasi")

[[ -z "$SELECTED" ]] && exit 0

[[ -n "${CMDS[$SELECTED]+_}" ]] && uwsm app -- ${CMDS[$SELECTED]} 
