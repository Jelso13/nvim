-- init.lua
local core = require("custom.my_plugins.inkscape_figures.core")

vim.api.nvim_create_user_command("InkCreate", function(opts)
    local title = vim.fn.input("Enter figure title: ")
    if title ~= "" then
        core.create_figure(title, opts.fargs[1]) -- Allow optional root dir
        -- core.convert_to_pdf_latex(opts.fargs[1])
    end
end, { nargs = "?", desc = "Create a new Inkscape figure" })

vim.api.nvim_create_user_command("InkEdit", function(opts)
    core.edit_figure(opts.fargs[1]) -- Allow optional root dir
end, { nargs = "?", desc = "Edit an existing Inkscape figure" })

vim.api.nvim_create_user_command("InkConvert", function(opts)
    if #opts.fargs == 1 then
        core.convert_to_pdf_latex(opts.fargs[1])
    else
        vim.notify("Usage: :InkConvert <svg_filepath>", vim.log.levels.ERROR)
    end
end, { nargs = 1, desc = "Convert SVG to PDF+LaTeX" })

return {
    "inkscape_figures", -- Or any name you like for your plugin
    lazy = false, -- Load immediately (for testing)
    dir = "~/.config/nvim/lua/custom/my_plugins/inkscape_figures", -- Explicitly tell lazy the directory
    -- or
    --  dir = vim.fn.stdpath("config") .. "/lua/inkscape_figures", -- More portable
    -- version = "*",
    --  version = false,
    --  build = function()
    --    vim.cmd("!echo 'Building plugin'")
    --  end,
    config = function()
        --  No special config needed, commands are defined in init.lua
    end,
    --  dependencies = {}  -- If you had any
}
