return {
	"akinsho/toggleterm.nvim",
	version = "*",
	keys = {
		{ "<C-t>", "<cmd>ToggleTerm<CR>", mode = "n", desc = "Toggle terminal" },
		{ "<C-t>", [[<C-\><C-n><cmd>ToggleTerm<CR>]], mode = "t", desc = "Toggle terminal" },
	},
	opts = {
		direction = "tab",
	},
}
