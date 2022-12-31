local builtin = require('telescope.builtin')
local utils = require("telescope.utils")
local previewers = require("telescope.previewers")

local telescope = require("telescope")

-- telescope.setup{
local setup = {
    defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-h>"] = "which_key"
      }
    },
    prompt_prefix = "🔍",
    file_previewer = previewers.vim_buffer_cat.new,
    grep_previewer = previewers.vim_buffer_vimgrep.new,
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
  }
}

telescope.setup(setup)

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


