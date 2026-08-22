return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter").install({
            "lua",
            "python",
            "bash",
            "javascript",
            "typescript",
            "tsx",
            "html",
            "css",
        })
    end,
}
