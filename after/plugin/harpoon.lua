local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set(
    "n", "<leader>a", function() harpoon:list():add() end, { desc = "Add a file to harpoon" }
    )
vim.keymap.set(
    "n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
    { desc = "Toggle the UI for Harpoon" }
    )

vim.keymap.set(
    "n", "<C-h>", function() harpoon:list():select(1) end,
    { desc = "Go to the first harpoon entry" }
)
vim.keymap.set(
    "n", "<C-t>", function() harpoon:list():select(2) end,
    { desc = "Go to the second harpoon entry" }
)
vim.keymap.set(
    "n", "<C-n>", function() harpoon:list():select(3) end,
    { desc = "Go to the third harpoon entry" }
)
vim.keymap.set(
    "n", "<C-s>", function() harpoon:list():select(4) end,
    { desc = "Go to the fourth harpoon entry" }
)

-- for handling code testing
-- lua require("harpoon.tmux").gotoTerminal(1)             -- goes to the first tmux window
-- lua require("harpoon.tmux").sendCommand(1, "ls -La")    -- sends ls -La to tmux window 1
-- lua require("harpoon.tmux").sendCommand(1, 1)           -- sends command 1 to tmux window 1


