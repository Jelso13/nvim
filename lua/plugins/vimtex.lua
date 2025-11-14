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

    -- FOR REFOCUSING NEOVIM WITH ZATHURA
    -- Part 1: Capture Neovim's window ID when a TeX file is first opened.
    -- The `if` statement ensures this only runs once per session.
    if vim.g.vim_window_id == nil then
      vim.g.vim_window_id = vim.fn.system("xdotool getactivewindow")
    end

    -- Part 2: Define the function that will refocus Neovim.
    local function refocus_neovim()
      -- Give the window manager a moment (200ms) to switch focus to Zathura.
      -- You can tweak this value if needed.
      vim.cmd('sleep 200m')

      -- Use the stored window ID to tell xdotool to focus Neovim.
      vim.fn.system("xdotool windowfocus " .. vim.g.vim_window_id)

      -- Redraw the screen to fix any visual glitches.
      vim.cmd('redraw!')
    end

    -- Part 3: Create an autocommand to trigger the function.
    -- This runs the `refocus_neovim` function every time VimTeX's forward
    -- search event (`VimtexEventView`) is completed.
    vim.api.nvim_create_autocmd("User", {
      pattern = "VimtexEventView",
      callback = refocus_neovim,
    })

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


  end,
}
