-- ~/.config/nvim/lua/plugins/git.lua
---@type LazySpec
return {
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'Gdiffsplit', 'Gread', 'Gwrite', 'Ggrep', 'GMove', 'GDelete', 'GBrowse', 'GRemove' },
    event = 'VeryLazy',
  },
}
