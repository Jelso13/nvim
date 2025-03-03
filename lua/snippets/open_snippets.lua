
local M = {}

M.open_snippet_file = function()
  -- Get the current filetype (e.g. "python", "lua", etc.)
  local ft = vim.bo.filetype
  if ft == "" then
    vim.notify("No filetype detected!", vim.log.levels.WARN)
    return
  end

  -- Build the path to the snippet file based on filetype.
  -- Adjust the path as needed (here we assume your snippets live in ~/.config/nvim/lua/snippets/langs/)
  local snippet_path = vim.fn.stdpath("config") .. "/lua/snippets/langs/" .. ft .. ".lua"

  -- Save the current (previous) buffer number
  local prev_buf = vim.api.nvim_get_current_buf()

  -- Open the snippet file in the same window
  vim.cmd("edit " .. snippet_path)

  -- Get the buffer number of the snippet file
  local snippet_buf = vim.api.nvim_get_current_buf()

  -- Attach an autocmd that triggers when the snippet buffer is wiped out (typically on :wq)
  vim.api.nvim_create_autocmd("BufWipeout", {
    buffer = snippet_buf,
    callback = function()
      if vim.api.nvim_buf_is_valid(prev_buf) then
        -- Use vim.schedule to safely switch back to the previous buffer
        vim.schedule(function()
          vim.cmd("buffer " .. prev_buf)
        end)
      end
    end,
  })
end

return M
-- Make sure you have 'plenary' and 'telescope' installed
