return {
  "lervag/vimtex",
  -- lazy = false, -- lazy-loading will disable inverse search
  ft = "tex",
  config = function()
    -- vim.api.nvim_create_autocmd({ "FileType" }, {
    --   group = vim.api.nvim_create_augroup("lazyvim_vimtex_conceal", { clear = true }),
    --   pattern = { "bib", "tex" },
    --   callback = function()
    --     -- vim.wo.conceallevel = 1
    --     -- Specify which characters to conceal in LaTeX documents
    --     vim.opt.conceallevel=1
    --     -- 	a = accents/ligatures
    --     -- 	b = bold and italic
    --     -- 	d = delimiters
    --     -- 	m = math symbols
    --     -- 	g = Greek
    --     -- 	s = superscripts/subscripts
    --     vim.g.tex_conceal='abdmgs'
    --   end,
    -- })


    vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
    vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"

    -- Set global variables
    vim.g.tex_flavor = 'latex'
    vim.g.vimtex_view_method = 'zathura'
    vim.g.vimtex_view_general_viewer = 'zathura'
    -- Disable the quickfix mode
    vim.g.vimtex_quickfix_mode=0
    vim.g.vimtex_mappings_enabled = 0
    vim.g.vimtex_imaps_enabled = 0
    vim.opt.conceallevel=1
    -- 	a = accents/ligatures
    -- 	b = bold and italic
    -- 	d = delimiters
    -- 	m = math symbols
    -- 	g = Greek
    -- 	s = superscripts/subscripts
    -- vim.g.tex_conceal='abdmgs'
    vim.g.vimtex_syntax_conceal = {
        accents = 1, -- Conceal accented characters, e.g. `\^a` --> `â`.
        ligatures = 1, -- Conceal ligatures such as `\aa` --> `å` and `''` --> `“`.
        cites = 1, -- Conceal LaTeX cite commands such as `\citet[...]{ref00}`. The conceal style is specified by |g:vimtex_syntax_conceal_cites|.
        fancy = 1, -- Some extra fancy replacements, e.g. `\item` --> ○.
        spacing = 1, -- Conceal spacing commands such as `\quad` and `\hspace{1em}` in both normal mode and math mode.
        greek = 1, -- Replace TeX greek letter commands into the equivalent unicode greek letter.
        math_bounds = 1, -- Conceal the TeX math bounds characters: pairs of `$` and `$$`, `\(` ... `\)`, and `\[` ... `\]`.
        -- Replace possibly modified math delimiters with a single unicode
        -- letter. Modified means delimiters prepended with e.g. `\left` or
        -- `\bigl`. As an example, this will perform the replacement

        --   `\Biggl\langle ... \Biggr\rangle` --> `〈 ... 〉`
        math_delimiters = 1,
        math_fracs = 1, -- Replace some simple fractions like `\frac 1 2` --> ½.
        math_super_sub = 1, -- Replace simple math super and sub operators, e.g. `x^2` --> `x²`.
        math_symbols = 1, -- Replace various math symbol commands to an equivalent unicode character. This includes quite a lot of replacements, so be warned!
        --   Conceal `\(sub)*section` commands. The titles are replaced with Markdown
        --   style ATX headers, e.g.:

        --     `\section{Test}`    --> `# Test`
        --     `\subsection{Test}` --> `## Test`
        sections = 1,
        --   Conceal the LaTeX command "boundaries" for italicized and bolded style
        --   commands, i.e. `\emph`, `\textit`, and `\textbf`. This means that one
        --   will see something like:

        --     `\emph{text here}` --> `text here`
        styles = 1,
    }

    -- Set list of delimiter toggle modifications
    vim.g.vimtex_delim_toggle_mod_list = {
        {'\\left', '\\right'},
        {'\\big', '\\big'},
    }
    
    -- Set compiler options for latexmk
    vim.g.vimtex_compiler_latexmk = {
        options = {
            '-pdf',
            '-shell-escape',
            '-verbose',
            '-file-line-error',
            '-synctex=1',
            '-interaction=nonstopmode',
        },
    }


    vim.g.vimtex_compiler_latexmk = {
        options = {
            '-pdf',
            '-shell-escape',
        },
    }
    
    vim.g.vimtex_quickfix_open_on_warning = 0 -- only opens quickfix menu on errors
    -- Uncomment and customize filters as needed
    -- vim.g.vimtex_quickfix_ignore_filters = {
    --     'Underfull \\hbox',
    --     'Overfull \\hbox',
    --     'LaTeX Warning: .+ float specifier changed to',
    --     'LaTeX hooks Warning',
    --     'Package siunitx Warning: Detected the "physics" package:',
    --     'Package hyperref Warning: Token not allowed in a PDF string',
    -- }
    
    -- change colors of concealed replacements
    
    vim.cmd [[
      highlight Conceal ctermfg=white guifg=white
    ]]


    -- KEYBINDINGS
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

  end,
}
