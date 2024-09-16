return {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "strict",  -- Enables strict type checking
        autoSearchPaths = true, -- find appropriate python files
        useLibraryCodeForTypes = true, -- more lenient with external types
        -- diagnosticMode = "openFilesOnly",  -- Only check open files
        diagnosticMode = "workspace",  -- all files in workspace (can be slow)
        -- Additional options to make Pyright behave like MyPy
        reportMissingTypeStubs = true,
        reportUnknownMemberType = true,
        reportUnknownArgumentType = true,
        reportUnknownVariableType = true,
        reportMissingTypeArgument = true,
        -- Override severity to show as warnings
        diagnosticSeverityOverrides = {
          reportMissingTypeStubs = "warning",
          reportUnknownMemberType = "warning",
          reportUnknownArgumentType = "warning",
          reportUnknownVariableType = "warning",
          reportMissingTypeArgument = "warning",
          reportUnusedImport = "warning",
        },
      },
    },
  },
}

