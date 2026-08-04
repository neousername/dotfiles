return {
	"akinsho/toggleterm.nvim",
	version = "*",
	keys = {
		{ "<leader>t", "<cmd>ToggleTerm<CR>", mode = "n", desc = "Toggle terminal" },
		{ "<leader>t", [[<C-\><C-n><cmd>ToggleTerm<CR>]], mode = "t", desc = "Toggle terminal" },
	},
	opts = {
		direction = "tab",
	},
}
