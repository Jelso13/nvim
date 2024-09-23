
local util = require("lspconfig/util")

return function(capabilities)
    local nvim_lsp = require("lspconfig")
    nvim_lsp["lua_ls"].setup({
        capabilities = capabilities,
        filetypes = {"rust"},
        root_dir = util.root_pattern("Cargo.toml"),
        settings = {
            ["rust-analyzer"] = {
                cargo = {
                    allFeatures = true, -- helps with autocomplete with crates
                }
            }
        }
    })
end




