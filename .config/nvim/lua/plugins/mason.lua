return {
    {
        "mason-org/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },

    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = {
            "mason-org/mason.nvim",
        },
        config = function()
            require("mason-tool-installer").setup({
                ensure_installed = {
                    -- LSPs
                    "bash-language-server",
                    "lua-language-server",
                    "python-lsp-server",
                    "vtsls",
                    "html-lsp",
                    "css-lsp",

                    -- Formaters
                    "shfmt",
                    "stylua",
                    "ruff",
                    "prettier",
                    "biome",
                },
            })
        end,
    },
}
