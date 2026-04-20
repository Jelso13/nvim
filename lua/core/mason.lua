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
                    "pyright",
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
                },
                -- Automatically install LSPs if you add them to lspconfig later
                automatic_installation = true,
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = { 
            "williamboman/mason-lspconfig.nvim",
            {
              "folke/lazydev.nvim",
              ft = "lua",
              opts = {
                library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } },
              },
            },
        },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            -- 1. Apply Blink Capabilities Globally (Neovim 0.11+)
            vim.lsp.config('*', {
                capabilities = require("blink.cmp").get_lsp_capabilities()
            })

            -- 2. Custom Server Configs
            vim.lsp.config('lua_ls', require("lsp.servers.lua_ls"))
            vim.lsp.config('pyright', require("lsp.servers.pyright"))
            vim.lsp.config('texlab', require("lsp.servers.texlab"))

            -- 3. Enable ALL your servers 
            -- (Mason ensures they are downloaded, this actually turns them on)
            local all_servers = {
                "pyright", "ruff", "lua_ls", "bashls", "clangd", 
                "cssls", "eslint", "html", "jsonls", "ts_ls", "tailwindcss", "texlab"
            }
            
            for _, server in ipairs(all_servers) do
                vim.lsp.enable(server)
            end

            -- 4. Diagnostics & Keymaps
            local signs = { Error = "󰅚", Warn = "󰀪", Hint = "󰌶", Info = "" }
            for type, icon in pairs(signs) do
                vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticSign" .. type })
                vim.fn.sign_define("DiagnosticSign" .. type, { text = "", texthl = "DiagnosticSign" .. type, linehl = "", numhl = "DiagnosticSign" .. type })
            end

            vim.o.updatetime = 250
            vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

            vim.diagnostic.config({
                virtual_text = true,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = signs.Error,
                        [vim.diagnostic.severity.WARN] = signs.Warn,
                        [vim.diagnostic.severity.INFO] = signs.Info,
                        [vim.diagnostic.severity.HINT] = signs.Hint,
                    },
                },
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = {
                    format = function(diagnostic)
                        local source = diagnostic.source and ("[" .. diagnostic.source .. "] ") or ""
                        return source .. diagnostic.message
                    end,
                }
            })

            require("lsp.keymaps")
        end,
    }
}



