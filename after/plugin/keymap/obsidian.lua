local Remap = require("user.keymaps")
local nnoremap = Remap.nnoremap

-- Bindings for obsidian markdown files

-- go to the file linked by the obsidian link
-- nnoremap("gf", function()
--     if require('obsidian').util.cursor_on_markdown_link() then
--       return "<cmd>ObsidianFollowLink<CR>"
--     else
--       return "gf"
--     end
-- end)

local au_group = vim.api.nvim_create_augroup("obsidian_extra_setup", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	group = au_group,
	-- pattern = tostring(obsidian.dir / "**.md"),
	callback = function()
		vim.keymap.set("n", "gf", function()
			if require("obsidian").util.cursor_on_markdown_link() then
				return "<cmd>ObsidianFollowLink<CR>"
			else
				return "gf"
			end
		end, { noremap = false, expr = true })
	end,
})
