-- THE REMAP FILE FOR DIFFERENT KEYS

-- set the leader key
vim.g.mapleader = " "

-- open netrw with leader pv
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Resize with arrows
vim.keymap.set("n", "<C-Up>", ":resize -2<CR>")
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>")
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>")

-- Go to next search location and center screen
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- move lines that are visually selected
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- join lines with J when in normal mode
vim.keymap.set("n", "J", "mzJ`z")

-- Scroll a half screen and recenter
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Potentially add 'vim-with-me' bindings

-- delete to 'black hole register' or _ and paste within selection - replace word with copied text
vim.keymap.set("x", "<leader>p", "\"_dP")

-- prevent paste over visual select from picking up item beneath
vim.keymap.set("v", "p", '"_dP')

-- yanks to global register
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")
vim.keymap.set("v", "<leader>y", "\"+y")

-- delete without storing in register
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- remap Q to repeat last macro
vim.keymap.set("n", "Q", "@@")

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- format from language server protocol
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format()
end)


-- quickfix commands...
-- go between errors (need lsp)
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- not sure what this stuff does
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")


-- fast substitution of elements
vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

-- make the current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- does not exit selection when indenting block (maybe redo this one)
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")


-- test for ctrl backspace workign in insert mode
vim.keymap.set("i", "<C-h>", "<C-w>")
-- vim.keymap.set("i", "<C-?>", "<C-w>")








