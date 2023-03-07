-- configuration for the lsp

local lsp = require('lsp-zero')

lsp.preset('recommended')

-- the language servers I want installed
lsp.ensure_installed({
    'lua_ls', -- lua
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


-- ############################ CMP section ###################################

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

-- stuff from nerd fonts
--   פּ ﯟ   some other good icons
local kind_icons = {
  Text = "", Method = "m", Function = "", Constructor = "", Field = "",
  Variable = "", Class = "", Interface = "", Module = "", Property = "",
  Unit = "", Value = "", Enum = "", Keyword = "", Snippet = "", Color = "",
  File = "", Reference = "", Folder = "", EnumMember = "", Constant = "",
  Struct = "", Event = "", Operator = "", TypeParameter = "",
}

-- sets the bindings for completion
local cmp_mappings = lsp.defaults.cmp_mappings({
    -- select the previous item in the list
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    -- select the next item in the list
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    -- confirm the current selection
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
})

local cmp_sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
})

local cmp_formatting = {
    -- gives the format of each field - the kind or symbol, abbreviation and source location
    fields = {
        "kind",
        "abbr",
        "menu"
    },
    format = function(entry, vim_item)
        -- Kind icons format
        -- vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
        vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
        vim_item.menu = ({
            nvim_lsp = "[LSP]",
            nvim_lua = "[NVIM_LUA]",
            luasnip = "[Snippet]", -- from luasnip
            buffer = "[Buffer]", -- from current file
            path = "[Path]", -- from buffer
        })[entry.source.name]
        return vim_item
    end,
}

-- disable completion with tab
-- this helps with copilot setup
cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
    mapping = cmp_mappings,
    sources = cmp_sources,
    formatting = cmp_formatting,
})

-- ########################## lsp config section ##############################

-- no idea what this does
lsp.set_preferences({
    -- suggest language servers when entering a filetype
    suggest_lsp_servers = true,
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
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts, { desc = "go definition" })
    -- get a definition on hover
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts, { desc = "Get info" })
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
    -- conflict with ctrl-backspace
    -- vim.keymap.set("n", "<leader>vwh", vim.lsp.buf.signature_help, opts)

    -- format from language server protocol
    vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "format file" })
    vim.keymap.set("v", "<leader>lf", vim.lsp.buf.format, { desc = "format" })

end)

lsp.nvim_workspace()

lsp.setup()

vim.diagnostic.config({
    virtual_text = true,
})
