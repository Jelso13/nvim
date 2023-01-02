local status_ok, mkdnflow = pcall(require, "mkdnflow")
if not status_ok then
    return
end

local Job = require("plenary.job")

-- ###########################################################################
-- To Do:
--      * follow link to distant source using telescope
--      *
-- ###########################################################################

vim.opt.wrap = true -- wrap of long lines


-- follows a link, creates link from word or visual selection
--  in insert mode can interface with table
vim.keymap.set({ "n", "v" }, "<leader>ml", "<cmd>MkdnEnter<cr>", { desc = "make link" })
vim.keymap.set("n", "gf", "<cmd>MkdnFollowLink<cr>", { desc = "follow link" })
vim.keymap.set("n", "<Tab>", "<cmd>MkdnNextLink<cr>", { desc = "next link" })
vim.keymap.set("n", "<S-Tab>", "<cmd>MkdnPrevLink<cr>", { desc = "prev link" })
vim.keymap.set("v", "<leader>mt", "<cmd>MkdnTagSpan<cr>", { desc = "make tag" })
vim.keymap.set("v", "<leader>md", "<cmd>MkdnDestroyLink<cr>", { desc = "destroy link" })
vim.keymap.set("n", "<cr>", "<cmd>MkdnToggleToDo<cr>", { desc = "toggle todo" })


-- command IO execute
-- "silent !open 'obsidian://open?vault=VAULTNAME&file=" . expand('%:r') . "'"
-- nnoremap <leader>io :IO<CR>

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
    for i, elem in ipairs(cwd_parts) do
        dots[#dots+1] = "../"
    end
    -- return table.concat(target_parts, " ")
    return table.concat(dots, "")..table.concat(target_parts, "/")

    -- local x = ": "
    -- for i, elem in ipairs(cwd_parts) do
    --     x = x..elem
    -- end
    -- return x

end

function M.test_grep_filename()
    local opts = {
        prompt_title = "testing",
        follow = false,
        path_display = {},
        attach_mappings = function(_, map)
            map("i", "<cr>", function(prompt_bufnr)
                -- local entry = require("telescope.actions").close(prompt_bufnr)
                local entry = require("telescope.actions.state").get_selected_entry().value
                -- entry = require("plenary.path").make_relative(entry)
                -- entry = vim.fn.fnamemodify(vim.fn.expand(entry), ':.')
                -- entry = vim.fn.fnamemodify(entry, ':.')


                require("telescope.actions").close(prompt_bufnr)

                -- entry = vim.fn.fnamemodify(vim.fn.expand(entry), ':p')
                -- entry = require("plenary.path"):new(entry):make_relative(vim.fn.expand("%:p"))


                local target_path = vim.fn.fnamemodify(vim.fn.expand(entry), ':p')
                local cwd = vim.fn.expand("%:p:h:~:.") .. "/"
                -- entry = require("plenary.path"):new(target_path):make_relative(cwd)
                entry = M.get_relative_path(cwd, target_path)
                -- cwd = /home/defalt/.config/nvim/after/ftplugin/
                -- target_path = /home/defalt/.config/nvim/lua/user/remap.lua
                -- entry = /home/defalt/.config/nvim/lua/user/remap.lua

                -- entry = require("plenary.path"):new("/a/b/c"):make_relative("/a/")
                -- entry = require("plenary.path"):new("/a/b/c"):make_relative("/a/b/d/f/") -- should be ../../c

                -- should be ../../lua/user/packer.lua
                -- entry = M.get_relative_path("/home/defalt/.config/nvim/after/ftplugin/",
                    -- "/home/defalt/.config/nvim/lua/user/packer.lua")

                -- entry = M.get_relative_path("/a/b/c/", "/a/b/d/f.md") -- should be ../d/f.md
                -- entry = M.get_relative_path("/a/b/c/", "/a/b/c/f.md") -- should be ./f.md
                -- entry = M.get_relative_path("/a/b/c/e/", "/a/b/c/f.md") -- should be ../f.md
                -- entry = M.get_relative_path("/a/b/", "/a/b/c/f.md") -- should be ./c/f.md
                -- should be ../c/

                -- entry = vim.fn.expand("%:p")
                vim.cmd('normal i' .. entry)

            end)
            return true
        end
    }
    local file = require("telescope.builtin").find_files(opts)
    vim.api.nvim_put({ file }, "", true, true)
    -- local action_state = require("telescope.actions.state")
    -- local opts = {
    --     prompt_title = "~ Backlink ~",
    --     shorten_path = false,
    --     -- cwd = "path2search",
    --     theme = require("telescope.themes").get_cursor(),
    --     attach_mappings = function(_, map)
    --         map("i", "<CR>", function(prompt_bufnr)
    --             -- filename is available at entry[1]
    --             local entry = require("telescope.actions.insert_symbol").get_selected_entry().value[1]
    --             require("telescope.actions").close(prompt_bufnr)
    --             --local filename = entry[1]
    --             -- Insert filename in current cursor position
    --             --vim.cmd('normal i' .. filename)
    --             vim.api.nvim_put({ entry }, "", true, true)
    --         end
    --         )
    --         return true
    --     end,
    -- }
    -- require('telescope.builtin').live_grep(opts)
end

vim.keymap.set("n", "<leader>og", "<cmd>lua M.test_grep_filename()<cr>",
    { desc = "obsidian get relative file path", silent = true, noremap = true }
)
