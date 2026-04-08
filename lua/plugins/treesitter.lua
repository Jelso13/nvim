return {
    { -- Highlight, edit, and navigate code
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = {
                "bash", "c", "diff", "html", "latex", "lua", "luadoc",
                "markdown", "markdown_inline", "python", "query", "vim", "vimdoc",
            },
            auto_install = true,
            highlight = {
                enable = true,
                disable = {"latex"},
            },
            indent = { enable = true, disable = { "ruby" } },
        },
        config = function(_, opts)
            -- Safely attempt to load treesitter
            local status_ok, configs = pcall(require, "nvim-treesitter.configs")
            if not status_ok then
                return -- Stop executing if it isn't downloaded yet
            end
            
            -- If successful, pass your opts into the setup function
            configs.setup(opts)
        end,
    },
}
