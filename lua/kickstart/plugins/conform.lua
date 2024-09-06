--[[
A formatter plugin.

- preserves marks and folds with formatting
- works with lsp formatters
--]]

return {
    { -- Autoformat
        "stevearc/conform.nvim",
        -- event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>f",
                function()
                    require("conform").format({ async = true, lsp_format = "fallback" })
                end,
                mode = "",
                desc = "[F]ormat buffer",
            },
        },
        opts = {
            notify_on_error = true,
            formatters_by_ft = {
                -- lua = { 
                --     "stylua",
                --     extra_args = { "--indent-type", "Spaces", "--indent-width", "4" }, -- Change to spaces
                -- },
                python = { "black" },
                -- You can use 'stop_after_first' to run the first available formatter from the list
                -- javascript = { "prettierd", "prettier", stop_after_first = true },
            },
        },
    },
}
