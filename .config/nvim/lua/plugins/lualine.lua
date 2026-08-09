return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },

	config = function()
		local function cwd()
			return vim.fn.expand("%:p:h:t")
		end

		require("lualine").setup({
			options = {
				theme = "auto",
				globalstatus = true,
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch" },
				lualine_c = { cwd, "filename" },

				-- Show the currently connected server and its status
				lualine_x = { require("opencode").statusline },

				lualine_y = { "diagnostics" },
				lualine_z = { "location", "progress" },
			},
		})
	end,
}
