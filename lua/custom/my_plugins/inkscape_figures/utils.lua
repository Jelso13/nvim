local M = {}

local function get_config(filetype, opts)
    opts = opts or {}
    local ft = filetype or vim.bo.filetype
    
    local config = {
        template_file = vim.fn.stdpath("config") .. "/lua/custom/my_plugins/inkscape_figures/template.svg",
    }

    if ft == "markdown" then
        -- Use the override dir if provided, otherwise default to "images/"
        config.figure_dir = opts.dir or (vim.fn.getcwd() .. "/images/")
        
        -- Use the override link path if provided, otherwise default to "images/"
        local link_path = opts.link_path or "images/"
        
        -- Ensure trailing slashes
        if config.figure_dir:sub(-1) ~= "/" then config.figure_dir = config.figure_dir .. "/" end
        if link_path:sub(-1) ~= "/" then link_path = link_path .. "/" end

        config.markup_template = "![%s](" .. link_path .. "%s.svg)\n" 
    else
        -- Default to LaTeX
        config.figure_dir = opts.dir or (vim.fn.getcwd() .. "/figures/")
        if config.figure_dir:sub(-1) ~= "/" then config.figure_dir = config.figure_dir .. "/" end
        
        config.markup_template = [[
\begin{figure}[ht]
    \centering
    \incfig{%s}
    \caption{%s}
    \label{fig:%s}
\end{figure}
]]
    end

    return config
end

local function ensure_dir_exists(dir)
    if vim.fn.isdirectory(dir) == 0 then
        vim.notify("Creating directory: " .. dir, vim.log.levels.INFO)
        vim.fn.mkdir(dir, "p")
    end
end

local function generate_markup(filename, title, filetype, opts)
    local config = get_config(filetype, opts)
    if filetype == "markdown" then
        return string.format(config.markup_template, title, filename)
    else
        return string.format(config.markup_template, filename, title, filename)
    end
end

M.get_config = get_config
M.ensure_dir_exists = ensure_dir_exists
M.generate_markup = generate_markup

return M



-- -- utils.lua
-- local M = {}
-- 
-- 
-- local function get_config()
--     local config = {
--         figure_dir = vim.fn.getcwd() .. "/figures/",
--         template_file = vim.fn.stdpath("config")
--             .. "/lua/custom/my_plugins/inkscape_figures/template.svg",
--         latex_template = [[
-- \begin{figure}[ht]
--     \centering
--     \incfig{%s}
--     \caption{%s}
--     \label{fig:%s}
-- \end{figure}
-- ]],
--     }
--     print("Template file path: " .. config.template_file) -- Add this line
--     -- Load user config (if available) -  You might want to expand this to load from a file
--     -- For simplicity, we'll leave this basic for now.  Consider using 'nvim-lua/plenary.nvim' for config management
--     return config
-- end
-- 
-- local function ensure_dir_exists(dir)
--     if vim.fn.isdirectory(dir) == 0 then
--         vim.notify("Creating directory: " .. dir, vim.log.levels.INFO)
--         vim.fn.mkdir(dir, "p")
--     end
-- end
-- 
-- local function find_svg_files(dir)
--     local files = {}
--     for file in vim.fn.glob(dir .. "/*.svg", 1, 1) do
--         table.insert(files, file)
--     end
--     table.sort(files, function(a, b)
--         return vim.fn.localtime(a) < vim.fn.localtime(b)
--     end) -- Sort by modified time
--     return files
-- end
-- 
-- local function beautify_name(name)
--     return string
--         .gsub(string.gsub(name, "_", " "), "-", " ")
--         :gsub("%w+", string.upper)
-- end
-- 
-- local function generate_latex(filename, title)
--     local config = get_config()
--     return string.format(config.latex_template, filename, title, filename)
-- end
-- 
-- M.get_config = get_config
-- M.ensure_dir_exists = ensure_dir_exists
-- M.find_svg_files = find_svg_files
-- M.beautify_name = beautify_name
-- M.generate_latex = generate_latex
-- 
-- return M
