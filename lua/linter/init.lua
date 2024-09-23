local mypy_args = {
    -- "--strict",                        -- Enable strict type checking
    "--extra-checks",                   -- not quite as strict as strict
    "--disallow-untyped-defs",        -- Disallow function definitions without type annotations
    "--disallow-untyped-calls",       -- Disallow calls to untyped functions
    -- "--check-untyped-defs",           -- Check bodies of untyped functions
    "--warn-return-any",               -- Warn on functions returning Any
    "--ignore-missing-imports",        -- Ignore missing type hints in third-party libraries
    "--disallow-incomplete-defs",      -- Require complete type signatures for functions
    -- "--follow-imports=silent",         -- Follow imports when checking types
    -- "--show-column-numbers",           -- Show column numbers in error messages
}

return {
    "nvimtools/none-ls.nvim",
    dependencies = { "mason.nvim", "nvim-lua/plenary.nvim" },
    config = function()
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                -- Python diagnostics
                -- null_ls.builtins.diagnostics.pylint,
                null_ls.builtins.diagnostics.mypy.with({
                    extra_args = mypy_args,
                }),
            },
        })
    end,
}



-- return {
--   "mfussenegger/nvim-lint",
--   event = {
--     "BufReadPre",
--     "BufNewFile",
--   },
--   config = function()
--     local lint = require("lint")
-- 
--     lint.linters_by_ft = {
--       -- python
--       python = { "pylint", "ruff", "mypy" },
--       -- js
--       javascript = { "eslint_d" },
--       typescript = { "eslint_d" },
--       javascriptreact = { "eslint_d" },
--       typescriptreact = { "eslint_d" },
--     }
-- 
--     local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
-- 
--     vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
--       group = lint_augroup,
--       callback = function()
--         lint.try_lint()
--       end,
--     })
-- 
--     -- vim.keymap.set("n", "<leader>l", function()
--     --   lint.try_lint()
--     -- end, { desc = "Trigger linting for current file" })
--   end,
-- }
