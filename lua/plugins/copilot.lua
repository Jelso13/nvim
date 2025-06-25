--[[
Copilot
--]]

return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    lazy = true,
    dependencies = {
        {
          "zbirenbaum/copilot-cmp",
          config = function ()
            require("copilot_cmp").setup()
          end
        }
    },
    -- event = "InsertEnter",
    config = function()
        require("copilot").setup({
            panel = {
                enabled = false, -- Disable the panel by default
                auto_refresh = false,
                keymap = {
                    jump_prev = "[[",
                    jump_next = "]]",
                    accept = "<CR>",
                    refresh = "gr",
                    open = "<C-CR>",
                },
                layout = {
                    position = "bottom", -- | top | left | right
                    ratio = 0.4,
                },
            },
            suggestion = {
                enabled = false, -- Disable suggestions by default
                auto_trigger = true, -- Disable auto-triggering of suggestions
                hide_during_completion = true,
                debounce = 75,
                keymap = {
                    accept = "<Tab>",
                    accept_word = false,
                    accept_line = false,
                    next = "<S-Tab>",
                    prev = "<M-[>",
                    dismiss = "<C-]>",
                },
            },
            filetypes = {
                yaml = false,
                markdown = true,
                help = false,
                gitcommit = false,
                gitrebase = false,
                hgcommit = false,
                svn = false,
                cvs = false,
                ["."] = false,
            },
            copilot_node_command = "node", -- Node.js version must be > 18.x
            server_opts_overrides = {},
        })
    end,
}
