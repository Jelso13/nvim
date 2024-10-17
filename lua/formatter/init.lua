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
                "<leader>ff",
                function()
                    require("conform").format({ async = true, lsp_format = "fallback" })
                end,
                mode = "",
                desc = "[F]ile [F]ormat",
            },
        },
        opts = {
            default_format_opts = {
                timeout_ms = 3000,
                async = false,           -- not recommended to change
                quiet = false,           -- not recommended to change
                lsp_format = "fallback", -- not recommended to change
            },
            notify_on_error = true,
            formatters_by_ft = {
            --     lua = require("formatter.formatters.lua"),
            --     python = require("formatter.formatters.python"),
            lua = { "stylua" },
            python = { "black" },
            --     -- You can use 'stop_after_first' to run the first available formatter from the list
            --     -- javascript = { "prettierd", "prettier", stop_after_first = true },
            },
            -- formatters = {
            --     stylua = require("formatter.formatters.lua"),
            --     black = require("formatter.formatters.python"),
            -- },
        },
        init = function()
            require("formatter.config")
        end,
    },
}
