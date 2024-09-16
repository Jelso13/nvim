-- from lazy-transition branch
return {
	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
        lazy = false,
        priority = 100,
		-- event = "InsertEnter",
		dependencies = {
            -- luasnips completion
			"saadparwaiz1/cmp_luasnip",

			-- Adds other completion capabilities.
			--  nvim-cmp does not ship with all sources by default. They are split
			--  into multiple repos for maintenance purposes.
			"hrsh7th/cmp-path", -- source for completing files
            "hrsh7th/cmp-nvim-lua", -- source for neovim development
            "hrsh7th/cmp-nvim-lsp", -- source for auto import and lsp-snippet functions
            -- Snippet Engine & its associated nvim-cmp source
            { "L3MON4D3/LuaSnip",build = "make install_jsregexp" },
		},
		config = function()
            require("completion.config")
        end
	},
}






-- --[[
-- Code completion plugin
-- --]]
-- return {
-- 	{ -- Autocompletion
-- 		"hrsh7th/nvim-cmp",
-- 		event = "InsertEnter",
-- 		dependencies = {
-- 			-- Snippet Engine & its associated nvim-cmp source
-- 			"L3MON4D3/LuaSnip",
-- 			"saadparwaiz1/cmp_luasnip",
-- 
-- 			-- Adds other completion capabilities.
-- 			--  nvim-cmp does not ship with all sources by default. They are split
-- 			--  into multiple repos for maintenance purposes.
-- 			"hrsh7th/cmp-nvim-lsp",
-- 			"hrsh7th/cmp-path",
-- 		},
-- 		opts = {
-- 			performance = {
-- 				debounce = 0, -- default is 60ms
-- 				throttle = 0, -- default is 30ms
-- 			},
-- 		},
-- 		config = function()
-- 			-- See `:help cmp`
-- 			local cmp = require("cmp")
-- 			local luasnip = require("luasnip")
-- 			-- luasnip.config.setup({})
-- 
-- 			cmp.setup({
-- 				snippet = {
-- 					expand = function(args)
-- 						luasnip.lsp_expand(args.body)
-- 					end,
-- 				},
-- 				completion = { completeopt = "menu,menuone,noinsert" },
-- 
-- 				-- For an understanding of why these mappings were
-- 				-- chosen, you will need to read `:help ins-completion`
-- 				--
-- 				-- No, but seriously. Please read `:help ins-completion`, it is really good!
-- 				mapping = cmp.mapping.preset.insert({
-- 					-- Select the [n]ext item
-- 					-- ["<C-n>"] = cmp.mapping.select_next_item(),
-- 					-- swap this out, ctrl-j in insert mode did new line
-- 					["<C-j>"] = cmp.mapping.select_next_item(),
-- 					-- Select the [p]revious item
-- 					-- ["<C-p>"] = cmp.mapping.select_prev_item(),
-- 					-- swap these out, ctrl-k in insert mode previously did digraphs
-- 					["<C-k>"] = cmp.mapping.select_prev_item(),
-- 
-- 					-- Scroll the documentation window [b]ack / [f]orward
-- 					["<C-b>"] = cmp.mapping.scroll_docs(-4),
-- 					["<C-f>"] = cmp.mapping.scroll_docs(4),
-- 
-- 					-- Accept ([y]es) the completion.
-- 					--  This will auto-import if your LSP supports it.
-- 					--  This will expand snippets if the LSP sent a snippet.
-- 					["<C-y>"] = cmp.mapping.confirm({ select = true }),
-- 
-- 					-- If you prefer more traditional completion keymaps,
-- 					-- you can uncomment the following lines
-- 					--['<CR>'] = cmp.mapping.confirm { select = true },
-- 					--['<Tab>'] = cmp.mapping.select_next_item(),
-- 					--['<S-Tab>'] = cmp.mapping.select_prev_item(),
-- 
-- 					-- Manually trigger a completion from nvim-cmp.
-- 					--  Generally you don't need this, because nvim-cmp will display
-- 					--  completions whenever it has completion options available.
-- 					["<C-Space>"] = cmp.mapping.complete({}),
--                     
-- 					-- Think of <c-l> as moving to the right of your snippet expansion.
-- 					--  So if you have a snippet that's like:
-- 					--  function $name($args)
-- 					--    $body
-- 					--  end
-- 					--
-- 					-- <c-l> will move you to the right of each of the expansion locations.
-- 					-- <c-h> is similar, except moving you backwards.
-- 					["<C-l>"] = cmp.mapping(function()
-- 						if luasnip.expand_or_locally_jumpable() then
-- 							luasnip.expand_or_jump()
-- 						end
-- 					end, { "i", "s" }),
-- 					["<C-h>"] = cmp.mapping(function()
-- 						if luasnip.locally_jumpable(-1) then
-- 							luasnip.jump(-1)
-- 						end
-- 					end, { "i", "s" }),
-- 
-- 					-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
-- 					--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
-- 				}),
-- 				sources = {
-- 					{ name = "nvim_lsp" },
-- 					{ name = "luasnip" },
-- 					{ name = "path" },
-- 				},
-- 			})
-- 		end,
-- 	},
-- }
