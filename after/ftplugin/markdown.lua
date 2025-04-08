
vim.opt.wrap = true


-- change j and k to act like gj and gk which respect soft-wrapped lines
vim.api.nvim_set_keymap('n', 'j', 'gj', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'k', 'gk', { noremap = true, silent = true })

vim.keymap.set("n", "<CR>", ":lua require('custom.my_plugins.markdown_checklist').conditional_toggle()<CR>", { noremap = true, silent = true })
--  vim.keymap.set("n", "<leader>tt", ":lua require('custom.my_plugins.markdown_checklist').toggle()<CR>")
