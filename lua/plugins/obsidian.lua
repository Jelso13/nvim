-- make it so that it is only loaded when the file is within ~/Vault

--[[
-- /Sources template:
--        
--        ---
--        tags: [source]
--        ---
--        # Title of the Source
--        
--        **Author/Year:** **Local File:** [[Name of PDF in Attachments]]
--
--        ## One-Sentence Summary
--        >
--
--        ## Notes & Extractions
--
--
--]

-- return {
--     "epwalsh/obsidian.nvim",
--     version = "*",
--     lazy = true,
--     event = {
--         "BufReadPre " .. vim.fn.expand("~") .. "/Vault/**/*.md",
--         "BufNewFile " .. vim.fn.expand("~") .. "/Vault/**/*.md",
--     },
--     dependencies = {
--         "nvim-lua/plenary.nvim",
--         "saghen/blink.cmp",
--     },
--     opts = {
--         workspaces = { { name = "Vault", path = "~/Vault", }, },
--         completion = {
--             nvim_cmp = false,
--             blink = true,
--         },
--         -- Fixes legacy commands warning
--         legacy_commands = false,
--
--         -- Protocol: Enforce standard markdown links
--         preferred_link_style = "markdown",
--
--         -- Protocol: The Scratchpad folder
--         daily_notes = {
--             folder = "Scratchpad",
--             date_format = "%Y-%m-%d",
--             alias_format = "%Y-%m-%d",
--             default_tags = { "daily" },
--         },
--
--         -- Protocol: Image routing
--         attachments = {
--             img_folder = "Attachments",
--         },
--
--         -- Fixes frontmatter warning & enforces snippet protocol
--         frontmatter = {
--             enabled = false,
--         },
--
--         -- Protocol: Strict kebab-case filenames
--         note_id_func = function(title)
--             if title ~= nil then
--                 return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
--             else
--                 return tostring(os.time())
--             end
--         end,
--
--         -- Fixes checkbox ordering warning
--         checkbox = {
--             enabled = true,
--             create_new = true,
--             order = { " ", "x", "~", "!", ">" },
--         },
--
--         -- UI Rendering
--         ui = {
--             enable = true,
--             update_debounce = 200,
--             checkboxes = {
--                 [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
--                 ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
--                 ["!"] = { char = "", hl_group = "ObsidianImportant" },
--                 [">"] = { char = "", hl_group = "ObsidianRightArrow" },
--                 ["x"] = { char = "", hl_group = "ObsidianDone" },
--             },
--         },
--
--         -- OS Integration
--         follow_url_func = function(url)
--             vim.fn.jobstart({ "xdg-open", url })
--         end,
--         follow_img_func = function(url)
--             vim.fn.jobstart({ "xdg-open", url })
--         end,
--     },
--
--     -- Fixes the mappings warning by using native Neovim keymaps
--     config = function(_, opts)
--         require("obsidian").setup(opts)
--
--         -- Standard vim.keymap.set commands using the modern space-separated syntax
--         vim.keymap.set("n", "<leader>od", "<cmd>Obsidian today<cr>", { desc = "[O]bsidian [D]aily Note" })
--         vim.keymap.set("n", "<leader>on", "<cmd>Obsidian new<cr>", { desc = "[O]bsidian [N]ew Note" })
--         vim.keymap.set("v", "<leader>ol", "<cmd>Obsidian link_new<cr>", { desc = "[O]bsidian [L]ink visual selection" })
--         vim.keymap.set("n", "<leader>ob", "<cmd>Obsidian backlinks<cr>", { desc = "[O]bsidian [B]acklinks" })
--         vim.keymap.set("n", "<leader>oo", "<cmd>Obsidian open<cr>", { desc = "[O]bsidian [O]pen in GUI" })
--         vim.keymap.set("n", "<leader>os", "<cmd>Obsidian search<cr>", { desc = "[O]bsidian [S]earch" })
--     end,
-- }

return {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended for stable updates
    lazy = true,
    -- Trigger the plugin when entering a markdown file or specifically in your vault
    ft = "markdown",

    -- Add the keys table here to define your shortcuts
    keys = {
        -- 1. Workspace & Navigation (The "Where am I going?" cluster)
        -- override standard file search with obsidian search
        { "<leader>sf", "<cmd>Obsidian quick_switch<CR>", desc = "Search Obsidian vault" },
        -- quick_switch
        -- open the obsidian app
        { "<leader>oo", "<cmd>Obsidian open<CR>", desc = "Open in Obsidian App" },

        -- 2. Creation & Templates (The "Making things" cluster)
        { "<leader>on", "<cmd>Obsidian new<CR>", desc = "Create new note" },
        { "<leader>ot", "<cmd>Obsidian template<CR>", desc = "Insert template" },
        { "<leader>oT", "<cmd>Obsidian new_from_template<CR>", desc = "New note from template" },

        -- 3. Daily Notes (The "Time" cluster)
        { "<leader>od", "<cmd>Obsidian today<CR>", desc = "Today's daily note" },
        { "<leader>oy", "<cmd>Obsidian yesterday<CR>", desc = "Yesterday's daily note" },
        { "<leader>om", "<cmd>Obsidian tomorrow<CR>", desc = "Tomorrow's daily note" }, -- 'm' for morrow
        { "<leader>oD", "<cmd>Obsidian dailies<CR>", desc = "List daily notes" },

        -- 4. Note Structure & Linking (The "Connections" cluster)
        { "<leader>ob", "<cmd>Obsidian backlinks<CR>", desc = "Show note backlinks" },
        { "<leader>oL", "<cmd>Obsidian links<CR>", desc = "Show links in note" },
        { "<leader>og", "<cmd>Obsidian tags<CR>", desc = "Search tags" }, -- 'g' for taG 
        { "<leader>oc", "<cmd>Obsidian toc<CR>", desc = "Table of contents" },

        -- 5. Note Editing (The "Action" cluster)
        { "<leader>or", "<cmd>Obsidian rename<CR>", desc = "Rename note (updates links)" },
        { "<leader>ox", "<cmd>Obsidian toggle_checkbox<CR>", desc = "Toggle checkbox" },
        { "<leader>op", "<cmd>Obsidian paste_img<CR>", desc = "Paste image from clipboard" },

        -- 6. Visual Mode Bindings (Text extraction and inline linking)
        { "<leader>ol", "<cmd>Obsidian link<CR>", mode = "v", desc = "Link visual selection to note" },
        { "<leader>on", "<cmd>Obsidian link_new<CR>", mode = "v", desc = "Link visual to new note" },
        { "<leader>oe", "<cmd>Obsidian extract_note<CR>", mode = "v", desc = "Extract text to new note" },
    },


    -- The dependencies you mentioned are automatically detected,
    -- so we don't need to explicitly declare blink.cmp here for it to work.
    dependencies = {
        "nvim-lua/plenary.nvim", -- Required utility library
        "saghen/blink.cmp", -- completions
    },

    opts = {
        legacy_commands = false,
        -- Legacy support for your current stable version
        preferred_link_style = "markdown",
        -- Define your vault(s) here
        workspaces = {
            {
                name = "Vault",
                path = "~/Vault", -- Replace with your actual absolute path
            },
        },
        completion = {
            blink = false,
        },
        footer = {
            enabled = false, -- turn it off
            separator = false, -- turn it off
            -- separator = "", -- insert a blank line
            format = "{{backlinks}} backlinks  {{properties}} properties  {{words}} words  {{chars}} chars", -- works like the template system
            -- format = "({{backlinks}} backlinks)", -- limit to backlinks
            hl_group = "@property", -- Use another hl group
        },
        -- Implement your markdown link preference
        link = {
            style = "markdown",
            format = "absolute", -- Output will be [Description](Directory/note-id.md)
        },

        -- We can disable standard UI features if you prefer a cleaner look
        ui = {
            enable = true,
        },

        -- 1. Route all newly created notes to the Knowledge directory
        notes_subdir = "Knowledge",
        new_notes_location = "notes_subdir",

        -- 2. Transform the title into a readable, URL-safe filename (a "slug")
        note_id_func = function(title)
            local filename = ""
            if title ~= nil then
                -- Replace spaces with hyphens, remove special characters, and make lowercase
                filename = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
            else
                -- Fallback: If you trigger note creation without typing a title, use a timestamp
                filename = tostring(os.time())
            end
            return filename
        end,

        daily_notes = {
            folder = "Scratchpad",
            date_format = "%Y-%m-%d",
            alias_format = "%Y-%m-%d",
            default_tags = { "daily" },
        },

    },
    callbacks = {
            enter_note = function(note)
                local bufnr = vim.api.nvim_get_current_buf()

                -- 1. Identify where the YAML frontmatter ends
                local body_start = 0
                if note.has_frontmatter and note.frontmatter_end_line then
                    body_start = note.frontmatter_end_line
                end

                -- 2. Prevent overwriting
                local line_count = vim.api.nvim_buf_line_count(bufnr)
                if line_count > body_start + 1 then return end
                if line_count == body_start + 1 and vim.api.nvim_buf_get_lines(bufnr, body_start, body_start + 1, false)[1] ~= "" then return end

                local path = tostring(note.path)
                local title = note:display_name()
                local template_str = ""

                -- 3. Define templates using string.format and multiline [[ ]] brackets
                if path:match("/Knowledge/") then
                    template_str = string.format([[

# %s

## Summary

## Core Concepts
]], title)

                elseif path:match("/Source/") then
                    template_str = string.format([[

# %s

**Author:** **Link:** ## Highlights
]], title)

                elseif path:match("/Scratchpad/") then
                    template_str = string.format([[

# Daily Note: %s

## Tasks
- [ ] 

## Journal
]], title)
                end

                -- 4. Split the multiline string and inject it
                if template_str ~= "" then
                    local lines = vim.split(template_str, "\n", { plain = true })
                    vim.api.nvim_buf_set_lines(bufnr, body_start, -1, false, lines)
                    vim.cmd("silent! write")
                end
            end,
        },
}
