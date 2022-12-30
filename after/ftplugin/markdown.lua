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

vim.opt.wrap = true 				-- wrap of long lines


-- follows a link, creates link from word or visual selection 
--  in insert mode can interface with table
vim.keymap.set({"n", "v"}, "<leader>ml", "<cmd>MkdnEnter<cr>", {desc="make link"})
vim.keymap.set("n", "gf", "<cmd>MkdnFollowLink<cr>", {desc="follow link"})
vim.keymap.set("n", "<Tab>", "<cmd>MkdnNextLink<cr>", {desc="next link"})
vim.keymap.set("n", "<S-Tab>", "<cmd>MkdnPrevLink<cr>", {desc="prev link"})
vim.keymap.set("v", "<leader>mt", "<cmd>MkdnTagSpan<cr>", {desc="make tag"})
vim.keymap.set("v", "<leader>md", "<cmd>MkdnDestroyLink<cr>", {desc="destroy link"})

-- command IO execute 
-- "silent !open 'obsidian://open?vault=VAULTNAME&file=" . expand('%:r') . "'"
-- nnoremap <leader>io :IO<CR>

-- opens obsidian
M = {}
M.ObsidianOpen = function ()
  local url = 'obsidian://open?vault=Vault&file=' .. vim.fn.expand("%:t")
  -- vim.cmd('silent exec "!open \'' .. url .. '\'"')
  Job:new({
    command = "xdg-open", -- should be open in non linux
    args = { url },
    on_exit = vim.schedule_wrap(function(_, return_code)
      -- if return_code > 0 then
      --   echo.err "failed opening Obsidian app to note"
      -- end
    end),
  }):start()
end

vim.keymap.set("n", "<leader>oo", "<cmd>lua M.ObsidianOpen()<cr>",
  {desc="obsidian open", silent=true, noremap = true}
)

