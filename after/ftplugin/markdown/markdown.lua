

-- ###########################################################################
-- Have context when in a notebook/obsidian/vault and when in a standard readme file so that not everything overlaps
-- ###########################################################################

local status_ok, mkdnflow = pcall(require, "mkdnflow")
if not status_ok then
    return
end

local luasnip = require("luasnip")
local Job = require("plenary.job")

-- ###########################################################################
-- To Do:
--      * follow link to distant source using telescope
--      *
-- ###########################################################################

vim.opt.wrap = true -- wrap of long lines
vim.opt.textwidth = 80 -- set the text width to be 80 characters


-- follows a link, creates link from word or visual selection * potentially useless
--  in insert mode can interface with table
vim.keymap.set({ "n", "v" }, "<leader>ml", "<cmd>MkdnEnter<cr>", { desc = "make link" })
vim.keymap.set({ "n", "v" }, "<leader>mm", "<cmd>MkdnMoveSource<cr>", { desc = "make link" })

-- think this one breaks harpoon and the link generation
vim.keymap.set("n", "gf", "<cmd>MkdnFollowLink<cr>", { desc = "follow link" })
vim.keymap.set("n", "<Tab>", "<cmd>MkdnNextLink<cr>", { desc = "next link" })
vim.keymap.set("n", "<S-Tab>", "<cmd>MkdnPrevLink<cr>", { desc = "prev link" })
vim.keymap.set("v", "<leader>mt", "<cmd>MkdnTagSpan<cr>", { desc = "make tag" })
vim.keymap.set("v", "<leader>md", "<cmd>MkdnDestroyLink<cr>", { desc = "destroy link" })
vim.keymap.set("n", "<cr>", "<cmd>MkdnToggleToDo<cr>", { desc = "toggle todo" })


-- vim.keymap.set( "n", "gf", function()
--     if obsidian.util.cursor_on_markdown_link() then
--       return "<cmd>ObsidianFollowLink<CR>"
--     else
--       return "gf"
--     end
--   end,
--   { noremap = false, expr = true}
-- )

-- Table stuff
vim.keymap.set("i", "<Tab>",function ()
    local line = vim.api.nvim_get_current_line()
    -- if there are jumpable luasnip locations then go there
    if luasnip.jumpable(1) then
        return "<Plug>luasnip-jump-next"
    -- if the current line is in a table then go to next cell
    elseif mkdnflow and mkdnflow.tables and mkdnflow.tables.isPartOfTable(line) then
        return "<cmd>MkdnTableNextCell<cr>"
    -- otherwise <tab>
    else
        return "<Tab>"
    end
end, { desc = "go to next cell if part of table", expr = true })

-- -- Jump forward in through tabstops in insert and visual mode with Control-f
-- vim.cmd[[imap <silent><expr> <Tab> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Tab>']]
-- vim.cmd[[smap <silent><expr> <Tab> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Tab>']]

-- vim.keymap.set("i", "<Tab>", "<cmd>MkdnTableNextCell<cr>", { desc = "go to next cell" })
vim.keymap.set("i", "<S-Tab>", "<cmd>MkdnTablePrevCell<cr>", { desc = "go to prev cell" })

-- opens obsidian
M = {}
M.ObsidianOpen = function()
    local url = 'obsidian://open?vault=Vault&file=' .. vim.fn.expand("%:t")
    -- vim.cmd('silent exec "!open \'' .. url .. '\'"')
    Job:new({
        command = "xdg-open", -- should be open in non linux
        args = { url },
        on_exit = vim.schedule_wrap(function(_, return_code)
            if return_code > 0 then
                vim.api.echo.err "failed opening Obsidian app to note"
            end
        end),
    }):start()
end


vim.keymap.set("n", "<leader>oo", "<cmd>lua M.ObsidianOpen()<cr>",
    { desc = "obsidian open", silent = true, noremap = true }
)

function M.get_relative_path(cwd, target)
    local cwd_parts = {}
    local target_parts = {}

    for p in cwd:gmatch('[^/]+') do
        cwd_parts[#cwd_parts + 1] = p
    end

    for p in target:gmatch('[^/]+') do
        if p == cwd_parts[#target_parts + 1] then
            table.remove(cwd_parts, #target_parts + 1)
        else
            target_parts[#target_parts + 1] = p
        end
    end
    local dots = {}
    for _ = 1, #cwd_parts do
        dots[#dots+1] = "../"
    end
    return table.concat(dots, "")..table.concat(target_parts, "/")
end


function M.link_file()
    local opts = {
        prompt_title = "Get relative path",
        shorten_path = true,
        follow = false,
        path_display = {},
        attach_mappings = function(_, map)
            map("i", "<cr>", function(prompt_bufnr)
                -- get the selected telescope entry
                local entry = require("telescope.actions.state").get_selected_entry().value
                -- close the window
                require("telescope.actions").close(prompt_bufnr)
                -- get the full path of the selected file
                local target_path = vim.fn.fnamemodify(vim.fn.expand(entry), ':p')
                -- get the current working directory as a full path
                local cwd = vim.fn.expand("%:p:h:~:.") .. "/"
                -- get the relative path
                entry = M.get_relative_path(cwd, target_path)
                -- paste the relative path
                vim.cmd('normal i' .. entry)
            end)
            return true
        end
    }
    require("telescope.builtin").find_files(opts)
end

vim.keymap.set("n", "<leader>og", "<cmd>lua M.link_file()<cr>",
    { desc = "obsidian get relative file path", silent = true, noremap = true }
)
