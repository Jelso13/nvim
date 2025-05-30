-- vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
-- vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
-- 
-- vim.g.vimtex_view_method = "skim" -- <== macos specific, you can use zathura or sumatra or something else.
-- vim.g.vimtex_view_skim_sync = 1
-- vim.g.vimtex_view_skim_activate = 1
-- vim.g.vimtex_view_skim_reading_bar = 1
-- 
-- vim.g.vimtex_compiler_latexmk = {
--   aux_dir = "./aux",
--   out_dir = "./out",
-- }
-- 
-- -- Set global variables
-- vim.g.tex_flavor = 'latex'
-- vim.g.vimtex_view_method = 'zathura'
-- vim.g.vimtex_view_general_viewer = 'zathura'
-- vim.g.vimtex_mappings_enabled = 0
-- vim.g.vimtex_imaps_enabled = 0

-- -- Set list of delimiter toggle modifications
-- vim.g.vimtex_delim_toggle_mod_list = {
--     {'\\left', '\\right'},
--     {'\\big', '\\big'},
-- }
-- 
-- -- Set compiler options for latexmk
-- vim.g.vimtex_compiler_latexmk = {
--     options = {
--         '-pdf',
--         '-shell-escape',
--         '-verbose',
--         '-file-line-error',
--         '-synctex=1',
--         '-interaction=nonstopmode',
--     },
-- }


vim.opt.wrap = true

-- Set the maximum width of text for automatic line wrapping.
-- When you type beyond this width (80 characters), Neovim will automatically wrap the text to the next line.
-- vim.opt.textwidth = 80

-- This means that when text wraps, it will do so at the 'textwidth' limit 
-- without any additional margin. If wrapmargin was set to a positive value, 
-- it would cause wrapping to occur before reaching the textwidth.
-- vim.opt.wrapmargin = 0

-- Append 't' to the format options.
-- This enables automatic line wrapping when formatting text.
-- The 't' option allows the text to be automatically wrapped 
-- at the 'textwidth' setting when typing or reformatting.
-- vim.opt.formatoptions:append({ 't' })

-- Enable line breaking.
-- This allows Neovim to break lines at spaces or special characters 
-- rather than cutting off words in the middle. It helps maintain readability 
-- when lines are wrapped, especially for longer sentences or paragraphs.
vim.opt.linebreak = true

-- Set the conceal level to 1, which hides some characters in LaTeX
-- vim.opt.conceallevel=1


-- text objects
vim.keymap.set({"x","o"}, "ac", "<plug>(vimtex-ac)", { desc = "around commands" })
vim.keymap.set({"x","o"}, "ic", "<plug>(vimtex-ic)", { desc = "inside commands" })
vim.keymap.set({"x","o"}, "ad", "<plug>(vimtex-ad)", { desc = "around delimeters" })
vim.keymap.set({"x","o"}, "id", "<plug>(vimtex-id)", { desc = "inside delimeters" })
vim.keymap.set({"x","o"}, "ae", "<plug>(vimtex-ae)", { desc = "around environments" })
vim.keymap.set({"x","o"}, "ie", "<plug>(vimtex-ie)", { desc = "inside environments" })
vim.keymap.set({"x","o"}, "a$", "<plug>(vimtex-a$)", { desc = "around maths" })
vim.keymap.set({"x","o"}, "i$", "<plug>(vimtex-i$)", { desc = "inside maths" })
vim.keymap.set({"x","o"}, "aP", "<plug>(vimtex-aP)", { desc = "around sections" })
vim.keymap.set({"x","o"}, "iP", "<plug>(vimtex-iP)", { desc = "inside sections" })
vim.keymap.set({"x","o"}, "am", "<plug>(vimtex-am)", { desc = "around item" })
vim.keymap.set({"x","o"}, "im", "<plug>(vimtex-im)", { desc = "inside item" })

