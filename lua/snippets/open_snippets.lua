local M = {}

M.open_snippet_file = function()
    local ft = vim.bo.filetype
    if ft == "" then
        vim.notify("No filetype detected!", vim.log.levels.WARN)
        -- go to the default snippet file
        return
    end

    local snippet_path = vim.fn.stdpath("config")
        .. "/lua/snippets/langs/"
        .. ft
        .. ".lua"
    if vim.fn.filereadable(snippet_path) == 0 then
        vim.notify("Snippet file does not exist! -> " .. snippet_path, vim.log.levels.WARN)
        vim.cmd("tabnew " .. vim.fn.stdpath("config") .. "/lua/snippets/langs/")
        return
    end
    vim.cmd("tabnew " .. snippet_path)
end

return M
