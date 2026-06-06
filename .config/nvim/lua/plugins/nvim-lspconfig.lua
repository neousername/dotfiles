return {
  "neovim/nvim-lspconfig",

  config = function()

    vim.lsp.enable({
      "lua_ls",
      "pylsp",
    })

    vim.api.nvim_create_autocmd('LspAttach', {

      group = vim.api.nvim_create_augroup('my.lsp', {}),

      callback = function(ev)

        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {
          buffer = ev.buf,
          desc = 'Go to definition',
        })

        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {
          buffer = ev.buf,
          desc = 'Go to declaration',
        })

        vim.keymap.set('n', 'K', vim.lsp.buf.hover, {
          buffer = ev.buf,
          desc = 'Hover documentation',
        })

        if client:supports_method('textDocument/implementation') then
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {
            buffer = ev.buf,
            desc = 'Go to implementation',
          })
        end

	if client:supports_method('textDocument/formatting') then
	  vim.keymap.set('n', '<leader>lf', function()
	    vim.lsp.buf.format({
	      bufnr = ev.buf,
	      id = client.id,
	    })
	  end, {
	    buffer = ev.buf,
	    desc = 'Format buffer',
	  })
	end

      end
    })
  end
}
