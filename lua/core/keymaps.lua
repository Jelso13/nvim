-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

--[[
NOTE:
Keybindings should typically be of the form verb-object.
In cases where a context is required (such as git) the context is prefixed:
    Context-verb-object
Examples:
    <localleader>ef      -> [E]dit [F]igure in latex
    <leader>grb          -> [G]it [R]eset [B]uffer
--]]

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

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
-- if oil.nvim is not available, use the following keymap
local success, _ = pcall(require, "oil")
if not success then
    -- vim.keymap.set("n", "<leader>pv", ":e .<CR>", { desc = "Project View" })
    vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "[P]roject [V]iew" })
end

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

-- -- delete without storing in register - current conflict with debug bindings
-- vim.keymap.set("n", "<leader>d", '"_d', { desc = "delete without storing in register" })
-- vim.keymap.set("v", "<leader>d", '"_d', { desc = "delete without storing in register" })

-- remap Q to repeat last macro
vim.keymap.set("n", "Q", "@@", { desc = "repeat last macro" })

-- open new tmux session
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", { desc = "open file in new tmux session" })

-- quickfix commands... NOTE: prefer 'q' over 'c' for quickfix as unlikely to need q for quit or something
-- Diagnostic keymaps
-- vim.keymap.set("n", "<leader>qd", vim.diagnostic.setloclist, { desc = "Open [Q]uickfix [D]iagnostic list" })
vim.keymap.set("n", "<leader>qd", function()
    local diagnostics = vim.diagnostic.get(0) -- Get diagnostics only for the current buffer
    vim.fn.setqflist({}, 'r', {
        title = "Diagnostics (Current Buffer)",
        items = vim.diagnostic.toqflist(diagnostics),
    })
    vim.cmd('copen') -- Open the quickfix list
end, { desc = "Open [Q]uickfix [D]iagnostic list for current buffer" })
vim.keymap.set("n", "<leader>qp", vim.diagnostic.setqflist, { desc = "Open [Q]uickfix [P]roject Diagnostic list" })
vim.keymap.set("n", "<leader>qc", ":cexpr []<CR>", { desc="[Q]uickfix [C]lear" })
vim.keymap.set("n", "<leader>qh", ":chistory<CR>", { desc="[Q]uickfix [H]istory" })
vim.keymap.set("n", "<leader>qv", ":copen<CR>", { desc="[Q]uickfix [V]iew" })
-- maybe add this under d for <leader>dq for [D]ebug add to [Q]uickfix
-- vim.keymap.set("n", "<leader>qb", ":cbuffer<CR>", { desc="Sets the quickfix list from errors in the current buffer."})
-- same with this one
-- vim.keymap.set("n", "<leader>qa", ":caddbuffer<CR>", { desc="Adds the errors from the current buffer to the quickfix list."})
-- vim.keymap.set("n", "<leader>qw", ":cwindow<CR>", { desc="Opens the quickfix list if there are errors, closes it otherwise."})
vim.keymap.set("n", "<leader>qt", function()
    if vim.fn.getqflist({ winid = 0 }).winid == 0 then
        vim.cmd('copen')
    else
        vim.cmd('cclose')
    end
end, { desc = "[Q]uickfix [T]oggle" })
vim.keymap.set("n", "]q", ":cnext<CR>zz", { desc = "jump to next item in quickfix" })
vim.keymap.set("n", "[q", ":cprev<CR>zz", { desc = "jump to prev item in quickfix" })

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


-- LSP commands
vim.keymap.set("n", "<leader>lr", ":LspRestart<CR>", { desc="[L]sp [R]estart" })

vim.keymap.set("n", "<leader>ls", function()
    local current_config = vim.diagnostic.config()
    local new_severity

    -- Check current severity and toggle
    if current_config.virtual_text and current_config.severity == vim.diagnostic.severity.WARN then
        new_severity = vim.diagnostic.severity.ERROR
    else
        new_severity = vim.diagnostic.severity.WARN
    end

    -- Update diagnostic configuration
    vim.diagnostic.config({
        virtual_text = {
            severity = new_severity,
        },
    })

    print("Virtual text severity set to " .. (new_severity == vim.diagnostic.severity.ERROR and "ERROR" or "WARN"))
end, { desc = "[L]sp [S]everity" })

-- Obsidian daily note

-- Map the function to <leader>o
-- vim.keymap.set('n', '<leader>o', function()
--     local ok, obsidian = pcall(require, 'obsidian')
--     if not ok then
--         print('Obsidian plugin not found')
--         return
--     end
-- 
--     -- Open the daily note
--     -- obsidian.open_daily_note()
--     vim.cmd('ObsidianToday')
-- 
-- end, { noremap = true, silent = true })
-- local function open_floating_vault()
--     local filepath = '~/Vault/Vault.md' -- File to open
--     filepath = vim.fn.expand(filepath) -- Expand ~ to home directory
-- 
--     -- Find existing buffer by name
--     local bufnr = vim.fn.bufnr(filepath)
-- 
--     -- If the buffer does not exist, create a new one
--     if bufnr == -1 then
--         bufnr = vim.api.nvim_create_buf(false, true) -- Create a new unnamed buffer
--         vim.api.nvim_buf_set_name(bufnr, filepath) -- Set the buffer name to the file path
--         vim.api.nvim_buf_set_option(bufnr, 'buftype', 'nofile') -- No file type
--         vim.api.nvim_buf_set_option(bufnr, 'bufhidden', 'wipe') -- Wipe the buffer when hidden
--         vim.cmd('edit ' .. filepath) -- Load the file into the buffer
--     else
--         -- If the buffer exists, switch to it and refresh it
--         vim.api.nvim_set_current_buf(bufnr) 
--         vim.cmd('edit ' .. filepath) -- Reload the file content
--     end
-- 
--     -- Define the floating window dimensions
--     local width = math.floor(vim.o.columns * 0.8) -- Width of the floating window
--     local height = math.floor(vim.o.lines * 0.8) -- Height of the floating window
-- 
--     local opts = {
--         style = 'minimal',
--         relative = 'editor',
--         width = width,
--         height = height,
--         row = (vim.o.lines - height) / 2, -- Center vertically
--         col = (vim.o.columns - width) / 2, -- Center horizontally
--     }
-- 
--     -- Create the floating window
--     local win_id = vim.api.nvim_open_win(bufnr, true, opts)
-- 
--     -- Set up a key mapping to close the window
--     vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q', ':q<CR>', { noremap = true, silent = true })
--     
--     -- Automatically close the floating window and wipe the buffer when it is deleted
--     vim.api.nvim_command('autocmd BufDelete <buffer> :bwipeout ' .. bufnr)
-- end
-- 
-- -- Register the user command
-- vim.api.nvim_create_user_command('OpenVault', open_floating_vault, {})
-- -- Keymapping
-- vim.api.nvim_set_keymap('n', '<leader>o', '<cmd>OpenVault<CR>', { noremap = true, silent = true })
-- 
