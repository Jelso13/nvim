--[[
Router
Responsible for processing the instructions and passing to the engine for executing commands
--]]

-- custom/my_plugins/inkscape_figures/init.lua

return {
    "inkscape_figures",
    ft = { "tex", "markdown" }, -- Lazy strictly limits loading to these filetypes
    dir = vim.fn.stdpath("config") .. "/lua/custom/my_plugins/inkscape_figures",
    
    -- The config function ONLY runs when the plugin is loaded (i.e., in tex/md files)
    config = function()
        local core = require("custom.my_plugins.inkscape_figures.core")
        local group = vim.api.nvim_create_augroup("InkscapeFigures", { clear = true })

        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            pattern = { "tex", "markdown" },
            callback = function(ev)
                local bufnr = ev.buf

                -- 1. Buffer-local Commands
                vim.api.nvim_buf_create_user_command(bufnr, "InkCreate", function(opts)
                    -- Your existing command logic
                end, { nargs = "?", range = true, desc = "Create a new Inkscape figure" })

                vim.api.nvim_buf_create_user_command(bufnr, "InkEdit", function(opts)
                    -- Your existing command logic
                end, { nargs = "?", range = true, desc = "Edit an existing Inkscape figure" })

                vim.api.nvim_buf_create_user_command(bufnr, "InkConvert", function(opts)
                    -- Your existing command logic
                end, { nargs = "?", range = true, desc = "Convert SVG to PDF+LaTeX" })

                -------------------------------------------------------------------------------
                -- 2. Buffer-Local Keymaps & Path Routing
                -------------------------------------------------------------------------------
                local filepath = vim.api.nvim_buf_get_name(bufnr)
                local vault_path = vim.fn.expand("~/Vault")
                
                -- Ensure mappings only apply to THIS specific buffer
                local map_opts = { noremap = true, silent = true, buffer = bufnr }
                local ink_opts = nil

                -- If inside Obsidian Vault, inject the custom directory paths
                if string.sub(filepath, 1, string.len(vault_path)) == vault_path then
                    ink_opts = {
                        dir = vault_path .. "/Attachments/",
                        link_path = "Attachments/"
                    }
                end

                -- Apply the keymaps
                vim.keymap.set('i', '<C-f>', function()
                    core.handle_insert_mode(ink_opts)
                end, vim.tbl_extend("force", map_opts, { desc = "Handle Inkscape figure in Insert mode" }))

                vim.keymap.set('n', '<localleader>f', function()
                    core.handle_normal_mode(ink_opts)
                end, vim.tbl_extend("force", map_opts, { desc = "Handle Inkscape figure in Normal mode" }))

                vim.keymap.set('v', '<localleader>f', function()
                    core.handle_visual_mode(ink_opts)
                end, vim.tbl_extend("force", map_opts, { desc = "Create Inkscape figure from selection" }))

                vim.keymap.set('v', '<C-f>', function()
                    core.handle_visual_mode(ink_opts)
                end, vim.tbl_extend("force", map_opts, { desc = "Create Inkscape figure from selection" }))
            end
        })
    end
}


-- -- init.lua
-- local core = require("custom.my_plugins.inkscape_figures.core")
-- 
-- -- Commands
-- vim.api.nvim_create_user_command("InkCreate", function(opts)
--     -- Your existing command logic
-- end, { nargs = "?", range = true, desc = "Create a new Inkscape figure" })
-- 
-- vim.api.nvim_create_user_command("InkEdit", function(opts)
--     -- Your existing command logic
-- end, { nargs = "?", range = true, desc = "Edit an existing Inkscape figure" })
-- 
-- vim.api.nvim_create_user_command("InkConvert", function(opts)
--     -- Your existing command logic
-- end, { nargs = "?", range = true, desc = "Convert SVG to PDF+LaTeX" })
-- 
-- 
-- -------------------------------------------------------------------------------
-- -- Keymaps (Insert, Normal, Visual)
-- -------------------------------------------------------------------------------
-- 
-- -- Insert Mode: ctrl+f
-- vim.keymap.set('i', '<C-f>', function()
--     core.handle_insert_mode()
-- end, { noremap = true, silent = true, desc = "Handle Inkscape figure in Insert mode" })
-- 
-- -- Normal Mode: <localleader>f
-- vim.keymap.set('n', '<localleader>f', function()
--     core.handle_normal_mode()
-- end, { noremap = true, silent = true, desc = "Handle Inkscape figure in Normal mode" })
-- 
-- -- Visual Mode: <localleader>f or ctrl+f
-- vim.keymap.set('v', '<localleader>f', function()
--     core.handle_visual_mode()
-- end, { noremap = true, silent = true, desc = "Create Inkscape figure from selection" })
-- 
-- vim.keymap.set('v', '<C-f>', function()
--     core.handle_visual_mode()
-- end, { noremap = true, silent = true, desc = "Create Inkscape figure from selection" })
-- 
-- return {
--     "inkscape_figures",
--     lazy = false,
--     dir = vim.fn.stdpath("config") .. "/lua/custom/my_plugins/inkscape_figures",
--     config = function() end,
-- }



