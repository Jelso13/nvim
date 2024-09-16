require("conform").setup({
  formatters = {
    stylua = require("formatter.formatters.lua"),
    black = require("formatter.formatters.python")
  },
  formatters_by_ft = {
    lua = { "stylua", lsp_format = "fallback" },
    python = { "black", lsp_format = "fallback" },
    rust = { "rustfmt", lsp_format = "fallback" },
  }
})
