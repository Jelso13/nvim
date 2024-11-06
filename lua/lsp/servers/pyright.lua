-- all the options are at https://github.com/microsoft/pyright/blob/main/docs/configuration.md
-- lua/lsp/servers/pyright.lua
return function(capabilities)
    local nvim_lsp = require("lspconfig")
    nvim_lsp["pyright"].setup({
        capabilities = capabilities,
        settings = {
            python = {
                analysis = {
                    typeCheckingMode = "off", -- Looser checking mode than "strict"
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    diagnosticMode = "workspace", -- Check all files in the workspace

                    -- Report settings to reduce false positives
                    reportMissingTypeStubs = true, -- You may want to keep this to detect missing type stubs
                    reportUnknownMemberType = false, -- Disable for standard library functions like list.append
                    reportUnknownArgumentType = false, -- Less noise for unknown arguments
                    reportUnknownVariableType = false, -- Less noise for unknown variable types
                    reportMissingTypeArgument = true, -- Useful to detect missing generics (keep it on)
                    reportImportCycles = true, -- reports if there are circular imports in the code
                    reportUnusedCallResult = true, -- reports if a function return is ignored
                    reportUnusedImport = false, -- reports if a function return is ignored
                    reportUnusedVariable = false, -- reports if a function return is ignored

                    -- Override severity to show as warnings
                    diagnosticSeverityOverrides = {
                        reportUnusedCallResult = "warning",
                        reportImportCycles = "warning",
                        reportMissingTypeStubs = "warning",
                        reportUnknownMemberType = "none", -- Completely silence these
                        reportUnknownArgumentType = "none", -- Completely silence these
                        reportUnknownVariableType = "none", -- Completely silence these
                        reportMissingTypeArgument = "warning",
                        -- reportMissingParameterType = "warning",
                        reportMissingImports = "none",
                        reportUnusedImport = "none",
                        reportUnusedVariable = "none",
                    },
                },
            },
        },
    })
end


-- return {
--   settings = {
--     python = {
--       analysis = {
--         typeCheckingMode = "strict",  -- Enables strict type checking
--         autoSearchPaths = true, -- find appropriate python files
--         useLibraryCodeForTypes = true, -- more lenient with external types
--         -- diagnosticMode = "openFilesOnly",  -- Only check open files
--         diagnosticMode = "workspace",  -- all files in workspace (can be slow)
--         -- Additional options to make Pyright behave like MyPy
--         reportMissingTypeStubs = true,
--         reportUnknownMemberType = false,
--         reportUnknownArgumentType = true,
--         reportUnknownVariableType = true,
--         reportMissingTypeArgument = true,
--         -- Override severity to show as warnings
--         diagnosticSeverityOverrides = {
--           reportMissingTypeStubs = "warning",
--           reportUnknownMemberType = "warning",
--           reportUnknownArgumentType = "warning",
--           reportUnknownVariableType = "warning",
--           reportMissingTypeArgument = "warning",
--           reportMissingParameterType = "warning",
--           reportMissingImports = "warning",
--           reportUnusedImport = "warning",
--           reportUnusedVariable = "warning",
--         },
--       },
--     },
--   },
-- }
-- 
