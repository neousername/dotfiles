return {
	"sindrets/diffview.nvim",
	config = function()
		require("diffview").setup({
			hooks = {
				view_opened = function()
					vim.schedule(function()
						vim.cmd("wincmd l")
						vim.cmd("wincmd j")
					end)
				end,
			},
			view = {
				default = { layout = "diff2_vertical" },
				file_history = { layout = "diff2_vertical" },
				merge_tool = { layout = "diff3_vertical" },
			},
		})
		vim.keymap.set("n", "<leader>gd", function()
			if require("diffview.lib").get_current_view() then
				vim.cmd("DiffviewClose")
			else
				vim.cmd("DiffviewOpen")
			end
		end, { desc = "Toggle git diff" })
		vim.keymap.set("n", "ö", "]c", { desc = "Next diff hunk" })
		vim.keymap.set("n", "ä", "[c", { desc = "Prev diff hunk" })
	end,
}
