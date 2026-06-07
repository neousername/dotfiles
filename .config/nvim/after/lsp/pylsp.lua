return {
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          -- Ignore line length warnings.
          ignore = { "E501" },
        },
      },
    },
  },
}
