-- Setup nvim-cmp.
local status_ok, zenmode = pcall(require, "zen-mode")
if not status_ok then
    return
end

zenmode.setup {
    zindex = 66,
    window = {
        backdrop = 0.95,
        width = 90,
        -- width = 0.70 ,
        options = {
            number = true,
            relativenumber = true,
        }
    },
    plugins = {
        tmux = { enabled = true },
    },
}

-- 8------15---20---25---30---35---40---45---50---55---60---65---70---75---80---85---90---95---100

vim.keymap.set("n", "<leader>zz", function()
    require("zen-mode").toggle()
    -- vim.wo.wrap = false
    ColorMyPencils()
    vim.api.nvim_set_hl(0, "ZenBg", { ctermbg = 0 })
end,
{desc="Zen Mode"})
