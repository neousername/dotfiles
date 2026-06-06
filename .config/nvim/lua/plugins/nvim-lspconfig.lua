return  {
    {
	"Fildo7525/pretty_hover",
	event = "LspAttach",
	opts = {}
    },

    {
      "mason-org/mason.nvim",
      opts = {}
    },

    {
      "neovim/nvim-lspconfig",
      config = function()

	vim.api.nvim_create_autocmd("LspAttach", {
	  callback = function(ev)
	    local opts = { buffer = ev.buf }
	    local map = vim.keymap.set

	    map("n", "gD", vim.lsp.buf.declaration, opts)
	    map("n", "gd", vim.lsp.buf.definition, opts)
	    map("n", "K", function()
	      require("pretty_hover").hover()
	    end, opts)
	    map("n", "gi", vim.lsp.buf.implementation, opts)
	    map("n", "<C-k>", vim.lsp.buf.signature_help, opts)
	    map("n", "<space>D", vim.lsp.buf.type_definition, opts)
	    map("n", "<space>rn", vim.lsp.buf.rename, opts)
	    map({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
	    map("n", "gr", vim.lsp.buf.references, opts)
	    map("n", "<space>f", function()
	      vim.lsp.buf.format({ async = true })
	    end, opts)
	  end,
	})
      end
    },

    {
      "mason-org/mason-lspconfig.nvim",
      dependencies = {
	  { "mason-org/mason.nvim", opts = {} },
	  "neovim/nvim-lspconfig",
      },
      opts = {
	ensure_installed = { "lua_ls", "pylsp" },
        automatic_enable = true,
      },
    },
}
