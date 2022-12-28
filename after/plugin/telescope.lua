local builtin = require('telescope.builtin')
local utils = require("telescope.utils")
local previewers = require("telescope.previewers")

-- 'project-files' - find project files
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "find files" })

-- find files in git repo
-- MAYBE CHANGE THIS BINDING
vim.keymap.set('n', '<leader>fg', builtin.git_files, { desc = "find git files" })

-- 'project search' -
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end,
    { desc = "project search" }
)

-- -- 'project search' -
-- vim.keymap.set('v', '<leader>ps', function()
--     builtin.grep_string({ search = vim.fn.input("Grep > \"") })
-- end,
--     { desc = "project search" }
-- )

-- 'find buffers'
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "find buffers" })

-- 'find word'

vim.keymap.set('n', '<leader>fw', function ()
    builtin.grep_string({ search = vim.fn.expand("<cword>")})
end,
    { desc="find word under cursor"}
)



-- LSP --
-- vim.keymap.set('n', '<leader>fc', builtin.lsp_references, { desc = "find buffers" })

-- GIT --
-- vim.keymap.set('n', '<leader>fc', builtin.git_commits, { desc = "find buffers" })
--

-- LISTS --
-- characters 🔥 🔥🔥🔥 🔧
-- vim.keymap.set('n', '<leader>fc', builtin.symbols, { desc = "find buffers" })


