

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
-- vim.keymap.set({ "i", "s" }, "<Tab>", function()
--     if ls.expand_or_jumpable() then
--         ls.expand_or_jump()
--     else
--         return '<Tab>'
--     end
-- end, { silent = true })

-- ctrl-j jumps to previous item within snippet
vim.keymap.set({ "i", "s" }, "<c-j>", function()
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end, { silent = true })

-- vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
--     if ls.jumpable(-1) then
--         ls.jump(-1)
--     end
-- end, { silent = true })

-- ctrl-l selects from a 'list' of options in choice nodes
vim.keymap.set({ "i" }, "<c-l>", function()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end)


local d = require("snippets.snippet_whichkey")

-- new user command that displays all snippets
vim.api.nvim_create_user_command("LuaSnipListAll", d.display_snippets, { force = true })

-- create a keybinding to <leader>hs that calls the user command
vim.keymap.set("n", "<leader>hs", ":LuaSnipListAll<CR>", { silent = true, desc="[H]elp [S]nippets" })

-- Keybinding to launch the function
-- Want to open the current file type in ~/.config/nvim/lua/snippets/langs/<language>.lua
-- on close, re-source nvim config in the file so I can use the snippet straight away
vim.keymap.set(
  'n',                           -- normal mode
  '<leader>ns',                  -- your keybinding (os: open snippets)
    require("snippets.open_snippets").open_snippet_file,
  { noremap = true, silent = true, desc="[N]eovim open [S]nippets" }  -- options: don't allow remapping and silent execution
)

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
