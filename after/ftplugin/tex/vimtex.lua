
-- ################### DEFAULT COMMANDS #####################################
--
--
-- -- disable vimtex mappings
-- vim.g.vimtex_mappings_enabled = 0
-- vim.g.vimtex_imaps_enabled = 0


-- <F6>             |<plug>(vimtex-env-surround-line)|              `n`
--                  |<plug>(vimtex-env-surround-operator)|          `n`
-- <F6>             |<plug>(vimtex-env-surround-visual)|            `x`
-- tsd              |<plug>(vimtex-delim-toggle-modifier)|          `nx`
-- tsD              |<plug>(vimtex-delim-toggle-modifier-reverse)|  `nx`
-- <F7>             |<plug>(vimtex-cmd-create)|                     `nxi
-- ]]               |<plug>(vimtex-delim-close)|                    `i`
-- <F8>             |<plug>(vimtex-delim-add-modifiers)|            `n`
--

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
vim.keymap.set('n', '<localleader>li', '<Plug>(vimtex-info)', { desc = "latex info", noremap = false })
vim.keymap.set('n', '<localleader>ll', '<Plug>(vimtex-compile)', { desc = "latex compile", noremap = false })
vim.keymap.set("n", "<localleader>lv", "<plug>(vimtex-view)", { desc = "view document" })
vim.keymap.set("n", "<localleader>lt", "<plug>(vimtex-toc-open)", { desc = "open table of contents" })
vim.keymap.set("n", "<localleader>lT", "<plug>(vimtex-toc-toggle)", { desc = "toggle table of contents" })
vim.keymap.set("n", "<localleader>lq", "<plug>(vimtex-log)", { desc = "open logs" })
vim.keymap.set("n", "<localleader>lk", "<plug>(vimtex-stop)", { desc = "kill/stop" })
vim.keymap.set("n", "<localleader>lo", "<plug>(vimtex-compile-output)", { desc = "compile output" })
vim.keymap.set("n", "<localleader>lg", "<plug>(vimtex-status)", { desc = "status" })
vim.keymap.set("n", "<localleader>lc", "<plug>(vimtex-clean)", { desc = "clean" })
vim.keymap.set("n", "<localleader>la", "<plug>(vimtex-context-menu)", { desc = "show context menu" })
vim.keymap.set("n", "<localleader>lw", "<cmd>VimtexCountWords<cr>", { desc = "Display the word count" })

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


vim.keymap.set('n', '<localleader>c', '<Plug>(vimtex-compile)', { desc = "latex compile", noremap = false })
vim.keymap.set("n", "<localleader>v", "<plug>(vimtex-view)", { desc = "view document" })




