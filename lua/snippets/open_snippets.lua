-- Make sure you have 'plenary' and 'telescope' installed
local telescope = require('telescope.builtin')
local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')
local Path = require('plenary.path')

local M = {}

-- Function to open Telescope with your snippet files
M.open_snippet_files = function()
  local snippet_dir = vim.fn.expand("~/.config/nvim/lua/snippets/langs")

  -- Use telescope's find_files to list files in that directory
  telescope.find_files({
    prompt_title = "Snippets",
    cwd = snippet_dir,
    attach_mappings = function(prompt_bufnr, map)
      -- This function attaches mappings to handle selecting files
      actions.select_default:replace(function()
        local selected_entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        local file_path = selected_entry.path
        vim.cmd("edit " .. file_path)  -- Open the selected file
      end)
      return true
    end
  })
end

return M
