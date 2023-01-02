local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

-- 'leader-a' to add file to harpoon
vim.keymap.set("n", "<leader>a", mark.add_file, {desc="add file to harpoon"})

-- toggles the menu that shows harpoon buffers
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
-- vim.keymap.set("n","<leader>tc", function() require("harpoon.cmd-ui").toggle_quick_menu() end)

-- navigation in harpoon
vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
vim.keymap.set("n", "<C-t>", function() ui.nav_file(2) end)
vim.keymap.set("n", "<C-n>", function() ui.nav_file(3) end)
vim.keymap.set("n", "<C-s>", function() ui.nav_file(4) end)


-- for handling code testing
-- lua require("harpoon.tmux").gotoTerminal(1)             -- goes to the first tmux window
-- lua require("harpoon.tmux").sendCommand(1, "ls -La")    -- sends ls -La to tmux window 1
-- lua require("harpoon.tmux").sendCommand(1, 1)           -- sends command 1 to tmux window 1


