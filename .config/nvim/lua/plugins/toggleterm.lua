return {
	"akinsho/toggleterm.nvim",
	version = "*",
	keys = {
		{ "<F6>", "<cmd>ToggleTerm<CR>", mode = "n", desc = "Toggle terminal" },
		{ "<F6>", [[<C-\><C-n><cmd>ToggleTerm<CR>]], mode = "t", desc = "Toggle terminal" },
	},
	opts = {
		direction = "tab",
	},
}
