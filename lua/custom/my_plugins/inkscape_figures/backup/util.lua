
local uv = vim.loop
local cfg = require('custom.my_plugins.inkscape_figures.config')

local M = {}

function M.launch_inkscape(path)
  -- non‐blocking
  uv.spawn('inkscape', { args = { path } }, function() end)
end

function M.beautify(name)
  return name
    :gsub('_', ' ')
    :gsub('-', ' ')
    :gsub('^%l', string.upper)
end

function M.copy_to_clipboard(text)
  -- Linux: xclip; macOS: pbcopy; fallback: Vim register
  local cmd = vim.fn.executable('pbcopy') == 1 and 'pbcopy'
            or vim.fn.executable('xclip') == 1 and 'xclip -selection clipboard'
            or nil
  if cmd then
    local handle = io.popen(cmd, 'w')
    handle:write(text)
    handle:close()
  else
    vim.fn.setreg('+', text)
  end
end

function M.recompile(svg_path)
  local stem = svg_path:match("([^/]+)%.svg$")
  local pdf = svg_path:gsub('%.svg$', '.pdf')

  -- determine Inkscape version if needed; for simplicity always
  -- use the >=1.0 syntax:
  local args = {
    svg_path,
    '--export-area-page',
    '--export-dpi', '300',
    '--export-type=pdf',
    '--export-latex',
    '--export-filename', pdf,
  }
  uv.spawn('inkscape', { args = args }, function(code)
    if code ~= 0 then
      vim.schedule(function()
        vim.notify("inkscape conversion failed: "..code, vim.log.levels.ERROR)
      end)
    else
      local latex = cfg.latex_template(stem, M.beautify(stem))
      M.copy_to_clipboard(latex)
      vim.schedule(function()
        vim.notify("Recompiled "..svg_path.." and copied LaTeX.", vim.log.levels.INFO)
      end)
    end
  end)
end

return M
