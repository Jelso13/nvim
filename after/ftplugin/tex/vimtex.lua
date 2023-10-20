vim.cmd([[
    let g:tex_flavor='latex'
    let g:vimtex_view_method='zathura'
    let g:vimtex_view_general_viewer = 'zathura'
    let g:vimtex_mappings_enabled = 0
    let g:vimtex_imaps_enabled = 0
    let g:vimtex_delim_toggle_mod_list = [
        \ ['\left', '\right'],
        \ ['\big', '\big'],
        \]
    let g:vimtex_compiler_latexmk = {
        \ 'options' : [
        \   '-pdf',
        \   '-shell-escape',
        \   '-verbose',
        \   '-file-line-error',
        \   '-synctex=1',
        \   '-interaction=nonstopmode',
        \ ],
        \}
]])

vim.g.vimtex_compiler_latexmk = {
    options = {
        '-pdf',
        '-shell-escape',
    },
}

-- g:vimtex_quickfix_open_on_warning = 0 only opens quickfix menu on errors
--
--filters out specific messages
-- let g:vimtex_quickfix_ignore_filters = [
--       \ 'Underfull \\hbox',
--       \ 'Overfull \\hbox',
--       \ 'LaTeX Warning: .\+ float specifier changed to',
--       \ 'LaTeX hooks Warning',
--       \ 'Package siunitx Warning: Detected the "physics" package:',
--       \ 'Package hyperref Warning: Token not allowed in a PDF string',
--       \]
