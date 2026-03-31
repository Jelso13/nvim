
vim.opt.wrap = true


-- change j and k to act like gj and gk which respect soft-wrapped lines
vim.api.nvim_set_keymap('n', 'j', 'gj', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'k', 'gk', { noremap = true, silent = true })

vim.keymap.set("n", "<CR>", ":lua require('custom.my_plugins.markdown_checklist').conditional_toggle()<CR>", { noremap = true, silent = true })
--  vim.keymap.set("n", "<leader>tt", ":lua require('custom.my_plugins.markdown_checklist').toggle()<CR>")
--
-- Intercept the Enter key in insert mode for markdown files
-- vim.keymap.set("i", "<CR>", function()
--     local line = vim.api.nvim_get_current_line()
-- 
--     -- Check if the line is exactly an empty checkbox (allowing for leading spaces)
--     if line:match("^%s*- %[%s%] %s*$") then
--         -- Clear the line entirely (Ctrl+U behavior)
--         return "<C-u>"
--     -- Check if the line contains a populated or empty checkbox with text after it
--     elseif line:match("^%s*- %[%s?%] ") then
--         -- Insert a newline and start a new empty checkbox
--         return "<CR>- [ ] "
--     else
--         -- Standard Enter behavior
--         return "<CR>"
--     end
-- end, { expr = true, buffer = true, desc = "Smart Checkbox Enter" })
