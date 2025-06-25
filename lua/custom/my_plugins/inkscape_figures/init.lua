-- init.lua
local core = require("custom.my_plugins.inkscape_figures.core")

-- Helper: prompt user or use visual selection
local function get_selection_or_input(opts, prompt)
  -- If called with a visual range, grab the lines/cols like before
  if opts.range and vim.fn.mode() == 'v' then
    -- get visual start/end
    local s_pos = vim.fn.getpos("'<")
    local e_pos = vim.fn.getpos("'>")
    local lines = vim.fn.getline(s_pos[2], e_pos[2])
    -- trim first/last to columns
    if #lines == 1 then
      lines[1] = string.sub(lines[1], s_pos[3], e_pos[3])
    else
      lines[1]     = string.sub(lines[1],      s_pos[3])
      lines[#lines] = string.sub(lines[#lines], 1, e_pos[3])
    end
    return table.concat(lines, '\n')
  end
  -- Otherwise prompt
  return vim.fn.input(prompt)
end
-------------------------------------------------------------------------------
-- :InkCreate [<dir>]
-------------------------------------------------------------------------------
-- Create the user command
vim.api.nvim_create_user_command("InkCreate", function(opts)
  -- opts.fargs[1] will be the first argument if passed via :InkCreate arg
  local title = opts.fargs[1]
               or get_selection_or_input(opts, "Enter SVG file to edit: ")
  if title == nil or title == "" then
    vim.notify("Figure title cannot be empty", vim.log.levels.ERROR)
    return
  end

  -- Call your core function
  core.create_figure(title)
end, {
  nargs = "?",     -- zero or one arg
  range = true,    -- allow visual selection
  desc  = "Create a new Inkscape figure (from selection or prompt)",
})
-------------------------------------------------------------------------------
-- :InkEdit [<svg_filepath>]
-------------------------------------------------------------------------------
vim.api.nvim_create_user_command("InkEdit", function(opts)
    local target = get_selection_or_input(opts, "Enter SVG file to edit: ")
    if target == "" then
        vim.notify("No SVG path provided", vim.log.levels.ERROR)
        return
    end
    core.edit_figure(target)
end, { nargs = "?", range = true, desc = "Edit an existing Inkscape figure" })

-------------------------------------------------------------------------------
-- :InkConvert <svg_filepath>
-------------------------------------------------------------------------------
vim.api.nvim_create_user_command("InkConvert", function(opts)
    local target = get_selection_or_input(opts, "Enter SVG path to convert: ")
    if target and target ~= "" then
        core.convert_to_pdf_latex(target)
    else
        vim.notify("No SVG path provided", vim.log.levels.ERROR)
    end
end, {
    nargs = "?",
    range = true,
    desc = "Convert SVG to PDF+LaTeX (from selection or prompt)",
})

-------------------------------------------------------------------------------
-- Keymaps (normal + visual)
-------------------------------------------------------------------------------
-- New figure
-- vim.keymap.set(
--     { "n", "v" },
--     "<localleader>fn",
--     ":InkCreate<CR>",
--     { noremap = true, silent = true, desc = "[F]igure [N]ew" }
-- )
--
-- -- Convert figure
-- vim.keymap.set(
--     { "n", "v" },
--     "<localleader>fc",
--     ":InkConvert<CR>",
--     { noremap = true, silent = true, desc = "[F]igure [C]onvert" }
-- )
--
-- -- Edit figure
-- vim.keymap.set(
--     { "n", "v" },
--     "<localleader>fe",
--     ":InkEdit<CR>",
--     { noremap = true, silent = true, desc = "[F]igure [E]dit" }
-- )
-------------------------------------------------------------------------------
-- Keymaps (normal + visual)
-------------------------------------------------------------------------------
-- New figure
-- Normal mode: Prompt for input
vim.keymap.set('n', '<localleader>fn', function()
  vim.cmd('InkCreate')
end, { noremap = true, silent = true, desc = '[F]igure [N]ew' })

-- Visual mode: Pass visual selection
vim.keymap.set('v', '<localleader>fn', function()
  -- Execute the command with the visual range '<,'>
  vim.cmd("InkCreate <,'>'")
end, { noremap = true, silent = true, desc = '[F]igure [N]ew' })

-- Convert figure
-- Normal mode: Prompt for input
vim.keymap.set('n', '<localleader>fc', function()
  vim.cmd('InkConvert')
end, { noremap = true, silent = true, desc = '[F]igure [C]onvert' })

-- Visual mode: Pass visual selection
vim.keymap.set('v', '<localleader>fc', function()
  vim.cmd("InkConvert <,'>'")
end, { noremap = true, silent = true, desc = '[F]igure [C]onvert' })

-- Edit figure
-- Normal mode: Prompt for input
vim.keymap.set('n', '<localleader>fe', function()
  vim.cmd('InkEdit')
end, { noremap = true, silent = true, desc = '[F]igure [E]dit' })

-- Visual mode: Pass visual selection
vim.keymap.set('v', '<localleader>fe', function()
  vim.cmd("InkEdit <,'>'")
end, { noremap = true, silent = true, desc = '[F]igure [E]dit' })

return {
    "inkscape_figures",
    lazy = false,
    dir = vim.fn.stdpath("config") .. "/lua/custom/my_plugins/inkscape_figures",
    config = function() end,
}

-- -- init.lua
-- local core = require("custom.my_plugins.inkscape_figures.core")
--
-- vim.api.nvim_create_user_command("InkCreate", function(opts)
--     local title = vim.fn.input("Enter figure title: ")
--     if title ~= "" then
--         core.create_figure(title, opts.fargs[1]) -- Allow optional root dir
--         -- core.convert_to_pdf_latex(opts.fargs[1])
--     end
-- end, { nargs = "?", desc = "Create a new Inkscape figure" })
--
-- vim.api.nvim_create_user_command("InkEdit", function(opts)
--     core.edit_figure(opts.fargs[1]) -- Allow optional root dir
-- end, { nargs = "?", desc = "Edit an existing Inkscape figure" })
--
-- vim.api.nvim_create_user_command("InkConvert", function(opts)
--     if #opts.fargs == 1 then
--         core.convert_to_pdf_latex(opts.fargs[1])
--     else
--         -- instead find all the svg files in the config.figure_dir and list them in telescope
--         local title = vim.fn.input("Enter figure title: ")
--         local figure_dir = core.get_config().figure_dir
--         vim.notify("Usage: :InkConvert <svg_filepath>", vim.log.levels.ERROR)
--     end
-- end, { nargs = 1, desc = "Convert SVG to PDF+LaTeX" })
--
-- return {
--     "inkscape_figures", -- Or any name you like for your plugin
--     lazy = false, -- Load immediately (for testing)
--     dir = "~/.config/nvim/lua/custom/my_plugins/inkscape_figures", -- Explicitly tell lazy the directory
--     -- or
--     --  dir = vim.fn.stdpath("config") .. "/lua/inkscape_figures", -- More portable
--     -- version = "*",
--     --  version = false,
--     --  build = function()
--     --    vim.cmd("!echo 'Building plugin'")
--     --  end,
--     config = function()
--         --  No special config needed, commands are defined in init.lua
--         --  set keybinding to call :InkCreate with <localleader>fc
--         vim.keymap.set("n", "<localleader>fn", ":InkCreate<CR>", { noremap = true, silent = true , desc="[F]igure [N]ew"})
--         vim.keymap.set("n", "<localleader>fc", ":InkConvert<CR>", { noremap = true, silent = true, desc="[F]igure [C]onvert" })
--         vim.keymap.set("n", "<localleader>fe", ":InkEdit<CR>", { noremap = true, silent = true, desc="[F]igure [E]dit" })
--     end,
--     --  dependencies = {}  -- If you had any
-- }
