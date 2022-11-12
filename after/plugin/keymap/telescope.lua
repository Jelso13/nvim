local Remap = require("user.keymaps")
local nnoremap = Remap.nnoremap

-- simplest version of telescope bindings
-- keymap("n", "<leader>f", "<cmd>Telescope find_files<cr>", opts)

-- find files without having a file previewer window that shows the content of that file
nnoremap("<leader>f", "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>")

-- grep through text
nnoremap("<c-t>", "<cmd>Telescope live_grep<cr>")

-- search through buffers
nnoremap("<leader>fb", "<cmd>Telescope buffers<cr>")

-- Note entirely sure what this does
nnoremap("<leader>ps", function()
    require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})
end)



-- THE PRIMEAGEN STUFF 
-- nnoremap("<C-p>", ":Telescope")
-- nnoremap("<leader>ps", function()
--     require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})
-- end)
-- nnoremap("<C-p>", function()
--     require('telescope.builtin').git_files()
-- end)
-- nnoremap("<Leader>pf", function()
--     require('telescope.builtin').find_files()
-- end)
-- 
-- nnoremap("<leader>pw", function()
--     require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }
-- end)
-- nnoremap("<leader>pb", function()
--     require('telescope.builtin').buffers()
-- end)
-- nnoremap("<leader>vh", function()
--     require('telescope.builtin').help_tags()
-- end)
-- 
-- -- TODO: Fix this immediately
-- nnoremap("<leader>vwh", function()
--     require('telescope.builtin').help_tags()
-- end)
-- 
-- nnoremap("<leader>vrc", function()
--     require('user.telescope').search_dotfiles({ hidden = true })
-- end)
-- nnoremap("<leader>va", function()
--     require('user.telescope').anime_selector()
-- end)
-- nnoremap("<leader>vc", function()
--     require('user.telescope').chat_selector()
-- end)
-- nnoremap("<leader>gc", function()
--     require('user.telescope').git_branches()
-- end)
-- nnoremap("<leader>gw", function()
--     require('telescope').extensions.git_worktree.git_worktrees()
-- end)
-- nnoremap("<leader>gm", function()
--     require('telescope').extensions.git_worktree.create_git_worktree()
-- end)
-- nnoremap("<leader>td", function()
--     require('user.telescope').dev()
-- end)
-- 
