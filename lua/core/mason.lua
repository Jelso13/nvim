return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                -- This is the magic list!
                -- Mason will automatically install these if they are missing.
                ensure_installed = {
                    "ty",
                    "ruff",
                    "lua_ls",
                    "bashls",
                    "clangd",
                    "cssls",
                    "eslint",
                    "html",
                    "jsonls",
                    "ts_ls",
                    "tailwindcss",
                    "texlab",
                },

                -- Installing a server must not enable it. mason-lspconfig runs at
                -- startup, while nvim-lspconfig is lazy-loaded on BufReadPre, so
                -- auto-enabling here would start servers before lua/lsp/init.lua
                -- registers their settings -- nvim caches the resolved config, and
                -- the per-server settings (e.g. ty's) are silently dropped.
                -- lua/lsp/init.lua is the single place servers get enabled.
                automatic_enable = false,
            })
        end
    },
}
