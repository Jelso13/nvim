return {
    command = "stylua",
    -- inherit = false,
    prepend_args = {
        "--indent-type", "Spaces", -- Change to spaces
        "--indent-width", "4",
        "--column-width", "80",
        "--quote-style", "ForceDouble",
    },
}

