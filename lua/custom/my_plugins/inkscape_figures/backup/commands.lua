
local api = vim.api
local uv  = vim.loop
local cfg = require('custom.my_plugins.inkscape_figures.config')
local util = require('custom.my_plugins.inkscape_figures.util')
local roots = require('custom.my_plugins.inkscape_figures.roots')

local M = {}

-- :FigCreate {title} [root]
function M.create(opts)
  local title = opts.fargs[1] or ''
  assert(#title > 0, 'FigCreate requires a title')
  local root = opts.fargs[2] or vim.fn.getcwd()

  -- sanitize and compute paths
  title = vim.trim(title)
  local name = title:gsub('%s+', '-'):lower()
  local svg  = root .. '/' .. name .. '.svg'

  vim.fn.mkdir(root, 'p')
  if uv.fs_stat(svg) then
    api.nvim_err_writeln('Figure already exists: ' .. svg)
    return
  end

  -- **use util.copy_file instead of vim.fn.copy**
  -- local ok, err = util.copy_file(cfg.template_svg, svg)
  -- vim.fs.cp(src, dst
  -- local ok, err = vim.fs.cp(cfg.template_svg, svg)
  local Path = require('plenary.path')
  local ok, err = Path:new(cfg.template_svg):copy({ destination = svg })
  if not ok then
    api.nvim_err_writeln("inkscape_figures: failed to copy template.svg → " .. err)
    return
  end

  roots.add_root(root)
  util.launch_inkscape(svg)

  -- print and copy the LaTeX snippet
  local latex = cfg.latex_template(name, title)
  util.copy_to_clipboard(latex)
  -- ... same as before up through util.copy_to_clipboard()
  local latex = cfg.latex_template(name, title)
  util.copy_to_clipboard(latex)

  -- 1) Split into lines
  local lines = vim.split(latex, "\n", { plain = true })

  -- 2) Insert into buffer at cursor
  local bufnr = api.nvim_get_current_buf()
  local row    = api.nvim_win_get_cursor(0)[1]
  api.nvim_buf_set_lines(bufnr, row, row, false, lines)

  -- 3) Move cursor to the end of the inserted snippet
  api.nvim_win_set_cursor(0, { row + #lines, 0 })

  -- 4) compile the svg with inkscape -> inkscape input.svg --export-type="pdf" --export-filename="output.pdf" --export-latex
  local cmd = string.format(
    'inkscape %s --export-type="pdf" --export-filename="%s/%s.pdf" --export-latex',
    svg,
    root,
    name
  )
    local handle = uv.spawn("sh", {
        args = { "-c", cmd },
        stdio = { nil, nil, nil }
    }, function(code)
        if code ~= 0 then
        api.nvim_err_writeln("inkscape_figures: failed to compile " .. name .. ": " .. code)
        end
    end)
end


-- :FigEdit [root]
function M.edit(opts)
  local root = opts.fargs[1] or vim.fn.getcwd()
  roots.add_root(root)

  -- find .svg files, sort by mtime desc
  local files = vim.fn.globpath(root, '*.svg', false, true)
  table.sort(files, function(a,b)
    return vim.fn.getftime(a) > vim.fn.getftime(b)
  end)

  if #files == 0 then
    api.nvim_err_writeln('No SVGs in ' .. root)
    return
  end

  -- use builtin inputlist as a simple picker
  local choices = { 'Select figure:' }
  for i,f in ipairs(files) do
    choices[#choices+1] = string.format('%2d. %s', i, vim.fn.fnamemodify(f, ':t:r'))
  end
  local idx = vim.fn.inputlist(choices)
  if idx < 1 or idx > #files then
    return
  end

  local svg = files[idx]
  util.launch_inkscape(svg)

  local name = vim.fn.fnamemodify(svg, ':t:r')
  local latex = cfg.latex_template(name, util.beautify(name))
  util.copy_to_clipboard(latex)
end

function M.setup_commands()
  api.nvim_create_user_command('FigCreate', M.create, { nargs = '+' })
  api.nvim_create_user_command('FigEdit',   M.edit,   { nargs = '?' })
end

return M
