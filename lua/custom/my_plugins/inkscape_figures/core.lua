--[[
Engine
Responsible for heavy lifting and processing commands
--]]

-- core.lua
local M = {}
local utils = require("custom.my_plugins.inkscape_figures.utils")



-------------------------------------------------------------------------------
-- Helper Functions
-------------------------------------------------------------------------------


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


local function start_inkscape_job(filepath, filename)
    local cmd = { "inkscape", filepath }

    vim.fn.jobstart(cmd, {
        on_exit = function(job_id, exit_code, event_type)
            -- We wrap this in vim.schedule because callbacks run in the background,
            -- but Neovim API calls (like notify or buffer edits) must run on the main thread.
            vim.schedule(function()
                if exit_code == 0 then
                    vim.notify("Inkscape closed. Converting " .. filename .. " to PDF/LaTeX...", vim.log.levels.INFO)
                    M.convert_to_pdf_latex(filename)
                else
                    vim.notify("Inkscape closed with an error (code " .. exit_code .. ")", vim.log.levels.ERROR)
                end
            end)
        end
    })
end

-------------------------------------------------------------------------------
-- Core Actions
-------------------------------------------------------------------------------

local function create_figure(title, root)
    print("In create_figure with title: " .. title)
    local config = utils.get_config()
    local figure_dir = root or config.figure_dir
    utils.ensure_dir_exists(figure_dir)

    -- Format the filename
    local filename = string.lower(string.gsub(title, " ", "-")) .. ".svg"
    local filepath = figure_dir .. filename

    -- Minor fix: filereadable returns a number, so we check against 1, not "1"
    if vim.fn.filereadable(filepath) == 1 then
        vim.notify("File already exists: " .. filepath, vim.log.levels.ERROR)
        return
    end

    -- Copy the template
    vim.fn.system("cp " .. vim.fn.shellescape(config.template_file) .. " " .. vim.fn.shellescape(filepath))
    vim.notify("Copying template to: " .. filepath, vim.log.levels.INFO)

    -- Generate and insert the LaTeX code immediately
    local base_filename = string.sub(filename, 1, #filename - 4) -- Remove ".svg"
    local latex_code = utils.generate_latex(base_filename, title)
    insert_latex(latex_code)

    -- Open Inkscape asynchronously. 
    -- When you close Inkscape, this will automatically trigger M.convert_to_pdf_latex!
    start_inkscape_job(filepath, base_filename)
end

local function edit_figure(figure_name)
    -- 1. Get the directory from config
    local config = utils.get_config()
    local figure_dir = config.figure_dir

    -- 2. Construct the full file path to the SVG
    local filepath = figure_dir .. figure_name .. ".svg"

    -- 3. Verify the file actually exists before trying to open it
    if vim.fn.filereadable(filepath) == 0 then
        vim.notify("Could not find figure to edit: " .. filepath, vim.log.levels.ERROR)
        return
    end

    vim.notify("Opening Inkscape to edit: " .. figure_name, vim.log.levels.INFO)

    -- 4. Open Inkscape asynchronously.
    -- We pass the full filepath to open it, and the base figure_name for the auto-converter!
    start_inkscape_job(filepath, figure_name)
end


local function convert_to_pdf_latex(filename)
    -- Your existing convert_to_pdf_latex logic goes here
    print("in convert_to_pdf_latex with filename: " .. filename)
    local config = utils.get_config()
    local figure_dir = config.figure_dir

    -- Combine the directory, filename, and extension
    local svg_filepath = figure_dir .. filename .. ".svg"
    local pdf_filepath = figure_dir .. filename .. ".pdf"

    if vim.fn.filereadable(svg_filepath) == 0 then
        vim.notify("Could not find SVG to convert: " .. svg_filepath, vim.log.levels.ERROR)
        return
    end
    local cmd = string.format(
        'inkscape %s --export-type="pdf" --export-filename=%s --export-latex',
        vim.fn.shellescape(svg_filepath),
        vim.fn.shellescape(pdf_filepath)
    )

    vim.fn.system(cmd)

    if vim.v.shell_error == 0 then
        vim.notify("Successfully converted " .. filename, vim.log.levels.INFO)
    else
        vim.notify("Failed to convert " .. filename, vim.log.levels.ERROR)
    end

end

-------------------------------------------------------------------------------
-- Mode Handlers
-------------------------------------------------------------------------------

function M.handle_normal_mode()
    local current_line = vim.api.nvim_get_current_line()
    local in_figure = string.match(current_line, "\\incfig{(.-)}")
    if in_figure then
        vim.notify("Editing " .. in_figure .. " ...", vim.log.levels.INFO)
        M.edit_figure(in_figure)
    elseif string.match(current_line, "^%s*$") then
        local figure_name = vim.fn.input("Enter new figure name: ")
        if figure_name and figure_name ~= "" then
            M.create_figure(figure_name)
        else
            vim.notify("Figure creation cancelled.", vim.log.levels.WARN)
        end
    else
        local figure_name = vim.trim(current_line)
        vim.api.nvim_set_current_line("")
        M.create_figure(figure_name)
    end
end

function M.handle_visual_mode()
    -- 1. Escape visual mode to save marks
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)

    -- 2. Get the marks
    local start_pos = vim.api.nvim_buf_get_mark(0, "<")
    local end_pos = vim.api.nvim_buf_get_mark(0, ">")

    -- Check if selection spans multiple lines
    if start_pos[1] ~= end_pos[1] then
        vim.notify("Figure name cannot span multiple lines!", vim.log.levels.ERROR)
        return
    end

    -- 3. Setup the coordinates
    local row = start_pos[1] - 1
    local start_col = start_pos[2]
    local end_col = end_pos[2] + 1 

    -- 4. Extract the text
    local text_table = vim.api.nvim_buf_get_text(0, row, start_col, row, end_col, {})
    local selected_text = text_table[1]

    print("DEBUG: Extracted text is -> " .. selected_text)

    -- 5. Process the extracted text
    local in_figure = string.match(selected_text, "\\incfig{(.-)}")

    if in_figure then
        vim.notify("Editing " .. in_figure .. " ...", vim.log.levels.INFO)
        M.edit_figure(in_figure)
    else
        local figure_name = string.gsub(vim.trim(selected_text), " ", "-")
        figure_name = string.gsub(vim.trim(figure_name), "_", "-")
        vim.api.nvim_buf_set_text(0, row, start_col, row, end_col, {""})
        M.create_figure(figure_name)
    end
