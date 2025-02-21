--[[
plugin that mainly deals with signcolumn git information
possibly more useful as git diff tool
--]]

-- Here is a more advanced example where we pass configuration
-- options to `gitsigns.nvim`. This is equivalent to the following Lua:
--    require('gitsigns').setup({ ... })
--
-- See `:help gitsigns` to understand what the configuration keys do
return {
    { -- Adds git related signs to the gutter, as well as utilities for managing changes
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = { text = "┃" },
                change = { text = "┃" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
                untracked = { text = "┆" },
            },
            signs_staged = {
                add = { text = "┃" },
                change = { text = "┃" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
                untracked = { text = "┆" },
            },
            signs_staged_enable = true,
            signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
            numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
            linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
            word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
            watch_gitdir = {
                follow_files = true,
            },
            on_attach = function(bufnr)
                local gitsigns = require("gitsigns")

                -- Navigation
                vim.keymap.set("n", "]g", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        gitsigns.nav_hunk("next")
                    end
                end, {
                    buffer = bufnr,
                    desc = "] Navigate [G]it next change",
                })

                vim.keymap.set("n", "[g", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        gitsigns.nav_hunk("prev")
                    end
                end, {
                    buffer = bufnr,
                    desc = "[ Navigate [G]it prev change",
                })

                -- Actions
                -- normal mode
                vim.keymap.set(
                    { "n", "v" },
                    "<leader>gs",
                    gitsigns.stage_hunk,
                    { buffer = bufnr, desc = "[G]it [s]tage hunk" }
                )
                vim.keymap.set(
                    { "n", "v" },
                    "<leader>gr",
                    gitsigns.reset_hunk,
                    { buffer = bufnr, desc = "[G]it [r]eset hunk" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>gS",
                    gitsigns.stage_buffer,
                    { buffer = bufnr, desc = "[G]it [S]tage buffer" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>gu",
                    gitsigns.undo_stage_hunk,
                    { buffer = bufnr, desc = "[G]it [u]ndo stage hunk" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>gR",
                    gitsigns.reset_buffer,
                    { buffer = bufnr, desc = "[G]it [R]eset buffer" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>gp",
                    gitsigns.preview_hunk,
                    { buffer = bufnr, desc = "[G]it [p]review hunk" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>gb",
                    gitsigns.blame_line,
                    { buffer = bufnr, desc = "[G]it [b]lame line" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>gd",
                    gitsigns.diffthis,
                    { buffer = bufnr, desc = "[G]it [d]iff against index" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>gD",
                    function()
                        gitsigns.diffthis("@")
                    end,
                    { buffer = bufnr, desc = "[G]it [D]iff against last commit" }
                )
                -- Toggles
                vim.keymap.set(
                    "n",
                    "<leader>tb",
                    gitsigns.toggle_current_line_blame,
                    { buffer = bufnr, desc = "[T]oggle git show [b]lame line" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>tD",
                    gitsigns.toggle_deleted,
                    { buffer = bufnr, desc = "[T]oggle git show [D]eleted" }
                )
                --
                -- --
                -- map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
                -- map('n', '<leader>td', gitsigns.toggle_deleted)
                -- map('n', '<leader>tw', gitsigns.toggle_word_diff)
                vim.keymap.set(
                    "n",
                    "<leader>gtw",
                    gitsigns.toggle_word_diff,
                    {desc = "[G]it [T]oggle [w]ord diff" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>gtd",
                    gitsigns.toggle_deleted,
                    { buffer = bufnr, desc = "[G]it [T]oggle [d]eleted" }
                )
            end,
        },
    },
}
