-- at the moment only contains keymaps for gilles castels work:

return {
    dir = ".",
    ft = "latex",
    config = function()
        -- Insert mode mapping for creating figures
        vim.api.nvim_set_keymap(
            "i",
            "<C-f>",
            "<Esc>:silent lua vim.cmd('.!inkscape-figures create \"'..vim.fn.getline(\".\")..'\" \"'..vim.b.vimtex.root..'/figures/\"')<CR><CR>:w<CR>",
            { noremap = true, silent = true }
        )

        -- Normal mode mapping for editing figures
        vim.api.nvim_set_keymap(
            "n",
            "<localleader>f",
            ":silent lua vim.cmd('!inkscape-figures edit \"'..vim.b.vimtex.root..'/figures/\" > /dev/null 2>&1 &')<CR><CR>:redraw!<CR>",
            { noremap = true, silent = true, desc = "[E]dit [F]igure" }
        )
    end,
}
