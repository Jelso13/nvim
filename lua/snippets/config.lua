

-- load all regardless of filetype
local ls = require("luasnip")
local snip_loader = require("luasnip.loaders.from_lua")
snip_loader.load({paths = "~/.config/nvim/lua/snippets/langs"})
-- Lazy load snippets for specific filetypes
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "lua", "python", "javascript", "rust", "all" },  -- Add your desired filetypes here
    callback = function(event)
        local luasnip = require("luasnip")
        local snip_loader = require("luasnip.loaders.from_lua")

        -- Load snippets for the specific file type
        snip_loader.load({ paths = vim.fn.stdpath("config") .. "/lua/snippets/langs/" .. event.match })
        -- local loaders = require("luasnip.loaders.from_lua")
        snip_loader.load({paths = "~/.config/nvim/lua/snippets/langs/"})
    end,
})


--[[
Use tab to execute snippets.
use tab/ctrl+j to move to the next jump point in a snippet
use shift+tab/ctrl+k to move to the previous jump point in a snippet
use ctrl+tab to use an actual tab
--]]
-- ctrl-k expands current item or jumps to next item within snippet
vim.keymap.set({ "i", "s" }, "<c-k>", function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end, { silent = true })

-- ctrl-j jumps to previous item within snippet
vim.keymap.set({ "i", "s" }, "<c-j>", function()
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end, { silent = true })

-- ctrl-l selects from a 'list' of options in choice nodes
vim.keymap.set({ "i" }, "<c-l>", function()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end)

-- Expand snippets in insert mode with Tab
-- vim.keymap.set('i', '<Tab>', function()
--   return require('luasnip').expand_or_jumpable() and '<Plug>luasnip-expand-or-jump' or '<Tab>'
-- end, { expr = true, silent = true })
-- 
-- -- Jump forward in insert and visual mode with Tab
-- vim.keymap.set('i', '<Tab>', function()
--   return require('luasnip').jumpable(1) and '<Plug>luasnip-jump-next' or '<Tab>'
-- end, { expr = true, silent = true })
-- 
-- vim.keymap.set('s', '<Tab>', function()
--   return require('luasnip').jumpable(1) and '<Plug>luasnip-jump-next' or '<Tab>'
-- end, { expr = true, silent = true })
-- 
-- -- Jump backward in insert and visual mode with Shift-Tab
-- vim.keymap.set('i', '<S-Tab>', function()
--   return require('luasnip').jumpable(-1) and '<Plug>luasnip-jump-prev' or '<S-Tab>'
-- end, { expr = true, silent = true })
-- 
-- vim.keymap.set('s', '<S-Tab>', function()
--   return require('luasnip').jumpable(-1) and '<Plug>luasnip-jump-prev' or '<S-Tab>'
-- end, { expr = true, silent = true })
-- 
-- -- Cycle forward through choice nodes with Control-f
-- vim.keymap.set('i', '<C-f>', function()
--   return require('luasnip').choice_active() and '<Plug>luasnip-next-choice' or '<C-f>'
-- end, { expr = true, silent = true })
-- 
-- vim.keymap.set('s', '<C-f>', function()
--   return require('luasnip').choice_active() and '<Plug>luasnip-next-choice' or '<C-f>'
-- end, { expr = true, silent = true })
-- 
-- -- Load custom snippets with Leader + L
-- vim.keymap.set('n', '<Leader>L', function()
--   require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets/langs/" })
-- end, { silent = true, noremap = true })
