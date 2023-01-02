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

    -- treesitter
    use({ 'nvim-treesitter/nvim-treesitter', run = 'TSUpdate' })

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
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }

    -- vim-be-good game for getting better at vim navigation
    use('ThePrimeagen/vim-be-good')

    -- autopairs
    use('windwp/nvim-autopairs')

    -- gitsigns
    -- use('lewis6991/gitsigns.nvim')
    
    -- lualine
    use('nvim-lualine/lualine.nvim') -- change the status line
    use('kyazdani42/nvim-web-devicons') -- icons for lualine

    -- which-key
    use('folke/which-key.nvim')

    -- Obsidian
    use('epwalsh/obsidian.nvim')
    
    -- Markdown plugin (alt to obsidian)
    use('jakewvincent/mkdnflow.nvim')

end)
