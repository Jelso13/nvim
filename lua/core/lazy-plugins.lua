-- [[ Configure and install plugins ]]
--
--
--      Key plugins:
--      
--      Add a readme for each directory explaining what the key plugin is.
--      
--      # lazy.nvim:
--          package manager
--      
--      # Mason:
--          external package manager for:
--              - lsp
--              - formatters
--              - linters
--              - debuggers
--      
--      # nvim-cmp:
--          completion
--      
--      # luasnip:
--          snippets
--      
--      # conform.nvim:
--          formatting
--      
--      # treesitter:
--          fast syntax parsing
--      
--      # none-ls:
--          linting
--      
--      # debugging:
--          nvim dap
--      
--      
--      
--      then general plugins in a plugin folder
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require("lazy").setup({
    -- Include Mason for bringing in external sources
    require("core/mason"),


	-- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).

	-- NOTE: Plugins can also be added by using a table,
	-- with the first argument being the link and the following
	-- keys can be used to configure plugin behavior/loading/etc.
	--
	-- Use `opts = {}` to force a plugin to be loaded.
    
    -- all lsp plugins with configuration
    require("lsp"),

    -- linter
    require("linter"),

    -- formatting
    require("formatter"),

	-- -- cmp plugin: completion plugin
    -- require("plugins/cmp"),
    require("completion"),

    require("snippets"),
    
	-- modular approach: using `require 'path/name'` will
	-- include a plugin definition from file lua/path/name.lua

	-- gitsigns plugin: show git changes in the sign column
	require("plugins/gitsigns"),
    require("plugins/fugitive"),

	-- -- -- which-key plugin: show keybindings in a popup
	require("plugins/which-key"),

	-- -- telescope plugin: fuzzy finder
	require("plugins/telescope"),

    -- oil.nvim: allows intuitive directory and file editing using text manipulation
    require("plugins/oil"),

	-- -- tokyonight plugin: color scheme
	require("plugins/tokyonight"),

	require("plugins/todo-comments"),

	require("plugins/mini"),

    -- require("plugins/blankline"),

    -- actually quite useful as makes navigation easier especially
    require("plugins/autopairs"),

	require("plugins/harpoon"),

	require("plugins/treesitter"),
    -- TODO: (Add) Display the current context (class, function etc) at the top of the screen https://github.com/nvim-treesitter/nvim-treesitter-context
    require("plugins/treesitter_context"),


	require("plugins/zenmode"),

    require("plugins/obsidian"),

	-- require("plugins/none-ls"),
	-- -- -- Markdown plugin (alt to obsidian)
	-- -- -- use("jakewvincent/mkdnflow.nvim")
	-- -- -- require("plugins/mkdnflow.nvim"),
    

    -- debugging TODO: CURRENTLY NOT WORKING
    -- require("dap"),


	-- -- -- latex
	-- -- -- use("lervag/vimtex")
	require("plugins/vimtex"),

	-- The following two comments only work if you have downloaded the kickstart repo, not just copy pasted the
	-- init.lua. If you want these files, they are in the repository, so you can just download them and
	-- place them in the correct locations.

	-- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
	--
	--  Here are some example plugins that I've included in the Kickstart repository.
	--  Uncomment any of the lines below to enable them (you will need to restart nvim).
	--
	-- require 'kickstart.plugins.debug',
	-- require 'kickstart.plugins.indent_line',
	-- require 'kickstart.plugins.lint',
	-- require("kickstart.plugins.autopairs"),
    --
    -- Vim-be-good
    -- require("ThePrimeagen/vim-be-good"),
    require("plugins/misc/vim-be-good"),
    -- Leetcode
    require("plugins/misc/leetcode"),
    -- vim golf
    { 'vuciv/golf' },

	-- -- -- copilot
	require("plugins/copilot"),
    -- currently needs paid version of copilot
    -- require("plugins/avante"),
    require("plugins/gemini"),

	-- -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
	-- --    This is the easiest way to modularize your config.
	-- --
	-- --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
	-- --    For additional information, see `:help lazy.nvim-lazy.nvim-structuring-your-plugins`
	-- { import = "custom.plugins" },
	-- { import = "custom.languages" },
    
    -- Custom plugins
    require("custom.my_plugins.inkscape_figures"),

    -- language specific plugins
    require("plugins.language_specific_plugins"),
}, {
	ui = {
		-- If you are using a Nerd Font: set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
