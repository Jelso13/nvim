-- Setup copilot
-- local status_ok, copilot = pcall(require, "copilot")
-- if not status_ok then
--     return
-- end

vim.keymap.set('n', '<leader>cpe', '<cmd>Copilot enable<cr>', {desc="Enable copilot"})
vim.keymap.set('n', '<leader>cpd', '<cmd>Copilot disable<cr>', {desc="Disable copilot"})
vim.keymap.set('n', '<leader>cps', '<cmd>Copilot status<cr>', {desc="Copilot status"})
vim.keymap.set('n', '<leader>cpp', '<cmd>Copilot panel<cr>', {desc="Copilot panel"})
-- tab completion
vim.keymap.set('i', '<Tab>', '<cmd>lua require("copilot").tab_complete()<cr>', {expr=true})

-- disable by default
vim.cmd("Copilot disable")

