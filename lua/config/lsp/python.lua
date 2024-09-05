-- lua/config/lsp/python.lua
local lspconfig = require('lspconfig')
print("HELELELELE Hello from python.lua")

-- Setup Python LSP
lspconfig.pyright.setup {
    -- Add any specific settings for Pyright here
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "strict",  -- Example of a specific setting
            },
        },
    },
}
