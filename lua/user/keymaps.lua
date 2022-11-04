
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


keymap("n", "<leader>pv", "<cmd>Ex<CR>", opts)              -- open netrw pb is project view

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Go to next search location and center screen
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)

-- Join lines
keymap("n", "J", "mzJ`z", opts)

-- Scroll a half screen and recenter
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)

-- Potentially add 'vim-with-me' bindings

-- delete to 'black hole register' or _ and paste within selection - replace word with copied text
keymap("x", "<leader>p", "\"_dP", opts)

-- yanks to global register 
keymap("n", "<leader>y", "\"+y", opts)
keymap("v", "<leader>y", "\"+y", opts)

-- delete without storing in register
keymap("n", "<leader>d", "\"_d", opts)
keymap("v", "<leader>d", "\"_d", opts)


-- NEED TO CHANGE THE KEYMAPPING TO BE LIKE PRIMEAGEN SO FUNCTIONS CAN DIRECTLY BE PASSED
-- format from language server protocol
-- keymap("n", "<leader>f", function()
--     vim.lsp.buf.format()
-- end)

-- quickfix commands...
























