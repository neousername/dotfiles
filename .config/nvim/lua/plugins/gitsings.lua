return {
    "lewis6991/gitsigns.nvim",

    config = function()
        local gitsigns = require("gitsigns")

        gitsigns.setup({
            on_attach = function(bufnr)
                local function map(lhs, rhs, desc)
                    vim.keymap.set("n", lhs, rhs, {
                        buffer = bufnr,
                        desc = desc,
                    })
                end

                -- Start / refresh Git diff review.
                map("<leader>gd", function()
                    gitsigns.setqflist("all", { open = false }, function(err)
                        if not err then
                            vim.cmd("cfirst")
                        end
                    end)
                end, "Start Git diff review")

                -- Navigate all Git changes across the project.
                map("<leader>j", "<cmd>cnext<cr>", "Next Git change")
                map("<leader>k", "<cmd>cprev<cr>", "Previous Git change")

                -- Preview current hunk inline.
                map("<leader>i", gitsigns.preview_hunk_inline, "Preview Git change")
            end,
        })
    end,
}
