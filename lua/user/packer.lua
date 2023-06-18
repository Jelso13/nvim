-- only required if you have packer configured as 'opt'
-- vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- telescope
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use('nvim-telescope/telescope-symbols.nvim')

    -- folke tokyonight colorscheme
    use({
        'folke/tokyonight.nvim',
        as = 'tokyonight',
        config = function()
            vim.cmd('colorscheme tokyonight')
        end
    })

    -- colors in terminal
    use('norcalli/nvim-colorizer.lua')

    -- treesitter
    use({ 'nvim-treesitter/nvim-treesitter', run = 'TSUpdate' })
    use('nvim-treesitter/playground')

    -- harpoon
    use('theprimeagen/harpoon')

    -- undotree
    use('mbbill/undotree')

    -- vim fugitive
    use('tpope/vim-fugitive')

    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' }, -- completion engine
            { 'hrsh7th/cmp-buffer' }, -- suggestions based on current file
            { 'hrsh7th/cmp-path' }, -- filesystem completions
            { 'saadparwaiz1/cmp_luasnip' }, -- shows snippets in suggestions
            { 'hrsh7th/cmp-nvim-lsp' }, -- show data sent by ls
            { 'hrsh7th/cmp-nvim-lua' }, -- completion for nvim api

            -- Snippets
            -- { 'L3MON4D3/LuaSnip', tag = "v<CurrentMajor>.*" }, -- correct v
            { 'L3MON4D3/LuaSnip'}, -- correct v
            -- { 'rafamadriz/friendly-snippets' }, -- snippet database
        }
    }


    -- vim-be-good game for getting better at vim navigation
    use('ThePrimeagen/vim-be-good')

    -- gitsigns
    -- use('lewis6991/gitsigns.nvim')

    -- autopairs
    use('windwp/nvim-autopairs')

    -- lualine
    use('nvim-lualine/lualine.nvim') -- change the status line
    use('kyazdani42/nvim-web-devicons') -- icons for lualine

    -- which-key
    use('folke/which-key.nvim')

    -- Obsidian
    use('epwalsh/obsidian.nvim')

    -- Markdown plugin (alt to obsidian)
    use('jakewvincent/mkdnflow.nvim')

    -- latex
    use('lervag/vimtex')

    -- zen mode (mainly for centering on a wide screen)
    use('folke/zen-mode.nvim')

    -- firenvim
    use {
        'glacambre/firenvim',
        run = function() vim.fn['firenvim#install'](0) end,
        -- opt = true,
        -- setup = [[vim.cmd('packadd firenvim')]],
    }

    -- rust tools so that lsp works with standalone rust files (firenvim)
    use('simrat39/rust-tools.nvim')

    -- github copilot
    use('github/copilot.vim')

end)
