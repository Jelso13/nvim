-- protected calls for cmp and luasnip
local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
    return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
    return
end

-- not sure why vscode but something about bringing in snippets
require("luasnip/loaders/from_vscode").lazy_load()

-- something about making the backspace more intuitive in the menu
local check_backspace = function()
    local col = vim.fn.col "." - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

-- stuff from nerd fonts
--   פּ ﯟ   some other good icons
local kind_icons = {
  Text = "",
  Method = "m",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}
-- find more here: https://www.nerdfonts.com/cheat-sheet

-- cmp setup
cmp.setup {
    -- use luasnip as the snippet engine
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },

    -- mappings
    mapping = {
        -- go through the menu options
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        -- if the snippet is very large then can scroll through
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
        -- <C-Space> brings up the menu rather than from typing
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        -- close the menu using Ctrl-e
        ["<C-e>"] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        },
        -- Accept currently selected item. If none selected, `select` first item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        ["<CR>"] = cmp.mapping.confirm { select = true },
        -- super tab 
        ["<Tab>"] = cmp.mapping(function(fallback)
            -- if menu open then select next item in menu
            if cmp.visible() then
                cmp.select_next_item()
            -- if can expand lua snippet then expand
            elseif luasnip.expandable() then
                luasnip.expand()
            -- if has jumps then jump to the next part of snippet
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            -- regular tab usage
            elseif check_backspace() then
                fallback()
            else
                fallback()
            end
        end, {
            "i",
            "s",
        }),
        -- same for super tab but inverse
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, {
            "i",
            "s",
        }),
    },

    -- formatting the completion menu
    formatting = {
        -- gives the format of each field - the kind or symbol, abbreviation and source location
        fields = { "kind", "abbr", "menu" },
        -- 
        format = function(entry, vim_item)
            -- Kind icons format
            vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
            -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
            vim_item.menu = ({
                luasnip = "[Snippet]", -- from luasnip
                buffer = "[Buffer]", -- from current file
                path = "[Path]", -- from buffer
            })[entry.source.name]
            return vim_item
        end,
    },
    -- where snippets come from: THE ORDER DETERMINES PREFERENCE
    sources = {
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
    },
    confirm_opts = {
        behavior = cmp.ConfirmBehavior.Replace,
        select = false,
    },
    -- define how the window is shown for the snippet preview
    window = {
        documentation = cmp.config.window.bordered(),
    },
    experimental = {
        ghost_text = true,     -- starts to complete with virtual text
        native_menu = false,
    },
}
