-- mainly taken from https://ejmastnak.github.io/tutorials/vim-latex/luasnip.html


local status_ok, luasnip = pcall(require, "luasnip")
if not status_ok then
    return
end

local loaders = require("luasnip.loaders.from_lua")


luasnip.config.set_config({
    -- Enable autotrigger snippets
    enable_autosnippets = true,

    -- Use Tab to trigger visual selection
    store_selection_keys = "<Tab>",
    update_events = 'TextChanged,TextChangedI', -- live update for things like repeats
})


-- having to do this with vim script as cant get the conditional working with lua
-- bindings done for both insert mode (i) and select mode (s)

-- Expand snippets in insert mode with Tab
vim.cmd[[imap <silent><expr> <Tab> luasnip#expandable() ? '<Plug>luasnip-expand-snippet' : '<Tab>']]

-- Jump forward in through tabstops in insert and visual mode with Control-f
vim.cmd[[imap <silent><expr> <C-f> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<C-f>']]
vim.cmd[[smap <silent><expr> <C-f> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<C-f>']]

-- Jump backward through snippet tabstops with Shift-Tab (for example)
vim.cmd[[imap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>']]
vim.cmd[[smap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>']]

-- Power user: Cycle forward through choice nodes with Control-f (for example)
vim.cmd[[imap <silent><expr> <C-f> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-f>']]
vim.cmd[[smap <silent><expr> <C-f> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-f>']]
-- choice nodes allow selection of a particular node to jump to

-- load snippets from given dir only when in the required filetype
-- loaders.lazy_load({paths = "~/.config/nvim/snips/"})
loaders.load({paths = "~/.config/nvim/snips/"})
-- can also set from table of dirs:
-- require("luasnip.loaders.from_lua").load({paths = {"~/.config/nvim/LuaSnip1/", "~/.config/nvim/LuaSnip2/"}})


-- abbreviations used
local s = luasnip.snippet
local sn = luasnip.snippet_node
local t = luasnip.text_node
local i = luasnip.insert_node
local f = luasnip.function_node
local d = luasnip.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep


