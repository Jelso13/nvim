local ls = require("luasnip")

ls.setup({
    history = true,
    update_events = 'TextChanged,TextChangedI',
    enable_autosnippets = true,
    store_selection_keys = "<Tab>",
    region_check_events = 'InsertEnter',
    delete_check_events = 'TextChanged,InsertEnter',
    
    -- THE GATEKEEPER: Checks cursor position to activate the right bucket
    ft_func = function()
        local cursor_lang = vim.bo.filetype
        local has_ts, _ = pcall(require, "vim.treesitter")
        if has_ts and vim.treesitter.get_parser then
            local cursor = vim.api.nvim_win_get_cursor(0)
            local row = cursor[1] - 1
            local col = cursor[2]
            
            local ok, parser = pcall(vim.treesitter.get_parser, 0)
            if ok and parser then
                local active_tree = parser:language_for_range({ row, col, row, col })
                if active_tree then
                    local injected_lang = active_tree:lang()
                    if injected_lang and injected_lang ~= cursor_lang then
                        if injected_lang == "markdown_inline" then
                            injected_lang = "markdown"
                        end
                        -- THE FIX: If Tree-sitter injects LaTeX, we are in a math block!
                        -- Return markdown FIRST so our custom math snippets take priority.
                        if injected_lang == "latex" then
                            return { "markdown", "latex", cursor_lang }
                        end
                        
                        return { injected_lang, cursor_lang }
                    end
                end
            end
        end
        return { cursor_lang }
    end,
})

-- THE FIX: Eager Load. 
-- This bypasses FileType events and reads markdown.lua into memory immediately.
require("luasnip.loaders.from_lua").load({
    paths = { vim.fn.stdpath("config") .. "/lua/snippets/langs" }
})

vim.cmd[[
" press <Tab> to expand or jump in a snippet.
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>
snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>
imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
]]

vim.keymap.set({ "i" }, "<c-l>", function()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end)

vim.keymap.set({ "s" }, "<BS>", "<C-G>s", {noremap=true, silent=true})
vim.keymap.set('s', '<', '<LT>', { noremap = true, silent = true })
vim.keymap.set('s', '>', '>', { noremap = true, silent = true })

local d = require("snippets.snippet_whichkey")
vim.api.nvim_create_user_command("LuaSnipListAll", d.display_snippets, { force = true })
vim.keymap.set("n", "<leader>hs", ":LuaSnipListAll<CR>", { silent = true, desc="[H]elp [S]nippets" })
vim.keymap.set('n', '<leader>ns', require("snippets.open_snippets").open_snippet_file, { noremap = true, silent = true, desc="[N]eovim open [S]nippets" })

vim.api.nvim_create_user_command("DebugTS", function()
    local cursor_lang = vim.bo.filetype
    local ok, parser = pcall(vim.treesitter.get_parser, 0)
    
    if not ok or not parser then
        print("Tree-sitter is NOT active in this buffer.")
        return
    end

    local cursor = vim.api.nvim_win_get_cursor(0)
    local row = cursor[1] - 1
    local col = cursor[2]
    
    local active_tree = parser:language_for_range({ row, col, row, col })
    local injected_lang = active_tree and active_tree:lang() or "none"
    
    print("1. Global Filetype: " .. cursor_lang)
    print("2. Tree-sitter Context at Cursor: " .. injected_lang)
end, {})
