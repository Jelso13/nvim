-- picker.lua (Basic Neovim picker - replace with a better UI if desired)
local M = {}

function M.pick(options)
  vim.ui.select(options, {}, function(choice)
    if choice then
      local index = vim.tbl_contains(options, choice) and vim.tbl_position(options, choice) or nil
      if index then
        M.selected_index = index
        M.selected_value = choice
      end
    end
  end)

  return M.selected_index, M.selected_value
end

return M
