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
