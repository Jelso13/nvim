-- NOTE: Plugins can also be configured to run Lua code when they are loaded.
--
-- This is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- For example, in the following configuration, we use:
--  event = 'VimEnter'
--
-- which loads which-key before all the UI elements are loaded. Events can be
-- normal autocommands events (`:help autocmd-events`).
--
-- Then, because we use the `config` key, the configuration only runs
-- after the plugin has been loaded:
--  config = function() ... end

return {
    { -- Useful plugin to show you pending keybinds.
        "folke/which-key.nvim",
        event = "VimEnter", -- Sets the loading event to 'VimEnter'
        opts = {
            icons = {
                -- set icon mappings to true if you have a Nerd Font
                mappings = vim.g.have_nerd_font,
                -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
                -- default whick-key.nvim defined Nerd Font icons, otherwise define a string table
                keys = vim.g.have_nerd_font and {} or {
                    Up = "<Up> ",
                    Down = "<Down> ",
                    Left = "<Left> ",
                    Right = "<Right> ",
                    C = "<C-…> ",
                    M = "<M-…> ",
                    D = "<D-…> ",
                    S = "<S-…> ",
                    CR = "<CR> ",
                    Esc = "<Esc> ",
                    ScrollWheelDown = "<ScrollWheelDown> ",
                    ScrollWheelUp = "<ScrollWheelUp> ",
                    NL = "<NL> ",
                    BS = "<BS> ",
                    Space = "<Space> ",
                    Tab = "<Tab> ",
                    F1 = "<F1>",
                    F2 = "<F2>",
                    F3 = "<F3>",
                    F4 = "<F4>",
                    F5 = "<F5>",
                    F6 = "<F6>",
                    F7 = "<F7>",
                    F8 = "<F8>",
                    F9 = "<F9>",
                    F10 = "<F10>",
                    F11 = "<F11>",
                    F12 = "<F12>",
                },
            },

            -- Document existing key chains
            -- Groups should first be 'contexts' like git, then verb-motion
            --
            -- p       project             related to current project
            -- f       file                related to the file currently being edited (actually buffer)
            -- h       help                related to help pages
            -- q       quickfix            related to the quickfix list
            -- t/<tab> tab                 related to tabs
            -- g       git                 related to the current git repository
            -- o       obsidian            related to my obsidian setup
            spec = {
                { "g", group = "[G]oto", mode={"n"}},
                { "<leader>p", group = "[P]roject", mode = { "n", "x" } }, -- keybindings related to the entire project including navigation, replacement etc
                { "<leader>f", group = "[F]ile" }, -- keybindings related to the current file including navigation, replacement etc
                { "<leader>h", group = "[H]elp" }, -- keybindings related to different forms of help page
                { "<leader>c", group = "[C]ode" }, -- keybindings for creating or modifying code
                { "<leader>q", group = "[Q]uickfix" }, -- keybindings for interacting with the quickfix list
                { "<leader><tab>", group = "[T]abs" }, -- keybindings for interacting with tabs
                { "<leader>g", group = "[G]it", mode = { "n", "v" } }, -- keybindings for interacting with git, particularly the gitsigns plugin
                { "<leader>d", group = "[D]ebug", mode = { "n", "v" } }, -- keybindings for debugging functionality
                { "<leader>o", group = "[O]bsidian" }, -- keybindings for obsidian
                { "<leader>n", group = "[N]eovim" },
                { "<leader>s", group = "[S]earch" },
                { "<leader>z", group = "[Z]en" },
                { "[", group = "Navigate Next", mode = { "n", "v" } },
                { "]", group = "Navigate Previous", mode = { "n", "v" } },
            },
        },
    },
}
