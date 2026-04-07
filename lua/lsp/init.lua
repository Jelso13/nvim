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
        -- Fetch capabilities from Blink
        local capabilities = require("blink.cmp").get_lsp_capabilities()

        -- ==========================================
        -- 1. Custom Server Configurations
        -- ==========================================
        
        -- Lua
        local lua_opts = require("lsp.servers.lua_ls")
        lua_opts.capabilities = capabilities
        vim.lsp.config('lua_ls', lua_opts)
        vim.lsp.enable('lua_ls')

        -- Pyright
        local pyright_opts = require("lsp.servers.pyright")
        pyright_opts.capabilities = capabilities
        vim.lsp.config('pyright', pyright_opts)
        vim.lsp.enable('pyright')

        -- Ruff (Enabled for Python formatting/linting)
        vim.lsp.config('ruff', { capabilities = capabilities })
        vim.lsp.enable('ruff')

        -- Texlab
        local texlab_opts = require("lsp.servers.texlab")
        texlab_opts.capabilities = capabilities
        vim.lsp.config('texlab', texlab_opts)
        vim.lsp.enable('texlab')

        -- ==========================================
        -- 2. Basic Server Configurations
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
            vim.lsp.config(server, { capabilities = capabilities })
            vim.lsp.enable(server)
        end

        -- ==========================================
        -- 3. Diagnostics Configuration
        -- ==========================================
        local function diagnostic_source_formatter(diagnostic)
            local source = diagnostic.source and ("[" .. diagnostic.source .. "] ") or ""
            return source .. diagnostic.message
        end

        local signs = { Error = "󰅚", Warn = "󰀪", Hint = "󰌶", Info = "" }
        for type, icon in pairs(signs) do
            vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticSign" .. type })
            
            -- highlight line number instead of icons in sign column
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
