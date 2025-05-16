local M = {}


local uv = vim.loop

--- Create the SVG by filtering the current line through inkscape-figures.
--- @return string? svg_path  The full path to the new SVG, or nil on error.
local function create_svg()
  local name = vim.api.nvim_get_current_line()
  if name == "" then
    vim.notify("No figure name on current line", vim.log.levels.WARN)
    return nil
  end

  local root = vim.b.vimtex and vim.b.vimtex.root
  if not root then
    vim.notify("vimtex.root not set", vim.log.levels.ERROR)
    return nil
  end

  local figures_dir = root .. "/figures"
  -- make sure directory exists
  if vim.fn.isdirectory(figures_dir) == 0 then
    vim.fn.mkdir(figures_dir, "p")
  end

  -- run the create command synchronously so that the file exists immediately
  local cmd = {
    "inkscape-figures",
    "create",
    name,
    figures_dir .. "/"
  }
  local result = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("inkscape-figures failed: " .. table.concat(result, "\n"),
               vim.log.levels.ERROR)
    return nil
  end

  -- write buffer so that changes persist
  vim.cmd("write")

  return figures_dir .. "/" .. name .. ".svg"
end

--- Export an SVG to PDF+LaTeX asynchronously using Inkscape.
--- @param svg_path string  Full path to the source SVG.
--- @param callback fun(success: boolean, msg: string) Called on job exit.
local function export_svg(svg_path, callback)
  local pdf_path = svg_path:gsub("%.svg$", ".pdf")
  local args = {
    svg_path,
    "--export-type=pdf",
    "--export-latex",
    "--export-filename=" .. pdf_path,
  }

  vim.fn.jobstart(
    vim.tbl_flatten({ "inkscape", args }),
    {
      on_stdout = function(_, data)
        if data then vim.log:info(table.concat(data, "\n")) end
      end,
      on_stderr = function(_, data)
        if data then vim.log:warn(table.concat(data, "\n")) end
      end,
      on_exit = function(_, code)
        if code == 0 then
          callback(true, pdf_path)
        else
          callback(false, "Inkscape exited with code " .. code)
        end
      end,
    }
  )
end

--- Public function: create the figure and then export it.
function M.create_figure()
  local svg = create_svg()
  if not svg then
    return
  end

  export_svg(svg, function(success, msg)
    if success then
      vim.notify("Exported PDF+LaTeX to " .. msg, vim.log.levels.INFO)
    else
      vim.notify("Failed to export SVG: " .. msg, vim.log.levels.ERROR)
    end
  end)
end


-- --- Create a new figure via inkscape-figures, filter the current line through it, then save.
-- function M.create_figure()
--   local name = vim.api.nvim_get_current_line()
--   if name == "" then
--     vim.notify("No figure name on current line", vim.log.levels.WARN)
--     return
--   end
-- 
--   local root = vim.b.vimtex and vim.b.vimtex.root
--   if not root then
--     vim.notify("vimtex.root not set", vim.log.levels.ERROR)
--     return
--   end
-- 
--   -- 1) Filter the current line through inkscape-figures create …
--   --    This is the equivalent of Vimscript’s:  .!inkscape-figures create … 
--   local cmd = string.format(
--     [[silent execute '.!inkscape-figures create "%s" "%s/figures/"']],
--     name, root
--   )
--   vim.cmd(cmd)
-- 
--   -- 2) Write the buffer
--   vim.cmd("write")
-- end

--- Edit all figures via inkscape-figures in the background, then redraw
function M.edit_figures()
  local root = vim.b.vimtex and vim.b.vimtex.root
  if not root then
    vim.notify("vimtex.root not set", vim.log.levels.ERROR)
    return
  end

  local cmd = string.format(
    'silent !inkscape-figures edit "%s/figures/" > /dev/null 2>&1 &',
    root
  )
  vim.cmd(cmd)
  vim.cmd("redraw!")
end

return M

