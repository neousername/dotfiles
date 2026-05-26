#!/usr/bin/env bash
cliphist list \
    | rofi -dmenu \
        -p "Clipboard:" \
        -theme "$HOME/.config/rofi/config.rasi" \
    | cliphist decode \
    | wl-copy!/usr/bin/env bash
