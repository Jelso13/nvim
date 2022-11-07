-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",


local Remap = require("user.keymaps")
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap
local inoremap = Remap.inoremap
local xnoremap = Remap.xnoremap
local tnoremap = Remap.tnoremap
local nmap = Remap.nmap




-- remap space as leader
nnoremap("<Space>", "<Nop>")


-- NORMAL MODE --
-- better window navigation
nnoremap("<C-h>", "<C-w>h")
nnoremap("<C-j>", "<C-w>j")
nnoremap("<C-k>", "<C-w>k")
nnoremap("<C-l>", "<C-w>l")

-- TERM MODE NAV
tnoremap("<C-h>", "<C-w>h")
tnoremap("<C-j>", "<C-w>j")
tnoremap("<C-k>", "<C-w>k")
tnoremap("<C-l>", "<C-w>l")


-- open netrw
nnoremap("<leader>pv", "<cmd>Ex<CR>")


-- Resize with arrows
nnoremap("<C-Up>", ":resize -2<CR>")
nnoremap("<C-Down>", ":resize +2<CR>")
nnoremap("<C-Left>", ":vertical resize -2<CR>")
nnoremap("<C-Right>", ":vertical resize +2<CR>")

-- Go to next search location and center screen
nnoremap("n", "nzzzv")
nnoremap("N", "Nzzzv")

-- Join lines
nnoremap("J", "mzJ`z")

-- Scroll a half screen and recenter
nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")

-- Potentially add 'vim-with-me' bindings

-- delete to 'black hole register' or _ and paste within selection - replace word with copied text
xnoremap("<leader>p", "\"_dP")

-- yanks to global register 
nnoremap("<leader>y", "\"+y")
vnoremap("<leader>y", "\"+y")

-- delete without storing in register
nnoremap("<leader>d", "\"_d")
vnoremap("<leader>d", "\"_d")


-- move lines and blocks of lines
vnoremap("J", ":m '>+1<CR>gv=gv")
vnoremap("K", ":m '<-2<CR>gv=gv")





-- remap Q to repeat last macro
nnoremap("Q", "@@")

nnoremap("<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- format from language server protocol
-- keymap("n", "<leader>f", function()
--     vim.lsp.buf.format()
-- end)


-- quickfix commands...
-- go between errors (need lsp)
-- nnoremap("<C-k>", "<cmd>cnext<CR>zz")
-- nnoremap("<C-j>", "<cmd>cprev<CR>zz")

-- not sure what this stuff does
nnoremap("<leader>k", "<cmd>lnext<CR>zz")
nnoremap("<leader>j", "<cmd>lprev<CR>zz")


-- same with this
nnoremap("<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
nnoremap("<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })








