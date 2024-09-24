

-- return function(capabilities)
--     local nvim_lsp = require("lspconfig")
--     nvim_lsp["rust-analyzer"].setup({
--         capabilities = capabilities,
--         settings = {
--           ['rust-analyzer'] = {
--             diagnostics = {
--               enable = false;
--             }
--           }
--         }
--     })
-- end




local util = require("lspconfig/util")
return {
    filetypes = {"rust"},
    root_dir = util.root_pattern("Cargo.toml"),
    settings = {
        ["rust-analyzer"] = {
            diagnostics = {
              enable = true;
            }
        },
        single_file_support = true,
    },
}
