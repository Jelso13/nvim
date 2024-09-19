local M = {}


--[[
        ┌─────────────────────────────────────────────────────────────────┐
        │ Ultimately, I want to incorporate telescope to preview snippets │
        └─────────────────────────────────────────────────────────────────┘
--]]

local format_lines = function(res, buf)
    local lines = {}
    for lang, snip_i in pairs(res) do
        -- Add a separator for each language section
        table.insert(lines, lang .. " snippets:")
        table.insert(lines, string.rep("-", 40))  -- Separator line

        for _, info in ipairs(snip_i) do
            -- Join descriptions if they are multiple; otherwise, just use the string
            local description
            if type(info.description) == "table" then
                description = table.concat(info.description, " ")
            else
                description = info.description
            end
            local auto = ""
            if info.snippetType == "autosnippets" then
                auto = "auto"
            end
            -- Add the trigger and description in a formatted manner
            table.insert(lines, string.format("%-4s | %-15s | %s", auto, info.trigger, description))
            table.insert(lines, "")
            -- add the docstring if it exists , info.docstring is a table so add each line
            if info.docstring then
                for _, line in ipairs(info.docstring) do
                    table.insert(lines, string.format("    %s", line))
                end
            end
            table.insert(lines, "")

        end

        -- Add a blank line between languages for spacing
        table.insert(lines, "")
    end
    return lines
end

function M.display_snippets()
    -- get the snippet info
    local function snip_info(snip)
        return {
            name = snip.name,
            trigger = snip.trigger,
            description = snip.description,
            wordTrig = snip.wordTrig,
            regTrig = snip.regTrig,
            -- docstring = snip.docstring,
            docstring = snip:get_docstring(), -- generate it if it doesnt have it
            docsTrig = snip.docTrig,
            snippetType = snip.snippetType,
        }
    end
    local res = {}
    local ls = require("luasnip")
    local fts = require("luasnip.util.util").get_snippet_filetypes()
    for _, ft in ipairs(fts) do
        res[ft] = {}
        for _, snip in ipairs(ls.get_snippets(ft)) do
            if not snip.invalidated then
                table.insert(res[ft], snip_info(snip))
            end
        end
        for _, snip in ipairs(ls.get_snippets(ft, { type = "autosnippets" })) do
            if not snip.invalidated then
                table.insert(res[ft], snip_info(snip))
            end
        end
    end

    -- Create a buffer for the popup window
    local buf = vim.api.nvim_create_buf(false, true) -- no file, no swapfile

    -- Set text for the buffer
    -- local lines = { "Hello, this is a popup window!", "Line 2", "Line 3" }
    local lines = format_lines(res, buf)

    -- Set the buffer lines with the formatted text
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- Make the buffer read-only
    vim.api.nvim_set_option_value("modifiable", false, {buf=buf})-- buf, 'modifiable', false)
    vim.api.nvim_set_option_value("readonly", true, {buf=buf})-- buf, 'modifiable', false)
    -- vim.api.nvim_set_option_value(-- buf, 'readonly', true)

    -- Window options
    local opts = {
      relative = 'editor',
      width = vim.o.columns,
      height = math.floor((vim.o.lines - 10)/3),
      -- col = (vim.o.columns - 40) / 2,  -- Center horizontally
      col = 0,
      row = 2*math.floor(vim.o.lines / 3),    -- Center vertically
      anchor = 'NW',
      style = 'minimal',               -- Minimal UI (no borders, scrollbars, etc.)
      border = 'single',               -- Add a single-line border around the popup
    }

    -- Open the popup window
    local win = vim.api.nvim_open_win(buf, true, opts)

    vim.api.nvim_buf_set_keymap(buf, 'n', "<Esc>", '', {
        noremap = true,
        silent = true,
        callback = function()
            vim.api.nvim_win_close(win, true)
        end,
    })

    -- -- Set an autocommand to close the window when it loses focus
    -- vim.api.nvim_create_autocmd("WinLeave", {
    --     callback = function()
    --         if vim.api.nvim_win_is_valid(win) then
    --             vim.api.nvim_win_close(win, true) -- Close the window
    --         end
    --     end,
    --     buffer = buf, -- Attach the autocommand to the specific buffer
    --     once = true,  -- Make sure the autocommand only triggers once
    -- })
end

return M
