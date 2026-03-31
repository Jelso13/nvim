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
    -- ft = "markdown",
    event = {
        "BufReadPre " .. vim.fn.expand("~") .. "/Vault/**/*.md",
        "BufNewFile " .. vim.fn.expand("~") .. "/Vault/**/*.md",
    },

    -- Add the keys table here to define your shortcuts
    keys = {
        -- 1. Workspace & Navigation (The "Where am I going?" cluster)
        -- override standard file search with obsidian search
        {
            "<leader>sf",
            "<cmd>Obsidian quick_switch<CR>",
            desc = "Search Obsidian vault",
        },
        -- quick_switch
        -- open the obsidian app
        {
            "<leader>oo",
            "<cmd>Obsidian open<CR>",
            desc = "Open in Obsidian App",
        },
        {
            "<localleader>o",
            "<cmd>Obsidian open<CR>",
            desc = "Open in Obsidian App",
        },

        -- 2. Creation & Templates (The "Making things" cluster)
        { "<leader>on", "<cmd>Obsidian new<CR>", desc = "Create new note" },
        {
            "<leader>ot",
            "<cmd>Obsidian template<CR>",
            desc = "Insert template",
        },
        {
            "<leader>oT",
            "<cmd>Obsidian new_from_template<CR>",
            desc = "New note from template",
        },

        -- 3. Daily Notes (The "Time" cluster)
        {
            "<leader>od",
            "<cmd>Obsidian today<CR>",
            desc = "Today's daily note",
        },
        {
            "<localleader>d",
            "<cmd>Obsidian today<CR>",
            desc = "Today's daily note",
        },
        {
            "<leader>oy",
            "<cmd>Obsidian yesterday<CR>",
            desc = "Yesterday's daily note",
        },
        {
            "<leader>om",
            "<cmd>Obsidian tomorrow<CR>",
            desc = "Tomorrow's daily note",
        }, -- 'm' for morrow
        {
            "<leader>oD",
            "<cmd>Obsidian dailies<CR>",
            desc = "List daily notes",
        },
        {
            "<localleader>D",
            "<cmd>Obsidian dailies<CR>",
            desc = "List daily notes",
        },

        -- 4. Note Structure & Linking (The "Connections" cluster)
        {
            "<leader>ob",
            "<cmd>Obsidian backlinks<CR>",
            desc = "Show note backlinks",
        },
        {
            "<leader>oL",
            "<cmd>Obsidian links<CR>",
            desc = "Show links in note",
        },
        { "<leader>og", "<cmd>Obsidian tags<CR>", desc = "Search tags" }, -- 'g' for taG
        { "<leader>oc", "<cmd>Obsidian toc<CR>", desc = "Table of contents" },

        -- 5. Note Editing (The "Action" cluster)
        {
            "<leader>or",
            "<cmd>Obsidian rename<CR>",
            desc = "Rename note (updates links)",
        },
        {
            "<leader>ox",
            "<cmd>Obsidian toggle_checkbox<CR>",
            desc = "Toggle checkbox",
        },
        {
            "<leader>op",
            "<cmd>Obsidian paste_img<CR>",
            desc = "Paste image from clipboard",
        },

        -- 6. Visual Mode Bindings (Text extraction and inline linking)
        {
            "<leader>ol",
            "<cmd>Obsidian link<CR>",
            mode = "v",
            desc = "Link visual selection to note",
        },
        {
            "<leader>on",
            "<cmd>Obsidian link_new<CR>",
            mode = "v",
            desc = "Link visual to new note",
        },
        {
            "<leader>oe",
            "<cmd>Obsidian extract_note<CR>",
            mode = "v",
            desc = "Extract text to new note",
        },
    },

    -- The dependencies you mentioned are automatically detected,
    -- so we don't need to explicitly declare blink.cmp here for it to work.
    dependencies = {
        "nvim-lua/plenary.nvim", -- Required utility library
        "saghen/blink.cmp", -- completions
    },
    opts = {
        workspaces = {
            { name = "Vault", path = "~/Vault" },
        },
        completion = { blink = false }, -- needed because we manually register with blink
        -- follow_link_func = function(link, opts)
        --        opts.confirm = false
        --        require"obsidian.builtin".follow_link(link, opts)
        -- end,
        attachments = {
            folder = "Attachments",
            img_folder = "Attachments",
            -- -- img_text_func = require("obsidian.builtin").img_text_func,
            -- img_name_func = function()
            --     return string.format("Pasted image %s", os.date("%Y%m%d%H%M%S"))
            -- end,
            confirm_img_paste = false,
        },

        legacy_commands = false,
        preferred_link_style = "markdown",
        link = {
            style = "markdown",
            format = "absolute",
        },
        ui = { enable = true },
        -- 1. Route all newly created notes to the Knowledge directory
        notes_subdir = "Knowledge",
        new_notes_location = "notes_subdir",
        templates = {
            folder = "Scratchpad/Templates",
        },
        checkbox = {
            -- Ensures smart_action only toggles existing checkboxes,
            -- never creates them from empty lines.
            create_new = false,
        },
        note_id_func = function(title)
            -- Ensures all generated files use lowercase-hyphenated slugs
            if title ~= nil then
                return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
            else
                return tostring(os.time())
            end
        end,
        daily_notes = {
            folder = "Scratchpad",
            date_format = "%Y-%m-%d",
            alias_format = "%Y-%m-%d",
            default_tags = { "daily" },
        },
        callbacks = {
            enter_note = function(note)
                local bufnr = vim.api.nvim_get_current_buf()

                -- Smart Check: If there are 4 lines or fewer, it's just the
                -- auto-generated frontmatter. We treat this as "empty."
                if vim.api.nvim_buf_line_count(bufnr) > 6 then
                    return
                end

                local path = tostring(note.path):lower() -- Force lowercase for matching

                if path:match("knowledge/") then
                    vim.cmd("Obsidian template knowledge.md")
                elseif path:match("scratchpad/") then
                    vim.cmd("Obsidian template scratchpad.md")
                elseif path:match("sources/") then
                    vim.cmd("Obsidian template source.md")
                end
            end,
        },
    },
}
