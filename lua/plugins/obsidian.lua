-- make it so that it is only loaded when the file is within ~/Vault

return {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    event = {
        "BufReadPre " .. vim.fn.expand("~") .. "/Vault/*.md",
        "BufNewFile " .. vim.fn.expand("~") .. "/Vault/*.md",
    },
    opts = {
        legacy_commands = false,
        preferred_link_style = "markdown",
        workspaces = { { name = "Vault", path = "~/Vault" } },
        -- opens with xdg
        follow_url_func = function(url)
            vim.fn.jobstart({ "xdg-open", url }) -- linux
        end,
        follow_img_func = function(url)
            vim.fn.jobstart({ "xdg-open", url }) -- linux
        end,
        callbacks = {
            enter_note = function(note)
                vim.keymap.set("n", "<leader>od", "<cmd>Obsidian daily<cr>", {
                    buffer = note.bufnr,
                    desc = "[O]bsidian [D]aily",
                })
                vim.keymap.set("n", "<leader>od", "<cmd>Obsidian daily<cr>", {
                    buffer = note.bufnr,
                    desc = "[O]bsidian [D]aily",
                })
                -- :%s/{\​(.\{-}\)}/
                -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
                vim.keymap.set("n", "gf", function()
                    return require("obsidian").util.gf_passthrough()
                end, {
                    noremap = false,
                    expr = true,
                    buffer = true,
                })
                -- Toggle check-boxes.
                vim.keymap.set("n", "<leader>oc", function()
                    return require("obsidian").util.toggle_checkbox()
                end, {
                    buffer = true,
                    desc = "[O]bsidian [C]heckbox",
                })
                -- Smart action depending on context, either follow link or toggle checkbox.
                vim.keymap.set("n", "<cr>", function()
                    return require("obsidian").util.smart_action()
                end, {
                    buffer = true,
                    expr = true,
                    desc = "[O]bsidian action",
                })
                vim.keymap.set("n", "<leader>ot", function()
                    return "<cmd> Obsidian tags <CR>"
                end, {
                    buffer = true,
                    expr = true,
                    desc = "[O]bsidian [T]ags",
                })
                vim.keymap.set("n", "<localleader>o", function()
                    return "<cmd> Obsidian open <CR>"
                end, {
                    buffer = true,
                    expr = true,
                    desc = "[O]bsidian [O]pen",
                })
                vim.keymap.set("n", "<leader>oo", function()
                    return "<cmd> Obsidian open <CR>"
                end, {
                    buffer = true,
                    expr = true,
                    desc = "[O]bsidian [O]pen",
                })
                vim.keymap.set(
                    "n",
                    "<localleader>d",
                    function()
                        return "<cmd> Obsidian today <CR>"
                    end,
                    { buffer = true, expr = true, desc = "[O]bsidian [D]aily" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>od",
                    function()
                        return "<cmd> Obsidian today <CR>"
                    end,
                    { buffer = true, expr = true, desc = "[O]bsidian [D]aily" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>ob",
                    function()
                        return "<cmd> Obsidian backlinks <CR>"
                    end,
                    {
                        buffer = true,
                        expr = true,
                        desc = "[O]bsidian [B]acklinks",
                    }
                )
                vim.keymap.set(
                    "n",
                    "<leader>or",
                    function()
                        return "<cmd> Obsidian rename <CR>"
                    end,
                    {
                        buffer = true,
                        expr = true,
                        desc = "[O]bsidian [R]ename across vault",
                    }
                )
                vim.keymap.set("n", "<leader>on", function()
                    return "<cmd> Obsidian new <CR>"
                end, {
                    buffer = true,
                    expr = true,
                    desc = "[O]bsidian [N]ew",
                })
                vim.keymap.set(
                    "n",
                    "<localleader>sl",
                    function()
                        return "<cmd> Obsidian links <CR>"
                    end,
                    {
                        buffer = true,
                        expr = true,
                        desc = "[S]earch Obsidian [L]inks",
                    }
                )
                vim.keymap.set(
                    "n",
                    "<localleader>sb",
                    function()
                        return "<cmd> Obsidian backlinks <CR>"
                    end,
                    {
                        buffer = true,
                        expr = true,
                        desc = "[S]earch Obsidian [B]acklinks",
                    }
                )
                vim.keymap.set(
                    "n",
                    "<localleader>sd",
                    function()
                        return "<cmd> Obsidian dailies <CR>"
                    end,
                    {
                        buffer = true,
                        expr = true,
                        desc = "[S]earch Obsidian [D]aily Notes",
                    }
                )
                vim.keymap.set(
                    "n",
                    "<localleader>st",
                    function()
                        return "<cmd> Obsidian tags <CR>"
                    end,
                    {
                        buffer = true,
                        expr = true,
                        desc = "[S]earch Obsidian [T]ags",
                    }
                )
                vim.keymap.set(
                    "n",
                    "<localleader>sh",
                    function()
                        return "<cmd> Obsidian TOC <CR>"
                    end,
                    { buffer = true, expr = true, desc = "[S]earch [H]eaders" }
                )
            end,
        },
        ui = {
            enable = true,
            ignore_conceal_warn = false,
            update_debounce = 200,
            max_file_length = 5000,
            checkboxes = {
                [" "] = { char = "󰄱", hl_group = "obsidiantodo" },
                ["~"] = { char = "󰰱", hl_group = "obsidiantilde" },
                ["!"] = { char = "", hl_group = "obsidianimportant" },
                [">"] = { char = "", hl_group = "obsidianrightarrow" },
                ["x"] = { char = "", hl_group = "obsidiandone" },
            },
            bullets = { char = "•", hl_group = "ObsidianBullet" },
            external_link_icon = {
                char = "",
                hl_group = "ObsidianExtLinkIcon",
            },
            reference_text = { hl_group = "ObsidianRefText" },
            highlight_text = { hl_group = "ObsidianHighlightText" },
            tags = { hl_group = "ObsidianTag" },
            block_ids = { hl_group = "ObsidianBlockID" },
            hl_groups = {
                ObsidianTodo = { bold = true, fg = "#f78c6c" },
                ObsidianDone = { bold = true, fg = "#89ddff" },
                ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
                ObsidianTilde = { bold = true, fg = "#ff5370" },
                ObsidianImportant = { bold = true, fg = "#d73128" },
                ObsidianBullet = { bold = true, fg = "#89ddff" },
                ObsidianRefText = { underline = true, fg = "#c792ea" },
                ObsidianExtLinkIcon = { fg = "#c792ea" },
                ObsidianTag = { italic = true, fg = "#89ddff" },
                ObsidianBlockID = { italic = true, fg = "#89ddff" },
                ObsidianHighlightText = { bg = "#75662e" },
            },
        },

        note_id_func = function(title)
            -- sets how new notes are named
            local suffix = ""
            if title ~= nil then
                -- If title is given, transform it into valid file name.
                suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
            else
                -- If title is nil, just add 4 random uppercase letters to the suffix.
                for _ = 1, 4 do
                    suffix = suffix .. string.char(math.random(65, 90))
                end
            end
            -- return tostring(os.time()) .. "-" .. suffix
            return tostring(suffix)
        end,
        footer = {
            enabled = true, -- turn it off
            separator = string.rep("-", 80), -- turn it off
            -- separator = "", -- insert a blank line
            format = "{{backlinks}} backlinks  {{properties}} properties  {{words}} words  {{chars}} chars", -- works like the template system
            -- format = "({{backlinks}} backlinks)", -- limit to backlinks
            hl_group = "Comment", -- Use another hl group
        },
        daily_notes = {
            folder = "Misc/daily_notes",
            date_format = "%Y-%m-%d",
            default_tags = { "daily-note" },
            -- template = "templates/daily.md"
        },
        checkbox = {
            enabled = true,
            create_new = true,
            order = { " ", "x", "~", "!", ">" },
        },
    },
}

-- return {
--     "epwalsh/obsidian.nvim",
--     version = "*", -- recommended, use latest release instead of latest commit
--     lazy = true,
--     -- ft = "markdown",
--     -- Don't apply outside the vault
--     event = {
--         "BufReadPre " .. vim.fn.expand("~") .. "/Vault/*.md",
--         "BufNewFile " .. vim.fn.expand("~") .. "/Vault/*.md"
--     },
--     -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
--     -- event = {
--     --     --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
--     --     --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
--     --     --   -- refer to `:h file-pattern` for more examples
--     --     --   "BufReadPre path/to/my-vault/*.md",
--     --     --   "BufNewFile path/to/my-vault/*.md",
--     --     "BufReadPre "
--     --         .. vim.fn.expand("~")
--     --         .. "/Vault/*.md",
--     --     "BufNewFile " .. vim.fn.expand("~") .. "/Vault/*.md",
--     -- },
--     dependencies = {
--         -- Required.
--         "nvim-lua/plenary.nvim",
--
--         -- see below for full list of optional dependencies 👇
--     },
--     opts = {
--         workspaces = {
--             {
--                 name = "Vault",
--                 path = "~/Vault",
--             },
--             {
--                 name = "no-vault",
--                 path = function()
--                     -- alternatively use the CWD:
--                     -- return assert(vim.fn.getcwd())
--                     return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
--                 end,
--                 overrides = {
--                     notes_subdir = vim.NIL, -- have to use 'vim.NIL' instead of 'nil'
--                     -- new_notes_location = "current_dir",
--                     -- templates = {
--                     --     --folder = vim.NIL,
--                     -- },
--                     disable_frontmatter = true,
--                 },
--             },
--         },
--         dir = "~/Vault",
--         daily_notes = {
--             folder = "Misc/daily_notes",
--             date_format = "%Y-%m-%d",
--             default_tags = { "daily-note" }
--             -- template = "templates/daily.md"
--         },
--         completion = {
--             nvim_cmp = false,
--         },
--         -- -- Optional, customize how markdown links are formatted.
--         -- markdown_link_func = function(opts)
--         --     local util = require("obsidian.util")
--         --     local client = require("obsidian").get_client()
--         --     local anchor = ""
--         --     local header = ""
--
--         --     if opts.anchor then
--         --         anchor = opts.anchor.anchor
--         --         header = util.format_anchor_label(opts.anchor)
--         --     elseif opts.block then
--         --         anchor = "#" .. opts.block.id
--         --         header = "#" .. opts.block.id
--         --     end
--
--         --     -- This is now an absolute path to the file.
--         --     local path = client.dir / opts.path
--         --     -- This is an absolute path to the current buffer's parent directory.
--         --     local buf_dir = client.buf_dir
--
--         --     local rel_path
--         --     if buf_dir:is_parent_of(path) then
--         --         rel_path = tostring(path:relative_to(buf_dir))
--         --     else
--         --         local parents = buf_dir:parents()
--         --         for i, parent in ipairs(parents) do
--         --             if parent:is_parent_of(path) then
--         --                 rel_path = string.rep("../", i)
--         --                     .. tostring(path:relative_to(parent))
--         --                 break
--         --             end
--         --         end
--         --     end
--
--         --     local encoded_path =
--         --         util.urlencode(rel_path, { keep_path_sep = true })
--         --     return string.format(
--         --         "[%s%s](%s%s)",
--         --         opts.label,
--         --         header,
--         --         encoded_path,
--         --         anchor
--         --     )
--         -- end,
--         -- markdown_link_func = function(opts)
--         --   return require("obsidian.util").markdown_link(opts)
--         -- end,
--         preferred_link_style = "markdown",
--         -- Where to put new notes. Valid options are
--         --  * "current_dir" - put new notes in same directory as the current buffer.
--         --  * "notes_subdir" - put new notes in the default notes subdirectory.
--         new_notes_location = "current_dir",
--         -- Optional, customize how note IDs are generated given an optional title.
--         ---@param title string|?
--         ---@return string
--         -- note_id_func = function(title)
--         --     -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
--         --     -- In this case a note with the title 'My new note' will be given an ID that looks
--         --     -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
--         --     local suffix = ""
--         --     if title ~= nil then
--         --         -- If title is given, transform it into valid file name.
--         --         suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
--         --     else
--         --         -- If title is nil, just add 4 random uppercase letters to the suffix.
--         --         for _ = 1, 4 do
--         --             suffix = suffix .. string.char(math.random(65, 90))
--         --         end
--         --     end
--         --     -- return tostring(os.time()) .. "-" .. suffix
--         --     return tostring(suffix)
--         -- end,
--         -- Optional, customize how note file names are generated given the ID, target directory, and title.
--         ---@param spec { id: string, dir: obsidian.Path, title: string|? }
--         ---@return string|obsidian.Path The full path to the new note.
--         -- note_path_func = function(spec)
--         --     -- This is equivalent to the default behavior.
--         --     local path = spec.dir / tostring(spec.id)
--         --     return path:with_suffix(".md")
--         -- end,
--         -- Don't bother with templates - just use snippets instead
--         -- templates = {
--         --     folder = "Misc/templates",
--         --     date_format = "%Y-%m-%d",
--         --     time_format = "%H:%M",
--         --     -- A map for custom variables, the key should be the variable and the value a function
--         --     substitutions = {},
--         -- },
--         ---@param url string
--         follow_url_func = function(url)
--             -- Open the URL in the default web browser.
--             -- vim.fn.jobstart({"open", url})  -- Mac OS
--             vim.fn.jobstart({ "xdg-open", url }) -- linux
--             -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
--             -- vim.ui.open(url) -- need Neovim 0.10.0+
--         end,
--
--         picker = {
--             -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
--             name = "telescope.nvim",
--             -- Optional, configure key mappings for the picker. These are the defaults.
--             -- Not all pickers support all mappings.
--             note_mappings = {
--                 -- Create a new note from your query.
--                 -- new = "<C-x>",
--                 -- Insert a link to the selected note.
--                 insert_link = "<C-l>",
--             },
--             tag_mappings = {
--                 -- Add tag(s) to current note.
--                 tag_note = "<C-x>",
--                 -- Insert a tag at the current location.
--                 insert_tag = "<C-l>",
--             },
--         },
--         -- Optional, sort search results by "path", "modified", "accessed", or "created".
--         -- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
--         -- that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time
--         sort_by = "modified",
--         sort_reversed = true,
--         -- Set the maximum number of lines to read from notes on disk when performing certain searches.
--         search_max_lines = 1000,
--         -- Optional, determines how certain commands open notes. The valid options are:
--         -- 1. "current" (the default) - to always open in the current window
--         -- 2. "vsplit" - to open in a vertical split if there's not already a vertical split
--         -- 3. "hsplit" - to open in a horizontal split if there's not already a horizontal split
--         open_notes_in = "current",
--         -- Optional, configure additional syntax highlighting / extmarks.
--         -- This requires you have `conceallevel` set to 1 or 2. See `:help conceallevel` for more details.
--         ui = {
--             enable = true, -- set to false to disable all additional syntax features
--             update_debounce = 200, -- update delay after a text change (in milliseconds)
--             max_file_length = 5000, -- disable UI features for files with more than this many lines
--             -- Define how various check-boxes are displayed
--             checkboxes = {
--                 -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
--                 [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
--                 ["x"] = { char = "", hl_group = "ObsidianDone" },
--                 [">"] = { char = "", hl_group = "ObsidianRightArrow" },
--                 ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
--                 ["!"] = { char = "", hl_group = "ObsidianImportant" },
--                 -- Replace the above with this if you don't have a patched font:
--                 -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
--                 -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },
--
--                 -- You can also add more custom ones...
--             },
--             -- Use bullet marks for non-checkbox lists.
--             bullets = { char = "•", hl_group = "ObsidianBullet" },
--             external_link_icon = {
--                 char = "",
--                 hl_group = "ObsidianExtLinkIcon",
--             },
--             -- Replace the above with this if you don't have a patched font:
--             -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
--             reference_text = { hl_group = "ObsidianRefText" },
--             highlight_text = { hl_group = "ObsidianHighlightText" },
--             tags = { hl_group = "ObsidianTag" },
--             block_ids = { hl_group = "ObsidianBlockID" },
--             hl_groups = {
--                 -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
--                 ObsidianTodo = { bold = true, fg = "#f78c6c" },
--                 ObsidianDone = { bold = true, fg = "#89ddff" },
--                 ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
--                 ObsidianTilde = { bold = true, fg = "#ff5370" },
--                 ObsidianImportant = { bold = true, fg = "#d73128" },
--                 ObsidianBullet = { bold = true, fg = "#89ddff" },
--                 ObsidianRefText = { underline = true, fg = "#c792ea" },
--                 ObsidianExtLinkIcon = { fg = "#c792ea" },
--                 ObsidianTag = { italic = true, fg = "#89ddff" },
--                 ObsidianBlockID = { italic = true, fg = "#89ddff" },
--                 ObsidianHighlightText = { bg = "#75662e" },
--             },
--         },
--         -- Optional, configure key mappings. These are the defaults. If you don't want to set any keymappings this
--         -- way then set 'mappings = {}'.
--         -- mappings = {
--         --     -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
--         --     ["gf"] = {
--         --         action = function() return require("obsidian").util.gf_passthrough() end,
--         --         opts = { noremap = false, expr = true, buffer = true },
--         --     },
--         --     -- Toggle check-boxes.
--         --     ["<leader>oc"] = {
--         --         action = function() return require("obsidian").util.toggle_checkbox() end,
--         --         opts = { buffer = true, desc = "[O]bsidian [C]heckbox" },
--         --     },
--         --     -- Smart action depending on context, either follow link or toggle checkbox.
--         --     ["<cr>"] = {
--         --         action = function() return require("obsidian").util.smart_action() end,
--         --         opts = { buffer = true, expr = true, desc = "[O]bsidian action", },
--         --     },
--         --     ["<leader>ot"] = {
--         --         action = function() return "<cmd> ObsidianTags <CR>" end,
--         --         opts = { buffer = true, expr = true, desc = "[O]bsidian [T]ags", },
--         --     },
--         --     ["<localleader>o"] = {
--         --         action = function() return "<cmd> ObsidianOpen <CR>" end,
--         --         opts = { buffer = true, expr = true, desc = "[O]bsidian [O]pen", },
--         --     },
--         --     ["<leader>oo"] = {
--         --         action = function() return "<cmd> ObsidianOpen <CR>" end,
--         --         opts = { buffer = true, expr = true, desc = "[O]bsidian [O]pen", },
--         --     },
--         --     ["<localleader>d"] = {
--         --         action = function() return "<cmd> ObsidianToday <CR>" end,
--         --         opts = { buffer = true, expr = true, desc = "[O]bsidian [D]aily", },
--         --     },
--         --     ["<leader>od"] = {
--         --         action = function() return "<cmd> ObsidianToday <CR>" end,
--         --         opts = { buffer = true, expr = true, desc = "[O]bsidian [D]aily", },
--         --     },
--         --     ["<leader>ob"] = {
--         --         action = function() return "<cmd> ObsidianBacklinks <CR>" end,
--         --         opts = { buffer = true, expr = true, desc = "[O]bsidian [B]acklinks", },
--         --     },
--         --     ["<leader>or"] = {
--         --         action = function() return "<cmd> ObsidianRename <CR>" end,
--         --         opts = { buffer = true, expr = true, desc = "[O]bsidian [R]ename across vault", },
--         --     },
--         --     ["<leader>on"] = {
--         --         action = function() return "<cmd> ObsidianNew <CR>" end,
--         --         opts = { buffer = true, expr = true, desc = "[O]bsidian [N]ew", },
--         --     },
--         --     ["<localleader>sl"] = {
--         --         action = function() return "<cmd> ObsidianLinks <CR>" end,
--         --         opts = { buffer = true, expr = true, desc = "[S]earch Obsidian [L]inks", },
--         --     },
--         --     ["<localleader>sb"] = {
--         --         action = function() return "<cmd> ObsidianBacklinks <CR>" end,
--         --         opts = { buffer = true, expr = true, desc = "[S]earch Obsidian [B]acklinks", },
--         --     },
--         --     ["<localleader>sd"] = {
--         --         action = function() return "<cmd> ObsidianDailies <CR>" end,
--         --         opts = { buffer = true, expr = true, desc = "[S]earch Obsidian [D]aily Notes", },
--         --     },
--         --     ["<localleader>st"] = {
--         --         action = function() return "<cmd> ObsidianTags <CR>" end,
--         --         opts = { buffer = true, expr = true, desc = "[S]earch Obsidian [T]ags", },
--         --     },
--         --     ["<localleader>sh"] = {
--         --         action = function() return "<cmd> ObsidianTOC <CR>" end,
--         --         opts = { buffer = true, expr = true, desc = "[S]earch [H]eaders", },
--         --     },
--         -- },
--     },
--     -- keys = {
--     --     {
--     --         "<leader>l",
--     --         -- leave visual mode to set marks and make ObsidianLink command work
--     --         ":ObsidianLink<cr>",
--     --         desc = "[O]bsidian [L]ink",
--     --         ft = "markdown",
--     --         mode = "v",
--     --     },
--     --     {
--     --         "<leader>n",
--     --         -- leave visual mode to set marks and make ObsidianLink command work
--     --         ":ObsidianLinkNew<cr>",
--     --         desc = "[O]bsidian [N]ew Link",
--     --         ft = "markdown",
--     --         mode = "v",
--     --     },
--     --     {
--     --         "<leader>e",
--     --         -- leave visual mode to set marks and make ObsidianLink command work
--     --         ":ObsidianExtractNote<cr>",
--     --         desc = "[O]bsidian [E]xtract to new note",
--     --         ft = "markdown",
--     --         mode = "v",
--     --     },
--     -- },
-- }
