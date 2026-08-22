return {
    "stevearc/conform.nvim",
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                sh = { "shfmt" },
                lua = { "stylua" },
                python = { "ruff_organize_imports", "ruff_format" },
                javascript = { "prettier" },
                javascriptreact = { "prettier" },
                typescript = { "prettier" },
                typescriptreact = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
            },

            formaters = {
                stylua = {
                    prepend_args = { "--search-parent-directories" },
                },
            },

            format_on_save = {
                timeout_ms = 500,
                lsp_format = "never",
            },
        })
    end,
}
