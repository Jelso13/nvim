-- lua/config/lsp/init.lua
local M = {}

function M.setup()
    local lspconfig = require('lspconfig')

    print("Hello from python.lua "..vim.bo.filetype)
    -- Conditionally load language-specific LSP configs
    if vim.bo.filetype == "python" then
        require('config.lsp.python')
    end
    -- Add similar conditions for other languages
end

return M
