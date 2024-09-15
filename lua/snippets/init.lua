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

        -- events that trigger update of active nodes dependents
        update_events = 'TextChanged,TextChangedI', -- live update for things like repeats

        -- Enable autotrigger snippets
        enable_autosnippets = true,

        -- Use Tab to trigger visual selection
        store_selection_keys = "<Tab>",

        delete_check_events = "TextChanged",

        -- Event on which to check for exiting a snippet's region
        region_check_events = 'InsertEnter',
        -- delete_check_events = 'InsertLeave',
    },
    config = function()
        require("snippets.config")
    end,
}

