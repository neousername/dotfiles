return {
	"linux-cultist/venv-selector.nvim",
	dependencies = {
		{ "nvim-telescope/telescope.nvim" },
	},
	ft = "python", -- Load when opening Python files
	keys = { { ",v", "<cmd>VenvSelect<cr>" } }, -- Open picker on keymap
	opts = {
		options = {
			selected_venv_marker_icon = "*",
			picker_icons = {
				cwd = "󰉋",
				workspace = "󱂬",
				file = "󰈙",
				virtualenvs = "",
				poetry = "",
				pyenv = "",
				default = "",
			},
		},
		search = {}, -- custom search definitions
	},
}
