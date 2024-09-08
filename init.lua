-- Set <space> as the leader key
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
-- set - as local leader key
vim.g.maplocalleader = "-"

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
require("core.options")

-- [[ Basic Keymaps ]]
require("core.keymaps")

-- [[ Install `lazy.nvim` plugin manager ]]
require("core.lazy-bootstrap")

-- [[ Configure and install plugins ]]
require("core.lazy-plugins")
