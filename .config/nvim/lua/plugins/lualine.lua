return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },

  config = function()

    local function cwd()
      return vim.fn.expand("%:p:h:t")
    end

    require("lualine").setup {
      options = {
	theme = 'carbonfox',
      },
      sections = {
	lualine_a = { "mode" },
	lualine_b = { "branch" },
	lualine_c = { cwd, "filename" },
	lualine_x = {},
	lualine_y = { "diagnostics" },
	lualine_z = { "location", "progress" }
      }
    }

  end
}
