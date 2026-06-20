return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,

	config = function()
		require("catppuccin").setup({
			transparent_backroung = false
		})
		vim.cmd.colorscheme "catppuccin-nvim"
	end
}
