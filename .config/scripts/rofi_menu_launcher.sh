#!/usr/bin/env bash

BASE="/usr/share/icons/Papirus-Dark/22x22/apps"

declare -A ICONS=(
  [Firefox]="$BASE/firefox.svg"
  [Telegram]="$BASE/telegram.svg"
  [Signal]="$BASE/signal-desktop.svg"
  [Discord]="$BASE/discord.svg"
  [Xournal++]="$BASE/xournalpp.svg"
  [LibreOffice]="$BASE/libreoffice7.6-startcenter.svg"
  [OBS]="$BASE/obs.svg"
)

declare -A CMDS=(
  [Firefox]="firefox"
  [Telegram]="env QT_QPA_PLATFORM=xcb QT_SCALE_FACTOR=2 XCURSOR_SIZE=24 Telegram"
  [Signal]="signal-desktop"
  [Discord]="discord --ozone-platform=wayland"
  [Xournal++]="xournalpp"
  [LibreOffice]="libreoffice"
  [OBS]="obs"
)

NAMES=(Firefox Telegram Signal Discord Xournal++ LibreOffice OBS)

SELECTED=$(for name in "${NAMES[@]}"; do
  printf "%s\0icon\x1f%s\n" "$name" "${ICONS[$name]}"
done | rofi -dmenu \
  -i \
  -show-icons \
  -p "Launch:" \
  -theme "$HOME/.config/rofi/config.rasi")

[[ -z $SELECTED ]] && exit 0

[[ -n ${CMDS[$SELECTED]+_} ]] && uwsm app -- ${CMDS[$SELECTED]}
