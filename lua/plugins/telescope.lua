-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

return {
    { -- Fuzzy Finder (files, lsp, etc)
        "nvim-telescope/telescope.nvim",
        event = "VimEnter",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { -- If encountering errors, see telescope-fzf-native README for installation instructions
                "nvim-telescope/telescope-fzf-native.nvim",

                -- `build` is used to run some command when the plugin is installed/updated.
                -- This is only run then, not every time Neovim starts up.
                build = "make",

                -- `cond` is a condition used to determine whether this plugin should be
                -- installed and loaded.
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
            { "nvim-telescope/telescope-ui-select.nvim" },

            -- Useful for getting pretty icons, but requires a Nerd Font.
            { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
        },
        config = function()
            -- Telescope is a fuzzy finder that comes with a lot of different things that
            -- it can fuzzy find! It's more than just a "file finder", it can search
            -- many different aspects of Neovim, your workspace, LSP, and more!
            --
            -- The easiest way to use Telescope, is to start by doing something like:
            --  :Telescope help_tags
            --
            -- After running this command, a window will open up and you're able to
            -- type in the prompt window. You'll see a list of `help_tags` options and
            -- a corresponding preview of the help.
            --
            -- Two important keymaps to use while in Telescope are:
            --  - Insert mode: <c-/>
            --  - Normal mode: ?
            --
            -- This opens a window that shows you all of the keymaps for the current
            -- Telescope picker. This is really useful to discover what Telescope can
            -- do as well as how to actually do it!

            -- [[ Configure Telescope ]]
            -- See `:help telescope` and `:help telescope.setup()`
            local actions = require('telescope.actions')

            require("telescope").setup({
                -- You can put your default mappings / updates / etc. in here
                --  All the info you're looking for is in `:help telescope.setup()`
                --
                defaults = {
                  mappings = {
                    i = {
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                    }
                  },
                },
                -- pickers = {}
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown(),
                    },
                },
            })

            -- Enable Telescope extensions if they are installed
            pcall(require("telescope").load_extension, "fzf")
            pcall(require("telescope").load_extension, "ui-select")

            -- See `:help telescope.builtin`
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>hn", builtin.help_tags, { desc = "[H]elp search [N]eovim tags" })
            vim.keymap.set("n", "<leader>hk", builtin.keymaps, { desc = "[H]elp [K]eymaps" })
            vim.keymap.set("n", "<leader>sp", builtin.find_files, { desc = "[S]earch [P]roject files" })
            vim.keymap.set("n", "<leader>ss", builtin.symbols, { desc = "[S]earch [S]ymbols" })
            -- this is different because it searches for the word under the cursor
            vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch [W]ord under cursor" })
            vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch [G]rep in project" })
            vim.keymap.set("n", "<leader>pd", builtin.diagnostics, { desc = "[P]roject search [D]iagnostics" })
            vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
            vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "[S]earch [B]uffers" })
            
            -- vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [f]iles" })
            vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [f]iles" })
            -- Define a function to search files, including hidden ones
            local function search_hidden() builtin.find_files({ hidden = true }) end
            vim.keymap.set("n", "<leader>sh", search_hidden, { desc = "[S]earch [H]idden files"})
            -- I prefer <leader>sf for search files rather than search current file or buffer
            -- -- Slightly advanced example of overriding default behavior and theme
            -- vim.keymap.set("n", "<leader>sf", function()
            --     -- You can pass additional configuration to Telescope to change the theme, layout, etc.
            --     builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
            --         winblend = 10,
            --         previewer = false,
            --     }))
            -- end, { desc = "[S]earch current [File] fuzzy" })

            -- Shortcut for searching your Neovim configuration files
            vim.keymap.set("n", "<leader>nf", function()
                builtin.find_files({ cwd = vim.fn.stdpath("config") })
            end, { desc = "[N]eovim [F]iles" })

            -- git keybindings
            -- Global keybinding for running your custom Telescope picker
            -- pcall(require("telescope").load_extension, "git_worktree")
            local worktrees = require("telescope").load_extension("git_worktrees")
            vim.keymap.set("n", "<leader>gw", worktrees.git_worktree, {desc="[G]it [W]orktree change"})

            -- help
            vim.keymap.set("n", "<leader>hm", require("telescope.builtin").man_pages, { desc = "[H]elp [M]anpages"})

        end,
    },
}
