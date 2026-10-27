-- Settings --
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt_local.expandtab = true
vim.opt.shiftwidth = 2
vim.g.mapleader = " "
vim.opt.clipboard = "unnamedplus"

-- Install plugins --
vim.pack.add({
  "https://github.com/rose-pine/neovim",
  "https://github.com/windwp/nvim-autopairs",
  "https://github.com/Fildo7525/pretty_hover",

  -- Lualine
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-lualine/lualine.nvim",

  -- Telescope
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",

  -- Neo-tree
  "https://github.com/nvim-neo-tree/neo-tree.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/MunifTanjim/nui.nvim",

  -- Mason
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",

  "https://github.com/neovim/nvim-lspconfig",
})

-- Initialize plugins --
require("rose-pine").setup()
require("nvim-autopairs").setup()
require("pretty_hover").setup()
require("lualine").setup()

-- Telescope
require("telescope").setup({
  defaults = {
    sorting_strategy = "ascending",
  },
})

require("neo-tree").setup({})

-- Mason
require("mason").setup()
require("mason-tool-installer").setup {
  ensure_installed = {
    "lua-language-server",
    "basedpyright",
    "ruff",
  },
  auto_update = true,
}

-- Miscellaneous --

-- Colorscheme
vim.cmd("colorscheme rose-pine")

-- Terminal
vim.keymap.set("n", "<leader>t", function()
  vim.cmd("terminal")
end)

-- Navigation --
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Telescope git status" })

-- Tree-view
vim.keymap.set("n", "<leader>pv", function()
  vim.cmd("Neotree filesystem reveal float toggle")
end, { desc = "Project view" })

-- LSP --

-- Enable nvim-lspconfigs
vim.lsp.enable("lua_ls")
vim.lsp.enable("basedpyright")
vim.lsp.enable("ruff")

-- Keybinds
-- Use gra for code actions
-- Use gx to open documentation of an import externally
-- Use grx for codelens
vim.keymap.set("n", "grr", builtin.lsp_references)
vim.keymap.set("n", "gri", builtin.lsp_implementations)
vim.keymap.set("n", "grt", builtin.lsp_type_definitions)
vim.keymap.set("n", "gO", builtin.lsp_document_symbols)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
  desc = "Go to definition",
})
vim.keymap.set("n", "<leader>pd", builtin.diagnostics)
vim.keymap.set("n", "K", function()
  require("pretty_hover").hover()
end, { desc = "Pretty LSP hover" })


-- LSP features

-- Completion menu config
vim.opt.completeopt = { "menuone", "noselect", "popup" }
vim.opt.pumheight = 5

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("my.lsp", {}),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

    -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end

    -- Auto-format ("lint") on save.
    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    if not client:supports_method("textDocument/willSaveWaitUntil")
        and client:supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("my.lsp", { clear = false }),
        buffer = ev.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end
  end,
})
