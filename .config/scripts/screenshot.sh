#!/usr/bin/env bash

set -u

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

FILE="$SCREENSHOT_DIR/$(date '+%Y%m%d_%H%M%S').png"

case "${1:-}" in
output)
  grim "$FILE" || exit 1
  ;;
region)
  GEOM="$(slurp)" || exit 0
  grim -g "$GEOM" "$FILE" || exit 1
  ;;
*)
  echo "Usage: ${0##*/} [output|region]" >&2
  exit 2
  ;;
esac

wl-copy --type image/png <"$FILE" || exit 1

notify-send \
  --app-name="Screenshot" \
  --expire-time=2000 \
  "Screenshot saved" \
  "$(basename "$FILE")"
