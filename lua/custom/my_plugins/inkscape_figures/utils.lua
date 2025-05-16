-- utils.lua
local M = {}

local function get_config()
  local config = {
    figure_dir = vim.fn.getcwd() .. "/figures/",
    template_file = vim.fn.stdpath("config") .. "/lua/custom/my_plugins/inkscape_figures/template.svg",
    latex_template = [[
\begin{figure}[ht]
    \centering
    \incfig{%s}
    \caption{%s}
    \label{fig:%s}
\end{figure}
]]
  }
  print("Template file path: " .. config.template_file) -- Add this line
  -- Load user config (if available) -  You might want to expand this to load from a file
  -- For simplicity, we'll leave this basic for now.  Consider using 'nvim-lua/plenary.nvim' for config management
  return config
end


local function ensure_dir_exists(dir)
  if vim.fn.isdirectory(dir) == '0' then
    vim.fn.mkdir(dir, 'p')
  end
end

local function find_svg_files(dir)
  local files = {}
  for file in vim.fn.glob(dir .. "/*.svg", 1, 1) do
    table.insert(files, file)
  end
  table.sort(files, function(a, b) return vim.fn.localtime(a) < vim.fn.localtime(b) end) -- Sort by modified time
  return files
end

local function beautify_name(name)
  return string.gsub(string.gsub(name, '_', ' '), '-', ' '):gsub('%w+', string.upper)
end

local function generate_latex(filename, title)
  local config = get_config()
  return string.format(config.latex_template, filename, title, filename)
end

M.get_config = get_config
M.ensure_dir_exists = ensure_dir_exists
M.find_svg_files = find_svg_files
M.beautify_name = beautify_name
M.generate_latex = generate_latex

return M
