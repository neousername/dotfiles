return {
	"sindrets/diffview.nvim",
	config = function()
		require("diffview").setup({
			view = {
				default = { layout = "diff2_vertical" },
				file_history = { layout = "diff2_vertical" },
				merge_tool = { layout = "diff3_vertical" },
			},
		})
	end,
	keys = {
		{
			"<leader>gd",
			function()
				local lib = require("diffview.lib")
				if lib.get_current_view() then
					vim.cmd("DiffviewClose")
				else
					vim.cmd("DiffviewOpen")
				end
			end,
			desc = "Toggle diff view",
		},
	},
}
