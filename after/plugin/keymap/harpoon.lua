-- ******
-- definitely change these keybindings


local nnoremap = require("user.keymaps").nnoremap


local harpoon_ui = require("harpoon.ui");
local harpoon_mark = require("harpoon.mark");

-- tags a file for use in harpoon 
nnoremap("<leader>a", function ()
    harpoon_mark.add_file()
end)

-- opens the window to show the currently tagged harpoon windows
nnoremap("<C-e>",function ()
    harpoon_ui.toggle_quick_menu()
end)


nnoremap("<C-h>", function() harpoon_ui.nav_file(1) end)
nnoremap("<C-t>", function() harpoon_ui.nav_file(2) end)
nnoremap("<C-n>", function() harpoon_ui.nav_file(3) end)
nnoremap("<C-s>", function() harpoon_ui.nav_file(4) end)


