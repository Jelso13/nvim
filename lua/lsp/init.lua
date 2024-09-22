-- LSP Plugins
return {
	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Allows extra capabilities provided by nvim-cmp
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
            require("lsp.config")
		end,
	},
    -- none-ls specification
    {
        "nvimtools/none-ls.nvim",
        dependencies = { "mason.nvim", "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    -- Example sources
                    -- null_ls.builtins.diagnostics.ruff,
                    null_ls.builtins.diagnostics.mypy.with({
                        extra_args = { "--strict" },  -- Optional: Enable strict mode for mypy
                    }),
                },
            })
        end,
    }
}
