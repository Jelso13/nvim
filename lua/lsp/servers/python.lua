return {
	settings = {
		python = {
			analysis = {
				typeCheckingMode = "strict",  -- Enables strict type checking
				autoSearchPaths = true, -- find appropriate python files
				useLibraryCodeForTypes = true, -- more lenient with external types
				diagnosticMode = "openFilesOnly",  -- Only check open files
                -- Additional options to make Pyright behave like MyPy
                reportMissingTypeStubs = true,
                reportUnknownMemberType = true,
                reportUnknownArgumentType = true,
                reportUnknownVariableType = true,
                reportMissingTypeArgument = true,
			},
		},
	},
}