end

function M.handle_insert_mode()
    -- Get the full text of the current line
    local current_line = vim.api.nvim_get_current_line()

    -- 1. Check if the line is completely blank (just spaces or empty)
    if string.match(current_line, "^%s*$") then
        -- Prompt the user
        local figure_name = vim.fn.input("Enter new figure name: ")

        if figure_name and vim.trim(figure_name) ~= "" then
            -- Format the input just in case they typed spaces/underscores
            figure_name = string.gsub(vim.trim(figure_name), " ", "-")
            figure_name = string.gsub(figure_name, "_", "-")

            M.create_figure(figure_name)
        else
            vim.notify("Figure creation cancelled.", vim.log.levels.WARN)
        end
    else
        -- 2. The line has text! Use the whole line as the name.
        local figure_name = vim.trim(current_line)

        -- Replace spaces and underscores with dashes
        -- Notice how we pass 'figure_name' into the second gsub so we don't overwrite our progress!
        figure_name = string.gsub(figure_name, " ", "-")
        figure_name = string.gsub(figure_name, "_", "-")

        -- Clear the line completely so the LaTeX snippet drops in cleanly
        vim.api.nvim_set_current_line("")

        -- Create the figure
        M.create_figure(figure_name)
    end

    -- Safely return the user to insert mode so they can keep typing
    vim.cmd("startinsert")
end


-------------------------------------------------------------------------------
-- Exports
-------------------------------------------------------------------------------
M.create_figure = create_figure
M.edit_figure = edit_figure
M.convert_to_pdf_latex = convert_to_pdf_latex

return M



