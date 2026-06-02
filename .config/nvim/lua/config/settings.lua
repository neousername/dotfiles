vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.opt.number=true
vim.opt.cursorline = true
vim.opt.shiftwidth = 2
vim.wo.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.o.cmdheight = 0
vim.o.autoread = true

-- Custom Diagnostic Icons
local severity = vim.diagnostic.severity
vim.diagnostic.config({
  signs = {
    text = {
      [severity.ERROR] = "",
      [severity.WARN] = "",
      [severity.HINT] = "",
      [severity.INFO] = "",
    }
  }
})
