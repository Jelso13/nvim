-- -- LSP Plugins
-- return {
-- 	{
-- 		-- Main LSP Configuration
-- 		"neovim/nvim-lspconfig",
-- 		dependencies = {
-- 			-- Automatically install LSPs and related tools to stdpath for Neovim
-- 			{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
-- 			"williamboman/mason-lspconfig.nvim",
-- 			"WhoIsSethDaniel/mason-tool-installer.nvim",
-- 
-- 			-- Allows extra capabilities provided by nvim-cmp
-- 			"hrsh7th/cmp-nvim-lsp",
-- 		},
-- 		config = function()
--             require("lsp.config")
-- 		end,
-- 	},
--     -- none-ls specification
--     {
--         "nvimtools/none-ls.nvim",
--         dependencies = { "mason.nvim", "nvim-lua/plenary.nvim" },
--         config = function()
--             local null_ls = require("null-ls")
-- 
--             null_ls.setup({
--                 sources = {
--                     -- Example sources
--                     -- null_ls.builtins.diagnostics.ruff,
--                     null_ls.builtins.diagnostics.mypy.with({
--                         extra_args = { "--strict" },  -- Optional: Enable strict mode for mypy
--                     }),
--                 },
--             })
--         end,
--     }
-- }


return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        local nvim_lsp = require("lspconfig")
        local mason_lspconfig = require("mason-lspconfig")

        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- -- Helper function to require configurations
        -- local function load_server_config(server)
        --     local success, config = pcall(require, "lsp.servers." .. server)
        --     if success then
        --         config(capabilities)
        --     else
        --         -- Fallback to default if no specific config file exists
        --         nvim_lsp[server].setup({
        --             capabilities = capabilities,
        --         })
        --     end
        -- end

        -- -- Set up handlers for all servers with separate config files for specific ones
        -- mason_lspconfig.setup_handlers({
        --     function(server)
        --         load_server_config(server)
        --     end,
        --     -- Optional: Manually call individual handlers if you need fine control
        --     ["pyright"] = function() load_server_config("pyright") end,
        --     ["lua_ls"] = function() load_server_config("lua_ls") end,
        --     ["rust-analyzer"] = function() load_server_config("rust_analyzer") end,
        -- })

        nvim_lsp.lua_ls.setup {require("lsp.servers.lua_ls")}
        -- nvim_lsp.ruff.setup {require("lsp.servers.ruff")}
        nvim_lsp.pyright.setup {require("lsp.servers.pyright")}
        -- causes issues with rustaceanvim
        nvim_lsp.rust_analyzer.setup {require("lsp.servers.rust_analyzer")}

        nvim_lsp.bashls.setup({})
        -- nvim_lsp.dcm.setup({})
        nvim_lsp.texlab.setup(require("lsp.servers.texlab"))
        -- nvim_lsp.ltex.setup({})
        nvim_lsp.clangd.setup({})
        nvim_lsp.cssls.setup({})
        nvim_lsp.eslint.setup({})
        nvim_lsp.html.setup({})
        nvim_lsp.jsonls.setup({})
        nvim_lsp.ts_ls.setup({})
        nvim_lsp.tailwindcss.setup({})

        -- Custom function to format diagnostics with source
        local function diagnostic_source_formatter(diagnostic)
            local source = diagnostic.source and ("[" .. diagnostic.source .. "] ") or ""
            return source .. diagnostic.message
        end



        -- Optional: Configure signs for diagnostics (if you want custom symbols)
        -- local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
        local signs = { Error = "󰅚", Warn = "󰀪", Hint = "󰌶", Info = "" }
        for type, icon in pairs(signs) do
            vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticSign" .. type })
        end
        -- Show line diagnostics automatically in hover window
        vim.o.updatetime = 250
        vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

        -- highlight line number instead of icons in sign column
        for _, diag in ipairs({ "Error", "Warn", "Info", "Hint" }) do
            vim.fn.sign_define("DiagnosticSign" .. diag, {
                text = "",
                texthl = "DiagnosticSign" .. diag,
                linehl = "",
                numhl = "DiagnosticSign" .. diag,
            })
        end

        -- Configure diagnostics
        vim.diagnostic.config({
            virtual_text = true,
            -- virtual_text = {
            --     format = diagnostic_source_formatter,  -- Use the custom formatter
            -- },
            -- signs = true,
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



        require("lsp.keymaps")
    end,
}