-- POSSIBLY TRIM THIS STUFF
-- motions
vim.keymap.set({"n", "x", "o"}, '%', '<Plug>(vimtex-%)', { desc = "matching delimeter"})
vim.keymap.set({"n", "x", "o"}, '[[', '<Plug>(vimtex-[[)', { desc = "prev section"})
vim.keymap.set({"n", "x", "o"}, ']]', '<Plug>(vimtex-]])', { desc = "next section"})
vim.keymap.set({"n", "x", "o"}, "]]", "<plug>(vimtex-]])", { desc = "go to next end of a section"})
vim.keymap.set({"n", "x", "o"}, "][", "<plug>(vimtex-][)", { desc = "go to next beginning of a section"})
vim.keymap.set({"n", "x", "o"}, "[]", "<plug>(vimtex-[])", { desc = "go to previous end of a section"})
vim.keymap.set({"n", "x", "o"}, "[[", "<plug>(vimtex-[[)", { desc = "go to previous beginning of a section"})
vim.keymap.set({"n", "x", "o"}, "]m", "<plug>(vimtex-]m)", { desc = "go to next start of an environment"})
vim.keymap.set({"n", "x", "o"}, "]M", "<plug>(vimtex-]M)", { desc = "go to next end of an environment"})
vim.keymap.set({"n", "x", "o"}, "[m", "<plug>(vimtex-[m)", { desc = "go to previous start of an environment"})
vim.keymap.set({"n", "x", "o"}, "[M", "<plug>(vimtex-[M)", { desc = "go to previous end of an environment"})
vim.keymap.set({"n", "x", "o"}, "]n", "<plug>(vimtex-]n)", { desc = "go to next start of a math zone"})
vim.keymap.set({"n", "x", "o"}, "]N", "<plug>(vimtex-]N)", { desc = "go to next end of a math zone"})
vim.keymap.set({"n", "x", "o"}, "[n", "<plug>(vimtex-[n)", { desc = "go to previous start of a math zone"})
vim.keymap.set({"n", "x", "o"}, "[N", "<plug>(vimtex-[N)", { desc = "go to previous end of a math zone"})
vim.keymap.set({"n", "x", "o"}, "]r", "<plug>(vimtex-]r)", { desc = "go to next start of a frame environment"})
vim.keymap.set({"n", "x", "o"}, "]R", "<plug>(vimtex-]R)", { desc = "go to next end of a frame environment"})
vim.keymap.set({"n", "x", "o"}, "[r", "<plug>(vimtex-[r)", { desc = "go to previous start of a frame environment"})
vim.keymap.set({"n", "x", "o"}, "[R", "<plug>(vimtex-[R)", { desc = "go to previous end of a frame environment"})
vim.keymap.set({"n", "x", "o"}, "]/", "<plug>(vimtex-]/", { desc = "go to next start of a LaTeX comment"})
vim.keymap.set({"n", "x", "o"}, "]*", "<plug>(vimtex-]star", { desc = "go to next end of a LaTeX comment"})
vim.keymap.set({"n", "x", "o"}, "[/", "<plug>(vimtex-[/" , { desc = "go to previous start of a LaTeX comment"})
vim.keymap.set({"n", "x", "o"}, "[*", "<plug>(vimtex-[star", { desc = "go to previous end of a LaTeX comment"})

-- local leader commands
-- vim.keymap.set('n', '<localleader>li', '<Plug>(vimtex-info)', { desc = "latex info", noremap = false })
vim.keymap.set('n', '<localleader>l', '<Plug>(vimtex-compile)', { desc = "latex compile", noremap = false })
vim.keymap.set("n", "<localleader>v", "<plug>(vimtex-view)", { desc = "view document" })
vim.keymap.set("n", "<localleader>t", "<plug>(vimtex-toc-open)", { desc = "open table of contents" })
vim.keymap.set("n", "<localleader>T", "<plug>(vimtex-toc-toggle)", { desc = "toggle table of contents" })
vim.keymap.set("n", "<localleader>q", "<plug>(vimtex-log)", { desc = "open logs" })
vim.keymap.set("n", "<localleader>e", "<plug>(vimtex-errors)", { desc = "open compile errors" })
vim.keymap.set("n", "<localleader>k", "<plug>(vimtex-stop)", { desc = "kill/stop" })
vim.keymap.set("n", "<localleader>o", "<plug>(vimtex-compile-output)", { desc = "compile output" })
vim.keymap.set("n", "<localleader>g", "<plug>(vimtex-status)", { desc = "status" })
vim.keymap.set("n", "<localleader>c", "<plug>(vimtex-clean)", { desc = "clean" })
-- vim.keymap.set("n", "<localleader>a", "<plug>(vimtex-context-menu)", { desc = "show context menu" })
vim.keymap.set("n", "<localleader>w", "<cmd>VimtexCountWords<cr>", { desc = "Display the word count" })

-- other mappings
vim.keymap.set("n", "dse", "<plug>(vimtex-env-delete)", { desc = "delete surrounding environment"})
vim.keymap.set("n", "dsc", "<plug>(vimtex-cmd-delete)" , { desc = "delete surrounding command"})
vim.keymap.set("n", "ds$", "<plug>(vimtex-env-delete-math)", { desc = "delete surrounding maths"})
vim.keymap.set("n", "dsd", "<plug>(vimtex-delim-delete)", { desc = "delete surrounding delimeter"})
vim.keymap.set("n", "cse", "<plug>(vimtex-env-change)", { desc = "change surrounding environment"})
vim.keymap.set("n", "csc", "<plug>(vimtex-cmd-change)", { desc = "change surrounding command"})
vim.keymap.set("n", "cs$", "<plug>(vimtex-env-change-math)", { desc = "change surrounding math"})
vim.keymap.set("n", "csd", "<plug>(vimtex-delim-change-math)", { desc = "change surrounding delimeter"})
vim.keymap.set({"n","x"}, "tsf", "<plug>(vimtex-cmd-toggle-frac)", { desc = "toggle fraction"})
vim.keymap.set({"n","x"}, "tsd", "<plug>(vimtex-delim-toggle-modifier)", { desc = "toggle delimeter"})
vim.keymap.set("n", "ts$", "<plug>(vimtex-env-toggle-math)", { desc = "toggle env math"})
vim.keymap.set("i", ']]', '<Plug>(vimtex-delim-close)', { desc = "close delimeter"})


-- ################### CUSTOM COMMANDS #####################################



-- change j and k to act like gj and gk which respect soft-wrapped lines
vim.api.nvim_set_keymap('n', 'j', 'gj', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'k', 'gk', { noremap = true, silent = true })

