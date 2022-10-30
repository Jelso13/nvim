
local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- shorten the function name for keymaps
local keymap = vim.api.nvim_set_keymap

-- keybindings for specific keyboard type? (need to uncomment from init.lua
-- if kbtype == "workman" then
--     keymap("n", "<C-h>", "<C-w>h", opts)
-- elseif kbtype == "qwerty" then
--     keymap("n", "<C-h>", "<C-w>h", opts)
-- end


-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",




-- remap space as leader
keymap("", "<Space>", "<Nop>", opts)


-- NORMAL MODE --
-- better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)


keymap("n", "<leader>pv", "<cmd>Ex<CR>", opts)              -- open netrw pv is project view




