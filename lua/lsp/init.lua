return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        {
          "folke/lazydev.nvim",
          ft = "lua",
          opts = {
            library = {
              { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
          },
        },
    },
    config = function()
        -- ==========================================
        -- 1. Global Configurations (The 0.11+ Way)
        -- ==========================================
        -- Automatically inject Blink capabilities into EVERY server
        vim.lsp.config('*', {
            capabilities = require("blink.cmp").get_lsp_capabilities()
        })

        -- ==========================================
        -- 2. Custom Server Configurations
        -- ==========================================
        
        -- Lua
        vim.lsp.config('lua_ls', require("lsp.servers.lua_ls"))
        vim.lsp.enable('lua_ls')

        -- Pyright
        vim.lsp.config('pyright', require("lsp.servers.pyright"))
        vim.lsp.enable('pyright')

        -- Ruff (Enabled for Python formatting/linting)
        vim.lsp.enable('ruff')

        -- Texlab
        vim.lsp.config('texlab', require("lsp.servers.texlab"))
        vim.lsp.enable('texlab')

        -- ==========================================
        -- 3. Basic Server Configurations
        -- ==========================================
        local basic_servers = {
            "bashls",
            "clangd",
            "cssls",
            "eslint",
            "html",
            "jsonls",
            "ts_ls",
            "tailwindcss"
        }

        for _, server in ipairs(basic_servers) do
            -- Look how clean this is now!
            vim.lsp.enable(server)
        end

        -- ==========================================
        -- 4. Diagnostics Configuration
        -- ==========================================
        local function diagnostic_source_formatter(diagnostic)
            local source = diagnostic.source and ("[" .. diagnostic.source .. "] ") or ""
            return source .. diagnostic.message
        end

        local signs = { Error = "󰅚", Warn = "󰀪", Hint = "󰌶", Info = "" }
        for type, icon in pairs(signs) do
            vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticSign" .. type })
            
            vim.fn.sign_define("DiagnosticSign" .. type, {
                text = "",
                texthl = "DiagnosticSign" .. type,
                linehl = "",
                numhl = "DiagnosticSign" .. type,
            })
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
                format = diagnostic_source_formatter,
            }
        })

        -- Load keymaps
        require("lsp.keymaps")
    end,
}
