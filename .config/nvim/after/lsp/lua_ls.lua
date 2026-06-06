return {
  root_dir = vim.fn.expand("~/.config/nvim"),

  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      workspace = {
        preloadFileSize = 10000,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
    },
  },
}
