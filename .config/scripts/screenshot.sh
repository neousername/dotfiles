#!/usr/bin/env bash
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"
FILE="$SCREENSHOT_DIR/$(date +%Y%m%d_%H%M%S).png"

case $1 in
    output)
        grim "$FILE" || exit 1
        ;;
    region)
        GEOM=$(slurp) || exit 0
        grim -g "$GEOM" "$FILE" || exit 1
        ;;
    *)
        echo "Usage: screenshot.sh [output|region]"; exit 1
        ;;
esac

wl-copy --type image/png < "$FILE"
