return {
	"akinsho/toggleterm.nvim",
	version = "*",
	keys = {
		{ "<F7>", "<cmd>ToggleTerm<CR>", mode = "n", desc = "Toggle terminal" },
		{ "<F7>", [[<C-\><C-n><cmd>ToggleTerm<CR>]], mode = "t", desc = "Toggle terminal" },
	},
	opts = {
		direction = "tab",
	},
}
