

## I LIKE THIS ONE
# Feature-based organisation
.
├── init.lua
├── after/
│   └── ftplugins/
├── lua/
│   ├── keymaps.lua
│   ├── lazy-bootstrap.lua
│   ├── lazy-plugins.lua
│   ├── options.lua
│   ├── plugins/
│   │   ├── packer.lua
│   │   └── plugins_config.lua
│   ├── settings/
│   │   ├── general.lua
│   │   ├── appearance.lua
│   │   └── mappings.lua
│   ├── lsp/
│   │   ├── init.lua
│   │   └── servers.lua
│   ├── dap/
│   │   └── config.lua
│   ├── formatters/
│   │   └── config.lua
│   ├── linters/
│   │   └── config.lua
│   └── snippets/
│       └── config.lua
└── colorschemes.lua

# Alt Feature-based organisation
.
├── init.lua
├── after/
│   └── ftplugins/
└── lua/
    ├── core/
    │   ├── keymaps.lua
    │   ├── lazy-bootstrap.lua
    │   ├── lazy-plugins.lua
    │   └── options.lua
    ├── plugins/
    │   ├── nvim_treesitter.lua
    │   ├── telescope.lua
    │   └── ...
    ├── appearance/
    │   ├── colorscheme.lua
    │   └── ...
    ├── lsp/
    │   ├── init.lua
    │   └── servers/
    │       ├── lua.lua
    │       ├── pyright.lua
    │       └── ...
    ├── dap/
    │   └── config.lua
    ├── formatters/
    │   └── config.lua
    ├── linters/
    │   └── config.lua
    └── snippets/
        └── config.lua


# CURRENT
.
├── after
│   ├── ftplugin
│   │   ├── python.lua
│   │   └── tex.lua
│   └── readme.md
├── data
│   └── telescope-sources
│       └── emoji.json
├── init.lua
├── lazy-lock.json
└── lua
    ├── config
    │   └── lsp
    │       ├── init.lua
    │       └── python.lua
    ├── custom
    │   ├── languages
    │   │   └── python.lua
    │   ├── my_plugins
    │   │   └── telescope_git_worktrees
    │   │       ├── config.lua
    │   │       ├── enum.lua
    │   │       ├── git.lua
    │   │       ├── hooks.lua
    │   │       ├── init.lua
    │   │       ├── logger.lua
    │   │       ├── status.lua
    │   │       └── worktree.lua
    │   └── plugins
    │       └── init.lua
    ├── keymaps.lua
    ├── kickstart
    │   ├── health.lua
    │   └── plugins
    │       ├── autopairs.lua
    │       ├── cmp.lua
    │       ├── conform.lua
    │       ├── copilot.lua
    │       ├── gitsigns.lua
    │       ├── harpoon.lua
    │       ├── lint.lua
    │       ├── lspconfig.lua
    │       ├── mini.lua
    │       ├── none-ls.lua
    │       ├── telescope.lua
    │       ├── todo-comments.lua
    │       ├── tokyonight.lua
    │       ├── treesitter.lua
    │       ├── vimtex.lua
    │       └── which-key.lua
    ├── lazy-bootstrap.lua
    ├── lazy-plugins.lua
    ├── lsp
    │   ├── init.lua
    │   └── servers
    │       └── lua.lua
    ├── options.lua
    └── telescope
        └── _extensions
            └── git_worktrees.lua

