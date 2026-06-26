#!/usr/bin/env bash
mapfile -t entries < <(cliphist list)

choice=$(printf '%s\n' "${entries[@]#*$'\t'}" | rofi -dmenu -format i -p "Clipboard:" -theme "$HOME/.config/rofi/config.rasi")
[[ -z "$choice" || "$choice" == "-1" ]] && exit 0

selected=${entries[$choice]}

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

printf '%s' "$selected" | cliphist decode > "$tmp"
wl-copy --foreground < "$tmp"
