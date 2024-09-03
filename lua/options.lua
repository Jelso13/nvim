-- put all the vim options here
-- Still need to organise

-- INDENTATION OPTIONS
vim.opt.autoindent = true -- new lines inherit indentation
vim.opt.smartindent = true -- makes auto-indent not suck
vim.opt.expandtab = true -- converts tabs to spaces
vim.opt.smarttab = true -- deletes spaces of 'shiftwidth'
vim.opt.shiftround = true -- round line indentation to nearest 'shiftwidth'
vim.opt.shiftwidth = 4 -- indent 4 spaces
vim.opt.smarttab = true -- insert 'tabstop' spaces for every tab
vim.opt.tabstop = 4 -- indent using 4 spaces
vim.opt.softtabstop = 4 -- number of spaces a tab stands for when editing

-- SEARCH OPTIONS
vim.opt.hlsearch = false -- enables search highlighting
vim.opt.incsearch = true -- searches for each character added

-- PERFORMANCE OPTIONS
-- vim.opt.lazyredraw               -- dont update screen during macro and script execution

-- TEXT RENDERING OPTIONS
vim.opt.encoding = "utf-8" -- use an encoding that supports unicode
vim.opt.scrolloff = 5 -- keep 5 lines when scrolling
-- vim.opt.sidescrolloff = 10          -- keep 5 columns when side scrolling
vim.opt.linebreak = true -- avoid wrapping a line in the middle of a word
vim.opt.wrap = false -- prevents wrapping of long lines
vim.opt.conceallevel = 1 -- makes `` visible in markdown files

-- USER INTERFACE OPTIONS
-- vim.opt.laststatus = 2              -- always display the status bar
vim.opt.colorcolumn = "80" -- color line at given column
vim.opt.signcolumn = "no" -- shows sign column on left side if anything to show "auto"
vim.opt.ruler = false -- set the ruler
vim.opt.tabpagemax = 50 -- max number of tab pages can be opened from term
vim.opt.number = true -- set numbered lines
vim.opt.relativenumber = true -- set relative numbered lines
-- vim.opt.errorbells = false          -- no idea why anyone would want errorbells
vim.opt.mouse = "a" -- enable mouse for scrolling and resizing
-- vim.opt.mousehide = true            -- hide the mouse while typing

-- SPLIT OPTIONS
-- vim.opt.splitbelow = true            -- force all horizontal splits to go below current window
-- vim.opt.splitright = true            -- force all vertical splits to go right of the current window

-- CODE FOLDING OPTIONS
-- Display the fold indicator on the left side
vim.opt.foldcolumn = "1"
vim.opt.foldmethod = "manual"
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt.foldmethod="syntax"
-- vim.opt.foldlevelstart = 0

vim.opt.foldtext = "v:lua.MyFoldText()"
function MyFoldText()
	-- gets the first line of the fold
	local line = vim.fn.getline(vim.v.foldstart)
	local sub = line:gsub("/%*%*?%*?%d?=", ""):gsub("%*/", ""):gsub("{{{%d?=", "")
	-- calculate the number of lines in the fold
	local fold_size = vim.v.foldend - vim.v.foldstart + 1
	-- format the fold text with the number of lines on the right
	return vim.v.folddashes .. sub .. " (" .. fold_size .. " lines)"
end

-- determines what mkview does - should save folds and cursor position (default includes the current directory)
vim.opt.viewoptions = { "folds", "cursor" }

-- Prevent folds from opening during navigation
-- vim.opt.foldopen = "block,hor,insert,jump,mark,percent,quickfix,search,tag,undo"
vim.opt.foldopen = "hor,insert,jump,mark,percent,quickfix,tag,undo"
-- vim.opt.foldopen = ""
--
--- The below line creates a group of autocommands that will save and load the view of the file, clear the group before creating it
--- Save view when leaving a buffer
local foldable_types = {
	"*.py",
	"*.js",
	"*.rs",
	"*.tex",
	"*.md",
	"*.c",
	"*.cpp",
	"*.h",
	"*.sh",
	"*.vim",
	"*.lua",
	"*.yaml",
	"*.yml",
	"*.json",
	"*.toml",
	"*.html",
	"*.css",
}
--
-- Define an augroup to group the autocommands
local group = vim.api.nvim_create_augroup("SaveLoadView", { clear = true })

