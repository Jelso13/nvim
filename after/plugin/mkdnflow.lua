local status_ok, mkdnflow = pcall(require, "mkdnflow")
if not status_ok then
    return
end

local setup = {
    modules = {
        -- follow citations and handling bib files
        bib = true,
        -- forward and backward navigation between buffers
        buffers = true,
        -- required for link concealing
        conceal = false,
        -- jumping to links and headings
        cursor = true,
        -- folding by section
        folds = false,
        -- creating and destroying links
        links = true,
        -- manipulating list items
        lists = true,
        -- used for setting mappings
        maps = true,
        -- link interpretion and follow links
        paths = true,
        -- table navigation and formatting
        tables = true
    },
    -- create link directories if they do not exist
    create_dirs = true,
    -- 
    perspective = {
        -- priority when interpreting link paths
        -- relative to given file [current, first(opened), root]
        priority = 'current',
        fallback = 'first',
        -- file name that can identify root directory
        root_tell = false,
        nvim_wd_heel = true
    },
    -- which filetypes can be controlled by mkdnflow
    filetypes = { md = true, rmd = true, markdown = true },
    -- whether to continue searching for md links at beginning of file
    wrap = false,
    bib = {
        -- path to look for citation keys
        default_path = nil,
        find_in_root = true
    },
    -- whether to display messages in the console
    silent = false,
    links = {
        -- link style 'markdown': [title](source) or 'wiki': [[source|title]]
        style = 'markdown',
        -- uses name as source for wiki links
        name_is_source = false,
        -- dont hide sources
        conceal = false,
        -- deals with extensions of links
        implicit_extension = nil,
        transform_implicit = false,
        -- transform links to be lowercase and replace spaces with dashes
        transform_explicit = function(text)
            text = text:gsub(" ", "-")
            text = text:lower()
            -- text = os.date('%Y-%m-%d_') .. text
            return (text)
        end
    },
    -- To do list stuff
    to_do = {
        symbols = { ' ', '-', 'X' },
        update_parents = true,
        not_started = ' ',
        in_progress = '-',
        complete = 'X'
    },
    tables = {
        -- should whitespace be trimmed from end of table cell
        trim_whitespace = true,
        -- format when the cursor moves with next/prev cell
        format_on_move = true,
        -- whether to add a row when navigating past last row
        auto_extend_rows = false,
        -- whether to add a row when navigating past last col
        auto_extend_cols = false
    },
    mappings = {
        MkdnEnter = { { 'n', 'v' }, '<CR>' , {desc="This is a test"}},
        -- 
        MkdnTab = false,
        MkdnSTab = false,
        MkdnNextLink = { 'n', '<Tab>' },
        MkdnPrevLink = { 'n', '<S-Tab>' },
        MkdnNextHeading = { 'n', ']]' },
        MkdnPrevHeading = { 'n', '[[' },
        MkdnGoBack = { 'n', '<BS>' },
        MkdnGoForward = { 'n', '<Del>' },
        MkdnFollowLink = false, -- see MkdnEnter
        MkdnDestroyLink = { 'n', '<M-CR>' },
        MkdnTagSpan = { 'v', '<M-CR>' },
        MkdnMoveSource = { 'n', '<F2>' },
        MkdnYankAnchorLink = { 'n', 'ya' },
        MkdnYankFileAnchorLink = { 'n', 'yfa' },
        MkdnIncreaseHeading = { 'n', '+' },
        MkdnDecreaseHeading = { 'n', '-' },
        MkdnToggleToDo = { { 'n', 'v' }, '<C-Space>' },
        MkdnNewListItem = false,
        MkdnNewListItemBelowInsert = { 'n', 'o' },
        MkdnNewListItemAboveInsert = { 'n', 'O' },
        MkdnExtendList = false,
        MkdnUpdateNumbering = { 'n', '<leader>nn' },
        MkdnTableNextCell = { 'i', '<Tab>' },
        MkdnTablePrevCell = { 'i', '<S-Tab>' },
        MkdnTableNextRow = false,
        MkdnTablePrevRow = { 'i', '<M-CR>' },
        MkdnTableNewRowBelow = { 'n', '<leader>ir' , {desc="testing table new row"}},
        MkdnTableNewRowAbove = { 'n', '<leader>iR' },
        MkdnTableNewColAfter = { 'n', '<leader>ic' },
        MkdnTableNewColBefore = { 'n', '<leader>iC' },
        MkdnFoldSection = { 'n', '<leader>f' },
        MkdnUnfoldSection = { 'n', '<leader>F' }
    }
}


-- follows a link, creates link from word or visual selection 
--  in insert mode can interface with table
vim.keymap.set({"n", "v"}, "<leader>ml", "<cmd>MkdnEnter<cr>", {desc="test thing"})
vim.keymap.set("n", "<leader>mf", "<cmd>MkdnFollowLink<cr>", {desc="follow link"})

mkdnflow.setup(setup)
