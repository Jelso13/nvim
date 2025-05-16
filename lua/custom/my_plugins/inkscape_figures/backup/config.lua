-- lua/inkscape_figures/config.lua
local fn = vim.fn
local uv = vim.loop

local M = {}

-- 1) figure out where THIS file lives on disk:
--    debug.getinfo(1,'S').source returns "@/.../config.lua"
local source = debug.getinfo(1, 'S').source
local plugin_root = source:sub(2):match("(.*/)[^/]*$")             -- e.g. "/home/me/.local/share/nvim/lazy/inkscape_figures/lua/inkscape_figures/"
plugin_root = uv.fs_realpath(plugin_root .. "/")               -- go up one to ".../inkscape_figures/"

-- 2) user‐writable config dir & roots file
M.user_dir    = fn.stdpath('config') .. '/inkscape_figures'
M.roots_file  = M.user_dir .. '/roots'

-- 3) point at the template.svg shipped in the plugin itself
M.template_svg = plugin_root .. '/template.svg'
assert(uv.fs_stat(M.template_svg),
  "inkscape_figures: couldn’t find template.svg at: " .. M.template_svg)

-- Default LaTeX snippet (same as before)
M.latex_template = function(name, title)
  return table.concat({
    "\\begin{figure}[ht]",
    "  \\centering",
    string.format("  \\incfig{%s}", name),
    string.format("  \\caption{%s}", title),
    string.format("  \\label{fig:%s}", name),
    "\\end{figure}",
  }, "\n")
end

-- Merge user opts, ensure dirs/files exist
function M.setup(user_opts)
  -- merge in any overrides
  M = vim.tbl_deep_extend('force', M, user_opts or {})

  -- make sure user_dir and roots_file exist
  vim.fn.mkdir(M.user_dir, 'p')
  if vim.fn.filereadable(M.roots_file) == 0 then
    vim.fn.writefile({}, M.roots_file)
  end

  -- (optional) copy plugin’s template.svg into the user_dir if
  -- you want each user to be able to customize it:
  --[[
  local dest = M.user_dir .. '/template.svg'
  if vim.fn.filereadable(dest) == 0 then
    vim.fn.copy(M.template_svg, dest)
  end
  M.template_svg = dest
  --]]
end

return M

