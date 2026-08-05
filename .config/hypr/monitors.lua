-- My HDR OLED VRR Monitor Config

hl.monitor({
	output = "HDMI-A-1",
	mode = "3840x2160@120",
	scale = 1.5,
	bitdepth = 10,
	cm = "srgb",

	-- hdr is available in games only
	supports_hdr = 1,
	supports_wide_color = 1,

	-- enable vrr for specific window types
	-- configure this in windowrules.lua
	vrr = 3,
})
