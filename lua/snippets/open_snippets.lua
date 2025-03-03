local M = {}

M.open_snippet_file = function()
    local ft = vim.bo.filetype
    if ft == "" then
        vim.notify("No filetype detected!", vim.log.levels.WARN)
        return
    end

    local snippet_path = vim.fn.stdpath("config")
        .. "/lua/snippets/langs/"
        .. ft
        .. ".lua"
    if vim.fn.filereadable(snippet_path) == 0 then
        vim.notify("Snippet file does not exist!", vim.log.levels.WARN)
        return
    end
    vim.cmd("tabnew " .. snippet_path)
end

return M
