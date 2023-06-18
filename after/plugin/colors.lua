require("tokyonight").setup({
    transparent = true,
    styles = {
        comments = { italic = true },
    },
})
-- this is a test #443322
-- colorizer
-- enable all options
require('colorizer').setup({ '*' }, {
    -- mode = 'foreground',
    names = false,
    RRGGBBAA = true,
})

-- require('colorizer').setup({
--     user_default_options = {
--         RGB = true,
--         RRGGBB = true,
--         names = false,
--         RRGGBBAA = true,
--         rgb_fn = true,
--         hsl_fn = true,
--         mode = 'background',
--     },
-- })

-- sets the colorscheme and makes the background transparent

function ColorMyPencils(color)
	color = color or "tokyonight"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "Normalfloat", { bg = "none" })
end

ColorMyPencils()
