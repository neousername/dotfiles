-- Settings --
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt_local.expandtab = true
vim.opt.shiftwidth = 2
vim.g.mapleader = " "
vim.opt.clipboard = "unnamedplus"

-- Install plugins --
vim.pack.add({
  -- Colortheme
  "https://github.com/rose-pine/neovim",

  -- Autopairs
  "https://github.com/windwp/nvim-autopairs",

  -- Pretty Hover
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

  -- Harpoon2 (plenary is required)
  { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },

  -- Mason
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",

  -- LSP config
  "https://github.com/neovim/nvim-lspconfig",

  -- Treesitter
  "https://github.com/nvim-treesitter/nvim-treesitter",

})

-- Terminal
vim.keymap.set("n", "<leader>t", function()
  vim.cmd("terminal")
end)

-- Colorscheme
require("rose-pine").setup()
vim.cmd("colorscheme rose-pine")

-- Autopairs
require("nvim-autopairs").setup()

-- Lualine
require('lualine').setup {
  sections = {
    lualine_x = {},
    lualine_y = { "diagnostics", "progress" },
    lualine_z = {},
  },
}

-- Telescope
require("telescope").setup({
  defaults = {
    sorting_strategy = "ascending",
  },
})
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>pg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>pb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- Mason
require("mason").setup()
require("mason-tool-installer").setup {
  ensure_installed = {
    "lua-language-server",
    "pyright",
    "ruff",
  },
  auto_update = true,
}

-- Harpoon
local harpoon = require("harpoon")
harpoon:setup()
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

-- Neotree
require("neo-tree").setup({
  window = {
    position = "current",
  },
  buffers = {
    follow_current_file = {
      enabled = true,
      leave_dirs_open = true,
    }
  },
  filesystem = {
    filtered_times = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignored = false,
      hide_hidden = false,
    }
  }
})
vim.keymap.set("n", "<leader>pv", function()
  vim.cmd("Neotree")
end, { desc = "Project view" })

-- Enable nvim-lspconfigs
vim.lsp.enable("lua_ls")
vim.lsp.enable("pyright")
vim.lsp.enable("clangd")

-- LSP Keybinds
vim.keymap.set("n", "<leader>lr", builtin.lsp_references)
vim.keymap.set("n", "<leader>lo", builtin.lsp_document_symbols)
vim.keymap.set("n", "<leader>li", builtin.lsp_implementations)
vim.keymap.set("n", "<leader>ld", builtin.lsp_type_definitions)
vim.keymap.set("n", "<leader>lc", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>ll", vim.lsp.codelens.run, { desc = "Run code lens" })
vim.keymap.set("n", "<leader>lg", "gx", { remap = true, desc = "Open link under cursor" })
vim.keymap.set("n", "<leader>pd", function()
  vim.diagnostic.setloclist()
end)
require("pretty_hover").setup()
vim.keymap.set("n", "K", function()
  require("pretty_hover").hover()
end, { desc = "Pretty LSP hover" })

-- Popup menu
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- LSP setup
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("my.lsp", {}),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

    -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end

    -- Auto-format on save.
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

-- Treesitter
require("nvim-treesitter").install({ "python" })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "python" },
  callback = function(ev)
    vim.treesitter.start(ev.buf)
  end,
})
