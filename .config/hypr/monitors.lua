hl.monitor({
	output = "HDMI-A-1", -- output name, or "desc:Make Model" (drop the portname)
	mode = "3840x2160@120", -- resolution + refresh, or "preferred" / "highrr" / "highres"
	position = "0x0", -- virtual-layout position, or "auto" / "auto-right" etc.
	scale = 2, -- float, or "auto"

	disabled = false, -- true removes the monitor from the layout
	transform = 0, -- 0-7, rotation/flip
	mirror = "", -- output name to mirror ("" = none)

	-- ── color / HDR ──────────────────────────────────────────────
	bitdepth = 10, -- 8 or 10.  10 is REQUIRED for HDR
	cm = "hdredid",
	--   presets: auto | srgb | dcip3 | dp3 | adobe
	--            wide | edid | hdr | hdredid
	sdr_eotf = "gamma22", -- default | gamma22 | srgb
	sdrbrightness = 1.5, -- only applies while the monitor is IN hdr mode
	sdrsaturation = 1, -- only applies while the monitor is IN hdr mode

	supports_wide_color = 1, -- -1 off | 0 auto | 1 force
	supports_hdr = 1, -- -1 off | 0 auto | 1 force.
	--   set 1 ONLY if `hyprctl monitors -j` shows
	--   supportsHDR:false but the panel really is HDR

	-- SDR→HDR tone-mapping (used when SDR content shows while in hdr mode)
	sdr_min_luminance = 0, -- float
	sdr_max_luminance = 80, -- integer (nits)

	-- monitor's own luminance capabilities (-1 = read from EDID)
	min_luminance = 0, -- float
	max_luminance = -1, -- integer, peak nits
	max_avg_luminance = -1, -- integer, sustained/avg nits

	-- ── other ────────────────────────────────────────────────────
	vrr = 1, -- 0 off | 1 on | 2 fullscreen-only
})
