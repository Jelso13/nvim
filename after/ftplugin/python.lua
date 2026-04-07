-- only run if conform is available:
if not pcall(require, "conform") then
    return
end

require("conform").formatters.black = {
    prepend_args = { "-l", "80" },
}

-- include telescope plugin for searching all possible python help pages
-- vim.keymap.set("n", "<leader>hl", builtin.keymaps, { desc = "[H]elp [L]anguage (python)" })
-- python -m pydoc
--
vim.keymap.set("n", "<leader>hl", function()
    require("telescope.builtin").help_tags({
        cwd = vim.fn.stdpath("data")
            .. "/site/pack/packer/start/telescope.nvim",
    })
end, { desc = "[H]elp [L]anguage (python)" })

-- ---------------------------------- Pyright -------------------------------------
-- Dynamically toggle Pyright's type checking strictness
vim.keymap.set("n", "<leader>tt", function()
    -- Get the active Pyright client for the current buffer
    local clients = vim.lsp.get_clients({ name = "pyright", bufnr = 0 })
    
    if #clients == 0 then
        vim.notify("Pyright is not active in this buffer.", vim.log.levels.WARN)
        return
    end

    local client = clients[1]
    local settings = client.config.settings

    -- Safely ensure the nested table structure exists
    settings.python = settings.python or {}
    settings.python.analysis = settings.python.analysis or {}

    -- Check current mode and toggle between 'basic' and 'strict'
    -- (You can change 'basic' to 'off' if you prefer zero hints when toggled off)
    local current_mode = settings.python.analysis.typeCheckingMode or "basic"
    local new_mode = current_mode == "strict" and "basic" or "strict"

    -- Update the internal Neovim config
    settings.python.analysis.typeCheckingMode = new_mode

    -- Hot-reload the setting: Notify Pyright of the change
    client.notify("workspace/didChangeConfiguration", { settings = settings })

    -- Show a nice notification in the editor
    vim.notify("Pyright Type Checking: " .. new_mode:upper(), vim.log.levels.INFO)
end, { desc = "[T]oggle [T]ype checking (Pyright)", buffer = true })

-- ---------------------------------- Folds ---------------------------------------
-- vim.opt_local.foldmethod = "indent"
-- vim.opt_local.foldnestmax=2
-- vim.opt_local.foldlevel = 2
-- vim.opt_local.foldenable = true
-- print("Loaded after/ftplugin/python.lua")

-- autocmd BufEnter *.py normal zM
-- but in lua

-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "v:lua.CustomFoldExpr()"
--
-- function _G.CustomFoldExpr()
--   local lnum = vim.v.lnum
--   local fold_level = vim.treesitter.foldexpr()
--
--   -- Detect function definitions
--   local line = vim.fn.getline(lnum)
--   if line:match("^%s*def ") or line:match("^%s*class ") then
--     return 1  -- Treat function/class as a top-level fold
--   end
--
--   return fold_level
-- end
---------------------------------- Folds ---------------------------------------
