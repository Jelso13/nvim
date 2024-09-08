
return {
    { -- Autoformat
        "nvimtools/none-ls.nvim",
        dependencies = { "mason.nvim" },
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.completion.spell,
                    -- require("none-ls.diagnostics.eslint"), -- requires none-ls-extras.nvim
                    null_ls.builtins.diagnostics.mypy.with({
                        extra_args = { "--strict" },  -- Optional: enable strict mode in MyPy
                    }),
                    -- Other sources like formatters can be added here
                    null_ls.builtins.formatting.black.with({
                        extra_args = { "--line-length", "88" },
                    }),
                    null_ls.builtins.formatting.isort,
                },
            })
        end,
    },
}
