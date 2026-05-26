return {
  settings = {
    Lua = {
      codeLens = { enable = true },
      hint = { enable = true, semicolon = 'Disable' },
      workspace = {
	checkThirdParty = false,
	library = vim.api.nvim_get_runtime_file('', true),
      },
    },
  },
}
