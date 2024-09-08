--[[
Use tab to execute snippets.
use tab/ctrl+j to move to the next jump point in a snippet
use shift+tab/ctrl+k to move to the previous jump point in a snippet
use ctrl+tab to use an actual tab
--]]

return {
    "L3MON4D3/LuaSnip",
    lazy = true,
    build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return
        end
        return "make install_jsregexp"
    end)(),
    dependencies = {
        "nvim-cmp",
        "saadparwaiz1/cmp_luasnip",
    },
    opts = {
        -- allows going back into snippets if a mistake is made
        history = true,
        -- history = false, -- false is faster

        -- Enable autotrigger snippets
        enable_autosnippets = true,

        -- Use Tab to trigger visual selection
        store_selection_keys = "<Tab>",

        delete_check_events = "TextChanged",

        -- events that trigger update of active nodes dependents
        update_events = 'TextChanged,TextChangedI', -- live update for things like repeats

        -- Event on which to check for exiting a snippet's region
        region_check_events = 'InsertEnter',
        delete_check_events = 'InsertLeave',
    },
    config = function()

        -- load all regardless of filetype
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
        
        -- Expand snippets in insert mode with Tab
        vim.keymap.set('i', '<Tab>', function()
          return require('luasnip').expand_or_jumpable() and '<Plug>luasnip-expand-or-jump' or '<Tab>'
        end, { expr = true, silent = true })
        
        -- Jump forward in insert and visual mode with Tab
        vim.keymap.set('i', '<Tab>', function()
          return require('luasnip').jumpable(1) and '<Plug>luasnip-jump-next' or '<Tab>'
        end, { expr = true, silent = true })
        
        vim.keymap.set('s', '<Tab>', function()
          return require('luasnip').jumpable(1) and '<Plug>luasnip-jump-next' or '<Tab>'
        end, { expr = true, silent = true })
        
        -- Jump backward in insert and visual mode with Shift-Tab
        vim.keymap.set('i', '<S-Tab>', function()
          return require('luasnip').jumpable(-1) and '<Plug>luasnip-jump-prev' or '<S-Tab>'
        end, { expr = true, silent = true })
        
        vim.keymap.set('s', '<S-Tab>', function()
          return require('luasnip').jumpable(-1) and '<Plug>luasnip-jump-prev' or '<S-Tab>'
        end, { expr = true, silent = true })
        
        -- Cycle forward through choice nodes with Control-f
        vim.keymap.set('i', '<C-f>', function()
          return require('luasnip').choice_active() and '<Plug>luasnip-next-choice' or '<C-f>'
        end, { expr = true, silent = true })
        
        vim.keymap.set('s', '<C-f>', function()
          return require('luasnip').choice_active() and '<Plug>luasnip-next-choice' or '<C-f>'
        end, { expr = true, silent = true })
        
        -- Load custom snippets with Leader + L
        vim.keymap.set('n', '<Leader>L', function()
          require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets/langs/" })
        end, { silent = true, noremap = true })
    end,
}

