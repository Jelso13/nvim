return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "williamboman/mason.nvim",
            -- languages
            "mfussenegger/nvim-dap-python",
        },
        config = function()
            require("dap.config")
        end,
    },
    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = { "mfussenegger/nvim-dap" },
        config = function(_, opts)
            require("dap-python").setup("python")
        end,
    },
}

-- -- from lazy-transition branch
-- return {
-- 	{ -- Autocompletion
-- 		"hrsh7th/nvim-cmp",
--         lazy = false,
--         priority = 100,
-- 		-- event = "InsertEnter",
-- 		dependencies = {
--             -- luasnips completion
-- 			"saadparwaiz1/cmp_luasnip",
--
-- 			-- Adds other completion capabilities.
-- 			--  nvim-cmp does not ship with all sources by default. They are split
-- 			--  into multiple repos for maintenance purposes.
-- 			"hrsh7th/cmp-nvim-lsp", --
-- 			"hrsh7th/cmp-path", -- source for completing files
--             "hrsh7th/cmp-nvim-lua", -- source for neovim development
--             "hrsh7th/cmp-nvim-lsp", -- source for auto import and lsp-snippet functions
--             -- Snippet Engine & its associated nvim-cmp source
--             { "L3MON4D3/LuaSnip",build = "make install_jsregexp" },
-- 		},
-- 		config = function()
--             require("completion.config")
--         end
-- 	},
-- }
--
