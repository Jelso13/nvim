-- THE REMAP FILE FOR DIFFERENT KEYS

-- set the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "-"

-- open netrw with leader pv
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Project View" })
vim.keymap.set("n", "<localleader>pv", vim.cmd.Ex, { desc = "Project View" })

-- Resize with arrows
vim.keymap.set("n", "<C-Up>", ":resize -2<CR>")
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>")
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>")

-- Go to next search location and center screen
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- ** TODO change this so that can be prepended by a number - "6J" should move the selected line down by 6
-- move lines that are visually selected
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "move visually selected line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "move visually selected line up" })

-- join lines with J when in normal mode
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines" })

-- Scroll a half screen and recenter
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "scroll half screen down and recenter" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "scroll half screen up and recenter" })

-- Potentially add 'vim-with-me' bindings

-- delete to 'black hole register' or _ and paste within selection
-- - replace word with copied text
vim.keymap.set("x", "<leader>p", "\"_dP", { desc = "replace word with copied text" })

-- prevent paste over visual select from picking up item beneath
vim.keymap.set("v", "p", '"_dP', { desc = "paste over visual select without adding to buffer" })

-- yanks to global register
vim.keymap.set("n", "<leader>y", "\"+y", { desc = "yank to global register" })
vim.keymap.set("n", "<leader>Y", "\"+Y", { desc = "yank line to global register" })
vim.keymap.set("v", "<leader>y", "\"+y", { desc = "yank to global register" })

-- delete without storing in register
vim.keymap.set("n", "<leader>d", "\"_d", { desc = "delete without storing in register" })
vim.keymap.set("v", "<leader>d", "\"_d", { desc = "delete without storing in register" })

-- remap Q to repeat last macro
vim.keymap.set("n", "Q", "@@", { desc = "repeat last macro" })

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>",
    { desc = "open file in new tmux session" })



-- quickfix commands...
-- go between errors (need lsp)
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "next item in quickfix" })
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "prev item in quickfix" })
-- not sure what this stuff does
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")


-- fast substitution of elements
vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>",
    { desc = "substitute current word" })

-- make the current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>",
    { silent = true, desc="make current file executable" })

-- does not exit selection when indenting block (maybe redo this one)
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")


-- test for ctrl backspace workign in insert mode
vim.keymap.set("i", "<C-h>", "<C-w>")
-- vim.keymap.set("i", "<C-?>", "<C-w>")

-- fold bindings for moving over folds
-- vim.keymap.set("n", "[z", )

-- vim.keymap.set("n", "gc", "<cmd>CommentToggle<CR>", { desc = "toggle comment",
--     silent = true})
