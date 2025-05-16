-- at the moment only contains keymaps for gilles castels work:

--return {
--    dir = ".",
--    ft = "tex",
--    config = function()
--        -- Insert mode mapping for creating figures
--        -- vim.api.nvim_set_keymap(
--        --     "i",
--        --     "<C-f>",
--        --     "<Esc>:lua vim.cmd('.!inkscape-figures create \"'..vim.fn.getline(\".\")..'\" \"'..vim.b.vimtex.root..'/figures/\"')<CR><CR>:w<CR>",
--        --     { noremap = true, silent = true }
--        -- )
--
--        -- -- Normal mode mapping for editing figures
--        -- vim.api.nvim_set_keymap(
--        --     "n",
--        --     "<localleader>fe",
--        --     ":lua vim.cmd('!inkscape-figures edit \"'..vim.b.vimtex.root..'/figures/\" > /dev/null 2>&1 &')<CR><CR>:redraw!<CR>",
--        --     { noremap = true, silent = true, desc = "[F]igure [E]dit" }
--        -- )
--
--        -- Create a figure via inkscape-figures, then save the buffer
--        vim.keymap.set(
--            "i",
--            "<C-f>",
--            -- "<localleader>fe",
--            function()
--                -- 1) Get the current line (figure name)
--                local name = vim.api.nvim_get_current_line() -- :contentReference[oaicite:3]{index=3}
--                -- 2) Get the project root from VimTeX
--                local root = vim.b.vimtex.root -- :contentReference[oaicite:4]{index=4}
--                -- 3) Run the external command silently
--                vim.cmd(
--                    string.format(
--                        "silent !inkscape-figures create \"%s\" \"%s/figures/\"",
--                        name,
--                        root
--                    )
--                )
--                -- 4) Save the buffer
--                vim.cmd("write")
--            end,
--            { noremap = true, silent = true, desc = "Inkscape: create figure" }
--        ) -- :contentReference[oaicite:5]{index=5}
--    end,
--}

local cfg = require("custom.my_plugins.inkscape_figures.config")
local cmds = require("custom.my_plugins.inkscape_figures.commands")

return {
    dir = ".",
    ft = "tex",
    config = function()
        -- load our module
        cmds.setup_commands()
        --     -- load our module
        --     -- local figs = require("./inkscape_figures")
        --     -- local figs = require('custom.my_plugins.inkscape_latex_figures')
        --     -- local create_figure = require("inkscape_latex_figures.create_figure")
        --     local create_figure = require("custom.my_plugins.inkscape_latex_figures.inkscape-figures").create_figure
        --     local edit_figures = require("custom.my_plugins.inkscape_latex_figures.inkscape-figures").edit_figures
        --     local compile_figure = require("custom.my_plugins.inkscape_latex_figures.inkscape-figures").compile_figure
        --
        --     -- local Git = require('custom.my_plugins.telescope_git_worktrees.git')
        --
        --     -- insert-mode: <C-f> → create figure
        --     vim.keymap.set(
        --       "i",
        --       "<C-f>",
        --       create_figure,
        --       { noremap = true, silent = true, desc = "Inkscape: create figure" }
        --     )
        --
        --     -- normal-mode: <localleader>fe → edit figures
        --     vim.keymap.set(
        --       "n",
        --       "<localleader>fe",
        --       edit_figures,
        --       { noremap = true, silent = true, desc = "[F]igure [E]dit" }
        --     )
    end,
}

-- return {
--   dir = ".",
--   ft = "tex",
--   config = function()
--     -- load our module
--     -- local figs = require("./inkscape_figures")
--     -- local figs = require('custom.my_plugins.inkscape_latex_figures')
--     -- local create_figure = require("inkscape_latex_figures.create_figure")
--     local create_figure = require("custom.my_plugins.inkscape_latex_figures.inkscape-figures").create_figure
--     local edit_figures = require("custom.my_plugins.inkscape_latex_figures.inkscape-figures").edit_figures
--     local compile_figure = require("custom.my_plugins.inkscape_latex_figures.inkscape-figures").compile_figure
--
--     -- local Git = require('custom.my_plugins.telescope_git_worktrees.git')
--
--     -- insert-mode: <C-f> → create figure
--     vim.keymap.set(
--       "i",
--       "<C-f>",
--       create_figure,
--       { noremap = true, silent = true, desc = "Inkscape: create figure" }
--     )
--
--     -- normal-mode: <localleader>fe → edit figures
--     vim.keymap.set(
--       "n",
--       "<localleader>fe",
--       edit_figures,
--       { noremap = true, silent = true, desc = "[F]igure [E]dit" }
--     )
--   end,
-- }
