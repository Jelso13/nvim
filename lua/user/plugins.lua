
local fn = vim.fn

-- Automatically install packer
--
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end


-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])


-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Install your plugins here
return packer.startup(function(use)
    -- Plugins
    use 'wbthomason/packer.nvim' -- Have packer manage itself

    -- Misc **Need to label
    use "nvim-lua/plenary.nvim"
    use "nvim-lua/popup.nvim"

    use 'ThePrimeagen/vim-be-good' -- neovim game for learning vim movements

    -- COLORSCHEME
    use 'folke/tokyonight.nvim'

    -- COMPLETION PLUGINS
    use "hrsh7th/nvim-cmp"              -- The completion plugin
    use "hrsh7th/cmp-buffer"            -- buffer comletions
    use "hrsh7th/cmp-path"              -- path completions
    use "hrsh7th/cmp-cmdline"           -- cmdline completions
    use "saadparwaiz1/cmp_luasnip"      -- snippet completions
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-nvim-lua"

    -- AUTOPAIRS
    use "windwp/nvim-autopairs" -- autopairs, integrates with both cmp and treesitter

    -- SNIPPETS
    use "L3MON4D3/LuaSnip"              -- the snippet engine
    use "rafamadriz/friendly-snippets"  -- collection of snippets to use

    -- LSP
    use "neovim/nvim-lspconfig"         -- enable LSP
    use "williamboman/mason.nvim" -- simple to use language server installer
    use "williamboman/mason-lspconfig" -- simple to use language server installer

    -- TELESCOPE
    use "nvim-telescope/telescope.nvim" -- Very extensible fuzzy finder
    use({
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make"
    })
    -- use "nvim-telescope/telescope-media-files.nvim" -- loads missing entities for telescope
    -- use "seebye/ueberzug" -- for image support

    -- TREESITTER
    use {"nvim-treesitter/nvim-treesitter", run=":TSUpdate",}

    -- COMMENT
    use "numToStr/Comment.nvim" -- can maybe remove this
    use "JoosepAlviste/nvim-ts-context-commentstring" -- can also maybe remove this (see how useful it is for react stuff otherwise bin)

    -- GITSIGNS
    use "lewis6991/gitsigns.nvim"

    -- HARPOON
    use "ThePrimeagen/harpoon" -- marking and navigating between files intelligently

    -- LUALINE
    use "nvim-lualine/lualine.nvim" -- change the status line
    use "kyazdani42/nvim-web-devicons" -- for icons in lualine

    -- WHICH-KEY
    use "folke/which-key.nvim"

    -- OBSIDIAN
    use "epwalsh/obsidian.nvim"

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require('packer').sync()
    end
end)
