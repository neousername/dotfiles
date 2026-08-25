# Waybar Agent Notes

- Edit `.config/waybar/config` for modules and `.config/waybar/style.css` for layout.
- Validate the config with `jq empty .config/waybar/config`.
- Reload with `pkill -SIGUSR2 waybar`; avoid restarting the session.
- Static spaces in `format` remain when a placeholder is empty. Put conditional spacing inside rewrite values instead.
- GTK padding and `min-width` can distort spacing. Separate internal gaps from section-edge padding.
- Use Waybar state selectors such as `.empty`, `:first-child`, and `:last-child` carefully.
- Prefer `JetBrainsMono Nerd Font Propo` for standalone icons to avoid clipped glyphs.
- Equal CSS values may look unequal because of font metrics. Verify visually and change one value at a time.
