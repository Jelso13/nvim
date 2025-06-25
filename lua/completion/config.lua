-- See `:help cmp`
local cmp = require("cmp")
local luasnip = require("luasnip")
-- luasnip.config.setup({})

vim.api.nvim_set_hl(0, "CmpItemKindCopilot", {fg ="#6CC644"})
local kind_icons = {
    Text = "",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = "󰇽",
    Variable = "󰂡",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "",
    Event = "",
    Operator = "󰆕",
    TypeParameter = "󰅲",
    Copilot = "",
}

vim.opt.completeopt = { "menu,menuone,noinsert" }
vim.opt.shortmess:append("c") -- suppresses messages related to completion

cmp.setup({
    snippet = {
        expand = function(args)
            -- luasnip.lsp_expand(args.body)
            luasnip.snip_expand(args.body)
        end,
    },
    formatting = {
        format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind =
                string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- This concatenates the icons with the name of the item kind
            -- Source
            vim_item.menu = ({
                buffer = "[Buf]",
                nvim_lsp = "[LSP]",
                luasnip = "[Snip]",
                nvim_lua = "[Lua]",
            })[entry.source.name]
            return vim_item
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item({
            behaviour = cmp.SelectBehavior.Insert,
        }),
        ["<C-p>"] = cmp.mapping.select_prev_item({
            behaviour = cmp.SelectBehavior.Insert,
        }),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        -- not sure about tab and shift tab for completion
        -- ["<Tab>"] = cmp.mapping(function(fallback)
        --    -- if cmp.visible() then
        --    --   cmp.select_next_item()
        --    -- elseif luasnip.locally_jumpable(1) then
        --    if luasnip.locally_jumpable(1) then
        --      luasnip.jump(1)
        --    else
        --      fallback()
        --    end
        --  end, { "i", "s" }),
        -- ["<S-Tab>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_prev_item()
        --   elseif luasnip.locally_jumpable(-1) then
        --     luasnip.jump(-1)
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),
    }),
    --[[
    sources can have multiple options.
    - keyword_length: determines required characters before suggestion
    - priority: manually assign priority value
    - max_item_count: limit the number of suggestions from a particular source
    --]]
    sources = cmp.config.sources({
        -- ordering determines priority
        --
        { name = "copilot", group_index = 2 },
        { name = "nvim_lua" },
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "luasnip" }, -- For luasnip users.
        -- words in the current buffer
        { name = "buffer", keyword_length = 5 }, -- keyword_length determines required characters before suggestions are shown
    }),
})
