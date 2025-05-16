
local cfg = require('custom.my_plugins.inkscape_figures.config')
local uv  = vim.loop

local M = {}
M.roots_file = cfg.roots_file

local subscribers = {}

function M.get_roots()
  local lines = vim.fn.readfile(M.roots_file)
  local tbl = {}
  for _, l in ipairs(lines) do
    if l ~= '' then table.insert(tbl, l) end
  end
  return tbl
end

function M.add_root(path)
  -- avoid duplicates
  for _, r in ipairs(M.get_roots()) do
    if r == path then return end
  end
  vim.fn.writefile({path}, M.roots_file, 'a')
  for _, cb in ipairs(subscribers) do cb() end
end

function M.on_update(cb)
  table.insert(subscribers, cb)
end

return M
