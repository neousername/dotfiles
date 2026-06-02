#!/usr/bin/env bash
BASE="/usr/share/icons/Papirus-Dark/22x22/apps"

declare -A ICONS=(
    [Firefox]="$BASE/firefox.svg"
    [Email]="$BASE/thunderbird.svg"
    [Telegram]="$BASE/telegram-desktop.svg"
    [Discord]="$BASE/discord.svg"
    [Signal]="$BASE/signal-desktop.svg"
    [Steam]="$BASE/steam.svg"
    [OBS]="$BASE/obs.svg"
    [LibreOffice]="$BASE/libreoffice7.6-startcenter.svg"
    [Gimp]="$BASE/gimp.svg"
    [Bitwarden]="$BASE/bitwarden.svg"
)

declare -A CMDS=(
    [Firefox]="firefox"
    [Email]="thunderbird"
    [Telegram]="Telegram"
    [Discord]="discord"
    [Signal]="signal-desktop"
    [Steam]="steam"
    [OBS]="obs"
    [LibreOffice]="libreoffice"
    [Gimp]="gimp"
    [Bitwarden]="bitwarden-desktop"
)

NAMES=(Firefox Email Telegram Discord Signal Steam OBS LibreOffice Gimp Bitwarden)

SELECTED=$(for name in "${NAMES[@]}"; do
    printf "%s\0icon\x1f%s\n" "$name" "${ICONS[$name]}"
done | rofi -dmenu \
    -i \
    -show-icons \
    -p "Launch:" \
    -theme "$HOME/.config/rofi/config.rasi")

[[ -z "$SELECTED" ]] && exit 0

[[ -n "${CMDS[$SELECTED]+_}" ]] && uwsm app -- ${CMDS[$SELECTED]} & disown
