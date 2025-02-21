
-- only run if conform is available:
if not pcall(require, "conform") then
  return
end

require("conform").formatters.black = {
  prepend_args = { "-l", "80" },
}


-- include telescope plugin for searching all possible python help pages
-- vim.keymap.set("n", "<leader>hl", builtin.keymaps, { desc = "[H]elp [L]anguage (python)" })
-- python -m pydoc 
--
vim.keymap.set("n", "<leader>hl", function()
  require("telescope.builtin").help_tags({ cwd = vim.fn.stdpath("data") .. "/site/pack/packer/start/telescope.nvim" })
end, { desc = "[H]elp [L]anguage (python)" })
