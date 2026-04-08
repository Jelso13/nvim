return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    -- 1. "Off by default" via Lazy Loading
    -- The plugin will NOT load into memory until you press this key
    keys = {
        {
            "<leader>ta",
            "<cmd>CodeCompanionChat Toggle<cr>",
            mode = { "n", "v" },
            desc = "[T]oggle [A]i Chat",
        },
        {
            -- Optional: A hotkey to trigger inline AI actions (like refactoring)
            "<leader>ac",
            "<cmd>CodeCompanionActions<cr>",
            mode = { "n", "v" },
            desc = "[A]i [C]ode Actions",
        }
    },
    config = function()
        require("codecompanion").setup({
            -- 2. Define your free AI provider
            strategies = {
                chat = {
                    adapter = "gemini",
                },
                inline = {
                    adapter = "gemini",
                },
                agent = {
                    adapter = "gemini",
                },
            },
            -- Optional: Customize how the chat window looks
            display = {
                chat = {
                    window = {
                        layout = "sidebar", -- Shows on the right side of your screen
                        width = 40,
                    },
                },
            },
        })
    end,
}
