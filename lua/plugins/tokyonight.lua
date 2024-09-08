return {
	{
		"folke/tokyonight.nvim",
		priority = 1000, -- Make sure to load this before all the other start plugins.
		opts = {
			style = "night", -- Choose your preferred style: 'storm', 'moon', 'night', 'day'
			transparent = false, -- Enable this to disable setting the background color
			terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
			styles = {
				comments = { italic = true },
				keywords = { italic = true },
				functions = {},
				variables = {},
				sidebars = "dark", -- style for sidebars, see below
				floats = "dark", -- style for floating windows
			},
			sidebars = { "qf", "vista_kind", "terminal", "packer" }, -- Set a darker background on sidebar-like windows
			day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
			hide_inactive_statusline = false, -- Hide inactive statuslines and replace them with a thin border instead
            -- colors and hints found at extras/lua/tokyonight_night.lua or https://github.com/folke/tokyonight.nvim/blob/main/extras/lua/tokyonight_night.lua
			-- Change the "hint" color to the "orange" color, and make the "error" color bright red
			on_colors = function(colors)
                -- make background darker
                colors.bg = "#161616"
			end,
            -- borderless telescope config
            on_highlights = function(hl, c)
                local prompt = "#2d3149"
                hl.TelescopeNormal = { bg = c.bg_dark, fg = c.fg_dark, }
                hl.TelescopeBorder = { bg = c.bg_dark, fg = c.bg_dark, }
                hl.TelescopePromptNormal = { bg = prompt, }
                hl.TelescopePromptBorder = { bg = prompt, fg = prompt, }
                hl.TelescopePromptTitle = { bg = prompt, fg = prompt, }
                hl.TelescopePreviewTitle = { bg = c.bg_dark, fg = c.bg_dark, }
                hl.TelescopeResultsTitle = { bg = c.bg_dark, fg = c.bg_dark, }
                hl.WhichKeyDesc = { fg= c.fg }
            end,
		},
		config = function(_, opts)
			require("tokyonight").setup(opts)
			-- vim.cmd.colorscheme 'tokyonight-night'
			vim.cmd.colorscheme("tokyonight")
		end,
	},
}

-- return {
--   { -- You can easily change to a different colorscheme.
--     -- Change the name of the colorscheme plugin below, and then
--     -- change the command in the config to whatever the name of that colorscheme is.
--     --
--     -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
--     'folke/tokyonight.nvim',
--     priority = 1000, -- Make sure to load this before all the other start plugins.
--     init = function()
--       -- Load the colorscheme here.
--       -- Like many other themes, this one has different styles, and you could load
--       -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
--       vim.cmd.colorscheme 'tokyonight-night'
--
--       -- You can configure highlights by doing something like:
--       vim.cmd.hi 'Comment gui=none'
--     end,
--   },
-- }
