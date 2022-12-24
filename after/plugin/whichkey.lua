-- ########################
-- eventually change so that this is optionally integrated with a
-- function for handling bindings


local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    return
end

local setup = {
    plugins = {
        -- shows a list of your marks on ' and `
        marks = true,
        -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        registers = true,
        spelling = {
            -- enabling this will show WhichKey when pressing z= to select
            -- spelling suggestions
            enabled = true,
            -- how many suggestions should be shown in the list?
            suggestions = 20,
        },
        -- the presets plugin, adds help for a bunch of default keybindings
        -- in Neovim
        -- No actual key bindings are created
        presets = {
            -- adds help for operators like d, y, ... and registers them for
            -- motion / text object completion
            operators = false,
            -- adds help for motions
            motions = false,
            -- help for text objects triggered after entering an operator
            text_objects = false,
            -- default bindings on <c-w>
            windows = false,
            -- misc bindings to work with windows
            nav = false,
            -- bindings for folds, spelling and others prefixed with z
            z = true,
            -- bindings for prefixed with g
            g = true,
        },
    },
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above
    -- operators = { gc = "Comments" },
    key_labels = {
        -- override the label used to display some keys.
        -- It doesn't effect WK in any other way.
        -- For example:
        -- ["<space>"] = "SPC",
        -- ["<cr>"] = "RET",
        -- ["<tab>"] = "TAB",
    },
    icons = {
        -- symbol used in the command line area that shows your active key combo
        breadcrumb = "»",
        -- symbol used between a key and it's label
        separator = "➜",
        -- symbol prepended to a group
        group = "+",
    },
    popup_mappings = {
        -- binding to scroll down inside the popup
        scroll_down = "<c-d>",
        -- binding to scroll up inside the popup
        scroll_up = "<c-u>",
    },
    -- settings for how the window looks on popup
    window = {
        -- none, single, double, shadow
        border = "rounded",
        -- bottom, top
        position = "bottom",
        -- extra window margin [top, right, bottom, left]
        margin = { 1, 0, 1, 0 },
        -- extra window padding [top, right, bottom, left]
        padding = { 2, 2, 2, 2 },
        winblend = 0,
    },
    layout = {
        -- min and max height of the columns
        height = { min = 4, max = 25 },
        -- min and max width of the columns
        width = { min = 20, max = 50 },
        -- spacing between columns
        spacing = 3,
        -- align columns left, center or right
        align = "left",
    },
    -- enable this to hide mappings for which you didn't specify a label
    ignore_missing = false,
    -- hide mapping boilerplate
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
    -- show help message on the command line when the popup is visible
    show_help = true,
    -- automatically setup triggers
    triggers = "auto",
    -- triggers = {"<leader>"} -- or specify a list manually
    triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for key maps that start with a native binding
        -- most people should not need to change this
        i = { "j", "k" },
        v = { "j", "k" },
    },
}

local opts = {
    mode = "n", -- NORMAL mode
    -- prefix = "<leader>",
    prefix = "",
    -- Global mappings. Specify a buffer number for buffer local mappings
    buffer = nil,
    -- use `silent` when creating keymaps
    silent = true,
    -- use `noremap` when creating keymaps
    noremap = true,
    -- use `nowait` when creating keymaps
    nowait = true,
}


-- vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
--
-- -- navigation in harpoon
-- vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
-- vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end)
-- vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end)
-- vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end)

-- need to include ctrl and bindings for diffirente modes

local mappings = {
    -- ["<leader>a"] = { "Add Harpoon File" },
    -- ["<leader>d"] = { "Delete to Abyss" },
    -- ["<C-e>"] = { "Harpoon Menu" },
    -- ["<C-h>"] = { "Harpoon File 1" },
    -- ["<C-t>"] = { "Harpoon File 2" },
    -- ["<C-n>"] = { "Harpoon File 3" },
    -- ["<C-s>"] = { "Harpoon File 4" },
    -- ["<C-f>"] = { "Open file in new tmux session" },
    -- ["<C-p>"] = { "Search in git repo" },
    -- ["<leader>p"] = {
    --     name = "project",
    --     f = { "project file search" },
    --     s = { "project search" },
    --     v = { "project view" },
    -- },
    -- ["<leader>f"] = { "Format the current file" },
    -- ["<leader>s"] = { "Sub word" },
    -- ["<leader>u"] = { "Undo tree" },
    -- ["<leader>y"] = { "yank global" },
    -- ["<leader>x"] = { "set executable" },
    -- ["<leader>g"] = {
    --     name = "git",
    --     s = { "git status" },
    -- },
    -- g = {
    --     f = { "Go to File" },
    -- },
    -- K = { "get info (change this one)" },


}

which_key.setup(setup)
-- which_key.register(mappings, opts)


-- adding stuff for different modes

local xopts = {
    mode = "x", -- block select mode
    -- prefix = "<leader>",
    prefix = "",
    -- Global mappings. Specify a buffer number for buffer local mappings
    buffer = nil,
    -- use `silent` when creating keymaps
    silent = true,
    -- use `noremap` when creating keymaps
    noremap = true,
    -- use `nowait` when creating keymaps
    nowait = true,
}

local xmappings = {
    -- ["<leader>y"] = { "Yank to global register" }
}

-- which_key.register(xmappings, xopts)
