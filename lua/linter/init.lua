return {
    "nvimtools/none-ls.nvim",
    dependencies = { "mason.nvim", "nvim-lua/plenary.nvim" },
    config = function()
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                -- Disabled Mypy to prevent crashes and overlap with Pyright
                -- null_ls.builtins.diagnostics.mypy.with({ extra_args = mypy_args }),
                
                -- You can add other non-Python sources here if needed
            },
        })
    end,
}


