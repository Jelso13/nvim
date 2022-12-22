-- configuration for the lsp

local lsp = require('lsp-zero')

lsp.preset('recommended')

-- the language servers I want installed
lsp.ensure_installed({
    'sumneko_lua', -- lua
    'rust_analyzer', -- rust
    'pyright', -- python
    'eslint', -- javascript
    'clangd', -- c++
    'bashls', -- bash
    -- 'dartls',		-- dart
    'texlab', -- latex
})

-- Fix Undefined global 'vim'
lsp.configure('sumneko_lua', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    -- select the previous item in the list
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    -- select the next item in the list
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    -- confirm the current selection
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})


-- disable completion with tab
-- this helps with copilot setup
cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

-- no idea what this does
lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {}
    -- sign_icons = {
    --     error = 'E',
    --     warn = 'W',
    --     hint = 'H',
    --     info = 'I'
    -- }
})

-- when attached to a buffer that has a corresponding lsp
lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    if client.name == "eslint" then
        vim.cmd.LspStop('eslint')
        return
    end

    -- only use these remaps for the current lsp specific buffer
    --
    -- go to definition
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    -- get a definition on hover
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
    -- conflict with ctrl-backspace
    -- vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true,
})