-- -- init.lua
-- local core = require("custom.my_plugins.inkscape_figures.core")
-- 
-- -- Helper: prompt user or use visual selection
-- local function get_selection_or_input(opts, prompt)
--   -- If called with a visual range, grab the lines/cols like before
--   if opts.range and vim.fn.mode() == 'v' then
--     -- get visual start/end
--     local s_pos = vim.fn.getpos("'<")
--     local e_pos = vim.fn.getpos("'>")
--     local lines = vim.fn.getline(s_pos[2], e_pos[2])
--     -- trim first/last to columns
--     if #lines == 1 then
--       lines[1] = string.sub(lines[1], s_pos[3], e_pos[3])
--     else
--       lines[1]     = string.sub(lines[1],      s_pos[3])
--       lines[#lines] = string.sub(lines[#lines], 1, e_pos[3])
--     end
--     return table.concat(lines, '\n')
--   end
--   -- Otherwise prompt
--   return vim.fn.input(prompt)
-- end
-- -------------------------------------------------------------------------------
-- -- :InkCreate [<dir>]
-- -------------------------------------------------------------------------------
-- -- Create the user command
-- vim.api.nvim_create_user_command("InkCreate", function(opts)
--   -- opts.fargs[1] will be the first argument if passed via :InkCreate arg
--   local title = opts.fargs[1]
--                or get_selection_or_input(opts, "Enter SVG file to edit: ")
--   if title == nil or title == "" then
--     vim.notify("Figure title cannot be empty", vim.log.levels.ERROR)
--     return
--   end
-- 
--   -- Call your core function
--   core.create_figure(title)
-- end, {
--   nargs = "?",     -- zero or one arg
--   range = true,    -- allow visual selection
--   desc  = "Create a new Inkscape figure (from selection or prompt)",
-- })
-- -------------------------------------------------------------------------------
-- -- :InkEdit [<svg_filepath>]
-- -------------------------------------------------------------------------------
-- vim.api.nvim_create_user_command("InkEdit", function(opts)
--     local target = get_selection_or_input(opts, "Enter SVG file to edit: ")
--     if target == "" then
--         vim.notify("No SVG path provided", vim.log.levels.ERROR)
--         return
--     end
--     core.edit_figure(target)
-- end, { nargs = "?", range = true, desc = "Edit an existing Inkscape figure" })
-- 
-- -------------------------------------------------------------------------------
-- -- :InkConvert <svg_filepath>
-- -------------------------------------------------------------------------------
-- vim.api.nvim_create_user_command("InkConvert", function(opts)
--     local target = get_selection_or_input(opts, "Enter SVG path to convert: ")
--     if target and target ~= "" then
--         core.convert_to_pdf_latex(target)
--     else
--         vim.notify("No SVG path provided", vim.log.levels.ERROR)
--     end
-- end, {
--     nargs = "?",
--     range = true,
--     desc = "Convert SVG to PDF+LaTeX (from selection or prompt)",
-- })
-- 
-- -------------------------------------------------------------------------------
-- -- Keymaps (normal + visual)
-- -------------------------------------------------------------------------------
-- -- New figure
-- -- vim.keymap.set(
-- --     { "n", "v" },
-- --     "<localleader>fn",
-- --     ":InkCreate<CR>",
-- --     { noremap = true, silent = true, desc = "[F]igure [N]ew" }
-- -- )
-- --
-- -- -- Convert figure
-- -- vim.keymap.set(
-- --     { "n", "v" },
-- --     "<localleader>fc",
-- --     ":InkConvert<CR>",
-- --     { noremap = true, silent = true, desc = "[F]igure [C]onvert" }
-- -- )
-- --
-- -- -- Edit figure
-- -- vim.keymap.set(
-- --     { "n", "v" },
-- --     "<localleader>fe",
-- --     ":InkEdit<CR>",
-- --     { noremap = true, silent = true, desc = "[F]igure [E]dit" }
-- -- )
-- -------------------------------------------------------------------------------
-- -- Keymaps (normal + visual)
-- -------------------------------------------------------------------------------
-- -- New figure
-- -- Normal mode: Prompt for input
-- vim.keymap.set('n', '<localleader>fn', function()
--   vim.cmd('InkCreate')
-- end, { noremap = true, silent = true, desc = '[F]igure [N]ew' })
-- 
-- -- Visual mode: Pass visual selection
-- vim.keymap.set('v', '<localleader>fn', function()
--   -- Execute the command with the visual range '<,'>
--   vim.cmd("InkCreate '<,'>")
-- end, { noremap = true, silent = true, desc = '[F]igure [N]ew' })
-- 
-- -- Convert figure
-- -- Normal mode: Prompt for input
-- vim.keymap.set('n', '<localleader>fc', function()
--   vim.cmd('InkConvert')
-- end, { noremap = true, silent = true, desc = '[F]igure [C]onvert' })
-- 
-- -- Visual mode: Pass visual selection
-- vim.keymap.set('v', '<localleader>fc', function()
--   vim.cmd("InkConvert <,'>'")
-- end, { noremap = true, silent = true, desc = '[F]igure [C]onvert' })
-- 
-- -- Edit figure
-- -- Normal mode: Prompt for input
-- vim.keymap.set('n', '<localleader>fe', function()
--   vim.cmd('InkEdit')
-- end, { noremap = true, silent = true, desc = '[F]igure [E]dit' })
-- 
-- -- Visual mode: Pass visual selection
-- vim.keymap.set('v', '<localleader>fe', function()
--   vim.cmd("InkEdit <,'>'")
-- end, { noremap = true, silent = true, desc = '[F]igure [E]dit' })
-- 
-- return {
--     "inkscape_figures",
--     lazy = false,
--     dir = vim.fn.stdpath("config") .. "/lua/custom/my_plugins/inkscape_figures",
--     config = function() end,
-- }
-- 
-- -- -- init.lua
-- -- local core = require("custom.my_plugins.inkscape_figures.core")
-- --
-- -- vim.api.nvim_create_user_command("InkCreate", function(opts)
-- --     local title = vim.fn.input("Enter figure title: ")
-- --     if title ~= "" then
-- --         core.create_figure(title, opts.fargs[1]) -- Allow optional root dir
-- --         -- core.convert_to_pdf_latex(opts.fargs[1])
-- --     end
-- -- end, { nargs = "?", desc = "Create a new Inkscape figure" })
-- --
-- -- vim.api.nvim_create_user_command("InkEdit", function(opts)
-- --     core.edit_figure(opts.fargs[1]) -- Allow optional root dir
-- -- end, { nargs = "?", desc = "Edit an existing Inkscape figure" })
-- --
-- -- vim.api.nvim_create_user_command("InkConvert", function(opts)
-- --     if #opts.fargs == 1 then
-- --         core.convert_to_pdf_latex(opts.fargs[1])
-- --     else
-- --         -- instead find all the svg files in the config.figure_dir and list them in telescope
-- --         local title = vim.fn.input("Enter figure title: ")
-- --         local figure_dir = core.get_config().figure_dir
-- --         vim.notify("Usage: :InkConvert <svg_filepath>", vim.log.levels.ERROR)
-- --     end
-- -- end, { nargs = 1, desc = "Convert SVG to PDF+LaTeX" })
-- --
-- -- return {
-- --     "inkscape_figures", -- Or any name you like for your plugin
-- --     lazy = false, -- Load immediately (for testing)
-- --     dir = "~/.config/nvim/lua/custom/my_plugins/inkscape_figures", -- Explicitly tell lazy the directory
-- --     -- or
-- --     --  dir = vim.fn.stdpath("config") .. "/lua/inkscape_figures", -- More portable
-- --     -- version = "*",
-- --     --  version = false,
-- --     --  build = function()
-- --     --    vim.cmd("!echo 'Building plugin'")
-- --     --  end,
-- --     config = function()
-- --         --  No special config needed, commands are defined in init.lua
-- --         --  set keybinding to call :InkCreate with <localleader>fc
-- --         vim.keymap.set("n", "<localleader>fn", ":InkCreate<CR>", { noremap = true, silent = true , desc="[F]igure [N]ew"})
-- --         vim.keymap.set("n", "<localleader>fc", ":InkConvert<CR>", { noremap = true, silent = true, desc="[F]igure [C]onvert" })
-- --         vim.keymap.set("n", "<localleader>fe", ":InkEdit<CR>", { noremap = true, silent = true, desc="[F]igure [E]dit" })
-- --     end,
-- --     --  dependencies = {}  -- If you had any
-- -- }
