

local kind_icons = {
  Text = "",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰇽",
  Variable = "󰂡",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰅲",
}


-- from lazy-transition branch
return {
	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			{
				"L3MON4D3/LuaSnip",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					-- `friendly-snippets` contains a variety of premade snippets.
					--    See the README about individual language/framework/plugin snippets:
					--    https://github.com/rafamadriz/friendly-snippets
					-- {
					--   'rafamadriz/friendly-snippets',
					--   config = function()
					--     require('luasnip.loaders.from_vscode').lazy_load()
					--   end,
					-- },
				},
			},
            -- luasnips completion
			"saadparwaiz1/cmp_luasnip",

			-- Adds other completion capabilities.
			--  nvim-cmp does not ship with all sources by default. They are split
			--  into multiple repos for maintenance purposes.
			"hrsh7th/cmp-nvim-lsp", -- 
			"hrsh7th/cmp-path", -- source for completing files
            "hrsh7th/cmp-nvim-lua", -- source for neovim development
            "hrsh7th/cmp-nvim-lsp", -- source for auto import and lsp-snippet functions
		},
    opts = {
        performance = {
          debounce = 0, -- default is 60ms
          throttle = 0, -- default is 30ms
        },
    },
		config = function()
			-- See `:help cmp`
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			cmp.setup({
                snippet = {
                	expand = function(args)
                		luasnip.lsp_expand(args.body)
                	end,
                },
                formatting = {
                  format = function(entry, vim_item)
                    -- Kind icons
                    vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatenates the icons with the name of the item kind
                    -- Source
                    vim_item.menu = ({
                      buffer = "[Buf]",
                      nvim_lsp = "[LSP]",
                      luasnip = "[Snip]",
                      nvim_lua = "[Lua]",
                    })[entry.source.name]
                    return vim_item
                  end
                },
                window = {
                  -- completion = cmp.config.window.bordered(),
                  -- documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    -- not sure about tab and shift tab for completion
                    -- ["<Tab>"] = function(fallback)
                    --     if cmp.visible() then
                    --         cmp.select_next_item()
                    --     else
                    --         fallback()
                    --     end
                    -- end,
                    -- ["<S-Tab>"] = function(fallback)
                    --     if cmp.visible() then
                    --         cmp.select_prev_item()
                    --     else
                    --         fallback()
                    --     end
                    -- end,
                
                }),
                --[[
                sources can have multiple options.
                - keyword_length: determines required characters before suggestion
                - priority: manually assign priority value
                - max_item_count: limit the number of suggestions from a particular source
                --]]
                sources = cmp.config.sources({
                    -- ordering determines priority
                  { name = 'nvim_lua' },
                  { name = 'nvim_lsp' },
                  { name = 'path' },
                  { name = 'luasnip' }, -- For luasnip users.
                    -- words in the current buffer
                  { name = 'buffer', keyword_length=5 }, -- keyword_length determines required characters before suggestions are shown
                })
			})
		end,
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
