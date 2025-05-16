-- core.lua
local M = {}

local utils = require("custom.my_plugins.inkscape_figures.utils")

local function insert_latex(latex_code)
    local current_line = vim.api.nvim_get_current_line()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)

    -- Split the latex_code into a table of lines
    local latex_lines = vim.split(latex_code, "\n")

    -- Insert the lines
    vim.api.nvim_buf_set_lines(
        0,
        cursor_pos[1],
        cursor_pos[1],
        false,
        latex_lines
    )

    -- Move cursor to the line after the inserted code
    vim.api.nvim_win_set_cursor(
        0,
        { cursor_pos[1] + #latex_lines, cursor_pos[2] }
    )
end

local function create_figure(title, root)
    local config = utils.get_config()
    local figure_dir = root or config.figure_dir
    utils.ensure_dir_exists(figure_dir)

    local filename = string.lower(string.gsub(title, " ", "-")) .. ".svg"
    local filepath = figure_dir .. "/" .. filename

    if vim.fn.filereadable(filepath) == "1" then
        vim.notify("File already exists: " .. filepath, vim.log.levels.ERROR)
        return
    end

    vim.fn.system(
        "cp "
            .. vim.fn.shellescape(config.template_file)
            .. " "
            .. vim.fn.shellescape(filepath)
    )
    vim.fn.system("inkscape " .. vim.fn.shellescape(filepath) .. " &") -- Open Inkscape in background

    local latex_code =
        utils.generate_latex(string.sub(filename, 1, #filename - 4), title) -- Remove ".svg"
    -- print(latex_code) -- Remove this line
    -- vim.fn.setreg("+", latex_code) -- Optionally keep this if you still want it on the clipboard
    insert_latex(latex_code)
end

local function edit_figure(root)
    local config = utils.get_config()
    local figure_dir = root or config.figure_dir
    local files = utils.find_svg_files(figure_dir)
    local names = {}
    for _, file in ipairs(files) do
        table.insert(
            names,
            utils.beautify_name(vim.fn.fnamemodify(file, ":t:r"))
        ) -- Filename without extension
    end

    if #files == 0 then
        vim.notify("No SVG files found in: " .. figure_dir, vim.log.levels.WARN)
        return
    end

    -- Picker logic (replace with your preferred method)
    local picker = require("custom.my_plugins.inkscape_figures.picker")
    local index, selected = picker.pick(names)

    if selected then
        local filepath = files[index]
        vim.fn.system("inkscape " .. vim.fn.shellescape(filepath) .. " &")
        local latex_code = utils.generate_latex(
            vim.fn.fnamemodify(filepath, ":t:r"),
            utils.beautify_name(vim.fn.fnamemodify(filepath, ":t:r"))
        )
        -- vim.fn.setreg("+", latex_code) -- Optionally keep this
        insert_latex(latex_code)
    end
end

local function convert_to_pdf_latex(filename) -- Now it's just filename
  local config = utils.get_config()
  local figure_dir = config.figure_dir

  -- Construct the full file paths
  local svg_filepath = vim.fn.expand(figure_dir .. filename .. ".svg")
  local pdf_filepath = vim.fn.expand(figure_dir .. filename .. ".pdf")

  vim.notify("Converting: " .. svg_filepath, vim.log.levels.INFO)
  vim.notify("to: " .. pdf_filepath, vim.log.levels.INFO)

  -- Check if the SVG file exists
  if vim.fn.filereadable(svg_filepath) == "0" then
    vim.notify("SVG file not found: " .. svg_filepath, vim.log.levels.ERROR)
    return
  end

  local cmd = string.format(
    'inkscape %s --export-type="pdf" --export-filename=%s --export-latex',
    vim.fn.shellescape(svg_filepath),
    vim.fn.shellescape(pdf_filepath) -- Use pdf_filepath for export-filename
  )
  vim.notify("Running command: " .. cmd, vim.log.levels.INFO)
  vim.fn.system(cmd)
end

M.create_figure = create_figure
M.edit_figure = edit_figure
M.convert_to_pdf_latex = convert_to_pdf_latex

return M
