-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
--  I DONT NEED THESE - ITS A WASTE OF KEYMAPS; CTRL-W IS FINE
-- vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
-- vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
-- vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
-- vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- open netrw with leader pv
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Project View" })

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

-- delete to 'black hole register' or _ and paste within selection
-- - replace word with copied text
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "paste over block without storing old text" })
-- prevent paste over visual select from picking up item beneath
vim.keymap.set("v", "p", '"_dP', { desc = "paste over visual select without adding to buffer" })

-- -- delete without storing in register
-- vim.keymap.set("n", "<leader>d", '"_d', { desc = "delete without storing in register" })
-- vim.keymap.set("v", "<leader>d", '"_d', { desc = "delete without storing in register" })

-- remap Q to repeat last macro
vim.keymap.set("n", "Q", "@@", { desc = "repeat last macro" })

-- open new tmux session
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "open file in new tmux session" })

-- quickfix commands... TODO: remap as currently been replaced by window navigation
-- go between errors (need lsp)
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "next item in quickfix" })
vim.keymap.set("n", "<q-j>", "<cmd>cprev<CR>zz", { desc = "prev item in quickfix" })

-- move to next location in location list
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- make the current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "make current file executable" })

-- does not exit selection when indenting block (maybe redo this one)
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- test for ctrl backspace working in insert mode
vim.keymap.set("i", "<C-h>", "<C-w>")
