return {
    "mason-org/mason.nvim",
    -- dependencies = {
    --     "williamboman/mason-lspconfig.nvim",  -- For integrating LSP servers
    --     "WhoIsSethDaniel/mason-tool-installer.nvim",  -- For managing external tools like formatters and linters
    -- },
    opts = {
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
        }
    },
    -- config = function()
    --     require("mason").setup()  -- Initialize Mason

    --     -- require("mason-lspconfig").setup({
    --     --     automatic_installation = true,  -- Automatically install LSP servers as needed
    --     --     ensure_installed = {
    --     --         -- LSP servers to be installed for various languages
    --     --         "pyright",                      -- Python Language Server
    --     --         "lua_ls",                       -- Lua Language Server
    --     --         "rust_analyzer",                -- Rust Language Server -- install manually works better with cargo tools and rustaceanvim
    --     --         "bashls",                       -- Bash Language Server
    --     --         -- "dcm",                       -- Dart Language Server
    --     --         "texlab",                       -- LaTeX Language Server
    --     --         "clangd",                       -- C/C++ Language Server
    --     --         "cssls",                        -- CSS Language Server
    --     --         "eslint",                       -- ESLint for JavaScript/TypeScript
    --     --         "html",                         -- HTML Language Server
    --     --         "jsonls",                       -- JSON Language Server
    --     --         "ts_ls",   -- TypeScript Language Server
    --     --         "tailwindcss",                  -- Tailwind CSS Language Server
    --     --     },
    --     -- })

    --     require("mason-tool-installer").setup({
    --         ensure_installed = {
    --             -- External tools to be installed for formatting and linting
    --             "prettier",     -- Code formatter for JavaScript, HTML, CSS

    --             -- lua
    --             "stylua",       -- Lua formatter
    --             "luacheck",     -- lua linter

    --             -- PYTHON
    --             "black",        -- Python code formatter
    --             "pylint",       -- Python linter
    --             "mypy",        -- Python type checker
    --             "ruff",        -- Python formatter
    --             "debugpy",     -- Python debugger


    --             "eslint_d",     -- ESLint daemon for faster linting
    --             "clang-format", -- C/C++ formatter
    --         },
    --     })
    -- end,
}
