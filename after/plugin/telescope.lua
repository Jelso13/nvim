

local builtin = require('telescope.builtin')
-- 'project-files' - find project files
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})

-- find files in git repo
vim.keymap.set('n', '<C-p>', builtin.git_files, {})

-- 'project search' - 
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)