-- Save view when leaving a buffer
vim.api.nvim_create_autocmd("BufWinLeave", {
	group = group,
	pattern = foldable_types,
	command = "mkview",
})

-- Load view when entering a buffer
vim.api.nvim_create_autocmd("BufWinEnter", {
	group = group,
	pattern = foldable_types,
	command = "silent! loadview",
})
-- vim.api.nvim_create_augroup('remember_folds', { clear = true })
-- -- the below line creates an autocommand that will save the view of the file when the window is closed
-- vim.api.nvim_create_autocmd('bufwinleave', {
--   group = 'remember_folds',
--   pattern = '*',
--   desc = "save view of file when window is closed",
--   callback = function()
--       if vim.bo.buftype == '' then
--           vim.cmd('mkview')
--       end
--   end
-- })
-- -- the below line creates an autocommand that will load the view of the file when the window is entered
-- vim.api.nvim_create_autocmd('bufwinenter', {
--   group = 'remember_folds',
--   pattern = '*',
--   callback = function()
--       if vim.bo.buftype == '' then
--           vim.cmd('silent loadview')
--       end
--   end,
--   desc = "load view of file when window is entered"
-- })

-- CLIPBOARD OPTIONS
--  Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
end)

-- FILE STUFF OPTIONS (NEED TO RENAME AND RESORT)
vim.opt.swapfile = false -- creates a swap file (unsure why I need)
vim.opt.backup = false -- creates a backup file (also unsure why I need)
-- allow the undotree to last for a long time
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- for some reason been having issues with this breaking leader
vim.opt.timeoutlen = 300 -- time to wait for a mapped sequence to complete (in milliseconds)
-- vim.opt.ttimeoutlen = 1000
-- vim.opt.undofile = true

-- MISC OPTIONS
vim.opt.history = 1000 -- increase the undo limit
vim.opt.nrformats = "bin,hex" -- sets the formats that can be used by Ctrl-A and Ctrl-X
vim.opt.hidden = true -- can have hidden buffers without saving
vim.opt.showcmd = true -- display partial commands
vim.opt.termguicolors = true -- allow wider terminal colors
vim.opt.updatetime = 50 -- updatetime {default 4000ms} noticable delays and sucks

-- POSSIBLY MOVE THIS
vim.g.mapleader = " "
vim.g.maplocalleader = "-"

-- NETRW
vim.g.netrw_browse_split = 0 -- in the default popup window rather than split or something
vim.g.netrw_banner = 0 -- remove the banner fofalser netrw
-- set netrw to show the line numbers, remove color column
vim.g.netrw_bufsettings = 'noma nomod nu rnu colorcolumn=""' -- default values of noma nomod nu nowrap ro nobl

-- SPELLING
vim.opt.spelllang = "en_gb"

-- Font
-- set font to meslo nerd font size 11 (for firenvim)
-- vim.opt.guifont="MesloLGS NF:11"
-- vim.opt.guifont="RobotoMono"

-- set guifont=RobotoMono\ Nerd\ Font:h12
-- vim.opt.guifont="RobotoMono Nerd Font:h12"
vim.opt.guifont = "RobotoMono Nerd Font Mono:h12"
--
-- vim.opt.whichwrap:append "-"
-- vim.opt.iskeyword:append "-"     -- determines what determines delimeter for w movement

-- vim.opt.numberwidth = 2             -- set number column width to 2 {default 4}

-- determines what characters are included in the detection of filenames
-- vim.opt.isfname:append("@-@")    -- no idea?

-- vim.opt.shortmess:append("c")    -- 'Dont pass messages to |ins-completion-menu|'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Enable break indent
-- Every wrapped line will continue visually indented (same amount of
-- space as the beginning of that line), thus preserving horizontal blocks
-- of text.
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- SPLIT OPTIONS
vim.opt.splitright = true -- force all vertical splits to go right of the current window
vim.opt.splitbelow = true -- force all horizontal splits to go below current window

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "nosplit" -- set to split to open a preview window

-- Highlight which line your cursor is on
vim.opt.cursorline = true