-- -- core.lua
-- local M = {}
-- 
-- local utils = require("custom.my_plugins.inkscape_figures.utils")
-- 
-- local function insert_latex(latex_code)
--     local current_line = vim.api.nvim_get_current_line()
--     local cursor_pos = vim.api.nvim_win_get_cursor(0)
-- 
--     -- Split the latex_code into a table of lines
--     local latex_lines = vim.split(latex_code, "\n")
-- 
--     -- Insert the lines
--     vim.api.nvim_buf_set_lines(
--         0,
--         cursor_pos[1],
--         cursor_pos[1],
--         false,
--         latex_lines
--     )
-- 
--     -- Move cursor to the line after the inserted code
--     vim.api.nvim_win_set_cursor(
--         0,
--         { cursor_pos[1] + #latex_lines, cursor_pos[2] }
--     )
-- end
-- 
-- local function create_figure(title, root)
--     local config = utils.get_config()
--     local figure_dir = root or config.figure_dir
--     utils.ensure_dir_exists(figure_dir)
-- 
--     local filename = string.lower(string.gsub(title, " ", "-")) .. ".svg"
--     local filepath = figure_dir .. filename
-- 
--     if vim.fn.filereadable(filepath) == "1" then
--         vim.notify("File already exists: " .. filepath, vim.log.levels.ERROR)
--         return
--     end
-- 
--     vim.fn.system(
--         "cp "
--             .. vim.fn.shellescape(config.template_file)
--             .. " "
--             .. vim.fn.shellescape(filepath)
--     )
--     -- display what command is being run
--     vim.notify("Copying template to: " .. filepath, vim.log.levels.INFO)
-- 
--     local response = vim.fn.system(
--         "inkscape "
--             .. vim.fn.shellescape(filepath)
--             .. " &"
--     ) -- Open Inkscape in the background
-- 
--     if vim.v.shell_error ~= 0 then
--         vim.notify("Failed to open Inkscape: " .. response, vim.log.levels.ERROR)
--         return
--     end
-- 
--     local latex_code =
--         utils.generate_latex(string.sub(filename, 1, #filename - 4), title) -- Remove ".svg"
--     -- print(latex_code) -- Remove this line
--     -- vim.fn.setreg("+", latex_code) -- Optionally keep this if you still want it on the clipboard
--     insert_latex(latex_code)
-- end
-- 
-- local function edit_figure(root)
--     local config = utils.get_config()
--     local figure_dir = root or config.figure_dir
--     local files = utils.find_svg_files(figure_dir)
--     local names = {}
--     for _, file in ipairs(files) do
--         table.insert(
--             names,
--             utils.beautify_name(vim.fn.fnamemodify(file, ":t:r"))
--         ) -- Filename without extension
--     end
-- 
--     if #files == 0 then
--         vim.notify("No SVG files found in: " .. figure_dir, vim.log.levels.WARN)
--         return
--     end
-- 
--     -- Picker logic (replace with your preferred method)
--     local picker = require("custom.my_plugins.inkscape_figures.picker")
--     local index, selected = picker.pick(names)
-- 
--     if selected then
--         local filepath = files[index]
--         vim.fn.system("inkscape " .. vim.fn.shellescape(filepath) .. " &")
--         local latex_code = utils.generate_latex(
--             vim.fn.fnamemodify(filepath, ":t:r"),
--             utils.beautify_name(vim.fn.fnamemodify(filepath, ":t:r"))
--         )
--         -- vim.fn.setreg("+", latex_code) -- Optionally keep this
--         insert_latex(latex_code)
--     end
-- end
-- 
-- local function convert_to_pdf_latex(filename) -- Now it's just filename
--   local config = utils.get_config()
--   local figure_dir = config.figure_dir
-- 
--   vim.notify("trying to run in convert")
-- 
--   -- Construct the full file paths
--   local svg_filepath = vim.fn.expand(figure_dir .. filename .. ".svg")
--   local pdf_filepath = vim.fn.expand(figure_dir .. filename .. ".pdf")
-- 
--   vim.notify("Converting: " .. svg_filepath, vim.log.levels.INFO)
--   vim.notify("to: " .. pdf_filepath, vim.log.levels.INFO)
-- 
--   -- Check if the SVG file exists
--   if vim.fn.filereadable(svg_filepath) == "0" then
--     vim.notify("SVG file not found: " .. svg_filepath, vim.log.levels.ERROR)
--     return
--   end
-- 
--   local cmd = string.format(
--     'inkscape %s --export-type="pdf" --export-filename=%s --export-latex',
--     vim.fn.shellescape(svg_filepath),
--     vim.fn.shellescape(pdf_filepath) -- Use pdf_filepath for export-filename
--   )
--   vim.notify("Running command: " .. cmd, vim.log.levels.INFO)
--   vim.fn.system(cmd)
-- end
-- 
-- M.create_figure = create_figure
-- M.edit_figure = edit_figure
-- M.convert_to_pdf_latex = convert_to_pdf_latex
-- 
-- return M
