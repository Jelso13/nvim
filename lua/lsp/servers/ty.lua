-- Astral's ty: the Python type checker. Ruff handles linting/formatting.
-- cmd, filetypes and root_markers already ship with nvim-lspconfig (lsp/ty.lua),
-- so only the settings need overriding here.
--
-- Per-rule severity overrides (the replacement for pyright's
-- diagnosticSeverityOverrides) belong in a project's ty.toml or pyproject.toml
-- under [tool.ty.rules]. A `rules` table can also go alongside the keys below
-- if a global override is ever wanted.
return {
    settings = {
        ty = {
            -- valid: "off" | "openFilesOnly" | "workspace"
            diagnosticMode = "workspace",
            inlayHints = {
                variableTypes = true,
                callArgumentNames = true,
            },
        }
    }
}
