local mypy_args = {
    -- "--strict",                        -- Enable strict type checking
    "--extra-checks",                   -- not quite as strict as strict
    "--disallow-untyped-calls",       -- Disallow calls to untyped functions
    "--allow-untyped-defs",          -- Disallow defining functions without type annotations or with incomplete type annotations (inverse: --allow-untyped-defs) 
    -- "--disallow-untyped-defs",          -- Disallow defining functions without type annotations or with incomplete type annotations (inverse: --allow-untyped-defs) 
    -- "--check-untyped-defs",             -- Type check the interior of functions without type annotations (inverse: --no-check-untyped-defs)
    "--no-check-untyped-defs",             -- Type check the interior of functions without type annotations (inverse: --no-check-untyped-defs)
    -- "--warn-return-any",              --         Warn about returning values of type Any from non- Any typed functions
    "--ignore-missing-imports",        -- Ignore missing type hints in third-party libraries
    "--disallow-incomplete-defs",      -- Require complete type signatures for functions
    -- "--follow-imports=silent",         -- Follow imports when checking types
    -- "--show-column-numbers",           -- Show column numbers in error messages
    "--warn-unreachable",                -- Warn about statements or expressions inferred to be unreachable (inverse: --no-warn-unreachable)
    "--allow-redefinition",              -- Allow unconditional variable redefinition with a new type (inverse: --disallow-redefinition)
    "--warn-unused-ignores",             -- Warn about @suppress annotations that suppress errors or warnings that are not present
    "--error-summary",                   -- Print a global error summary after checking all files
    "--show-error-codes",                -- Include error codes in error messages
    "--soft-error-limit=0",             -- Number of errors to emit before stopping (default: 0)
    
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
