local mainMod = "SUPER"

-- Clipboard Menu Keybind
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("uwsm app -- ~/.config/scripts/rofi_clipboard_launcher.sh"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("cliphist wipe"))

-- Screenshots
hl.bind("PRINT", hl.dsp.exec_cmd("uwsm app -- ~/.config/scripts/screenshot.sh output"))
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("uwsm app -- ~/.config/scripts/screenshot.sh region"))

-- System
hl.bind(mainMod .. " + RETURN",     hl.dsp.exec_cmd("uwsm app -- alacritty"))
hl.bind(mainMod .. " + ALT + SPACE", hl.dsp.exec_cmd("uwsm app -- ~/.config/scripts/rofi_sysmenu_launcher.sh"))
hl.bind(mainMod .. " + SPACE",      hl.dsp.exec_cmd("uwsm app -- ~/.config/scripts/rofi_menu_launcher.sh"))

-- Useful
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = 0 }))
hl.bind(mainMod .. " + P", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + T", hl.dsp.layout("togglesplit"))

-- Apps
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("uwsm app -- firefox"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("uwsm app -- thunderbird"))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("uwsm app -- Telegram"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("uwsm app -- signal-desktop"))

-- Move focus with mainMod + HJKL
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
