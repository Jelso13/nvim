local colorscheme = "tokyonight-night"

-- return an error if the colorscheme doesnt exist and prevents the rest of
-- the program from crashing
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
    vim.notify("colorscheme " .. colorscheme .. " not found!")
    return
end
