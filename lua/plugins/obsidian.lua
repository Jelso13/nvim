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
    version = "*", 
    lazy = true,
    event = {
        "BufReadPre " .. vim.fn.expand("~") .. "/Vault/**/*.md",
        "BufNewFile " .. vim.fn.expand("~") .. "/Vault/**/*.md",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "saghen/blink.cmp", 
    },
    
    -- We removed the `keys` table and moved the mapping logic into the config function
    config = function(_, opts)
        -- 1. Initialize Obsidian with your opts
        require("obsidian").setup(opts)

        -- 2. Create an Autocmd to set buffer-local keymaps ONLY in the Vault
        vim.api.nvim_create_autocmd({"BufEnter"}, {
            pattern = vim.fn.expand("~") .. "/Vault/**/*.md",
            callback = function(ev)
                local bufnr = ev.buf

                -- Helper function to keep mappings clean
                local function map(mode, key, cmd, desc)
                    vim.keymap.set(mode, key, cmd, { noremap = true, silent = true, buffer = bufnr, desc = desc })
                end

                -- 1. Workspace & Navigation 
                map("n", "<leader>sf", "<cmd>Obsidian quick_switch<CR>", "Search Obsidian vault")
                map("n", "<leader>oo", "<cmd>Obsidian open<CR>", "Open in Obsidian App")
                map("n", "<localleader>o", "<cmd>Obsidian open<CR>", "Open in Obsidian App")

                -- 2. Creation & Templates 
                map("n", "<leader>on", "<cmd>Obsidian new<CR>", "Create new note")
                map("n", "<leader>ot", "<cmd>Obsidian template<CR>", "Insert template")
                map("n", "<leader>oT", "<cmd>Obsidian new_from_template<CR>", "New note from template")

                -- 3. Daily Notes 
                map("n", "<leader>od", "<cmd>Obsidian today<CR>", "Today's daily note")
                map("n", "<localleader>d", "<cmd>Obsidian today<CR>", "Today's daily note")
                map("n", "<leader>oy", "<cmd>Obsidian yesterday<CR>", "Yesterday's daily note")
                map("n", "<leader>om", "<cmd>Obsidian tomorrow<CR>", "Tomorrow's daily note")
                map("n", "<leader>oD", "<cmd>Obsidian dailies<CR>", "List daily notes")
                map("n", "<localleader>D", "<cmd>Obsidian dailies<CR>", "List daily notes")

                -- 4. Note Structure & Linking 
                map("n", "<leader>ob", "<cmd>Obsidian backlinks<CR>", "Show note backlinks")
                map("n", "<leader>oL", "<cmd>Obsidian links<CR>", "Show links in note")
                map("n", "<leader>og", "<cmd>Obsidian tags<CR>", "Search tags")
                map("n", "<leader>oc", "<cmd>Obsidian toc<CR>", "Table of contents")

                -- 5. Note Editing
                map("n", "<leader>or", "<cmd>Obsidian rename<CR>", "Rename note")
                map("n", "<leader>ox", "<cmd>Obsidian toggle_checkbox<CR>", "Toggle checkbox")
                map("n", "<leader>op", "<cmd>Obsidian paste_img<CR>", "Paste image")

                -- 6. Visual Mode Bindings 
                map("v", "<leader>ol", "<cmd>Obsidian link<CR>", "Link visual selection")
                map("v", "<leader>on", "<cmd>Obsidian link_new<CR>", "Link visual to new note")
                map("v", "<leader>oe", "<cmd>Obsidian extract_note<CR>", "Extract text to new note")
            end
        })
    end,

    opts = {
        workspaces = {
            { name = "Vault", path = "~/Vault" },
        },
        completion = { blink = false }, 
        attachments = {
            folder = "Attachments",
            img_folder = "Attachments",
            confirm_img_paste = false,
        },
        legacy_commands = false,
        preferred_link_style = "markdown",
        link = {
            style = "markdown",
            format = "absolute",
        },
        ui = { enable = true },
        notes_subdir = "Knowledge",
        new_notes_location = "notes_subdir",
        templates = {
            folder = "Scratchpad/Templates",
        },
        checkbox = {
            create_new = false,
        },
        note_id_func = function(title)
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
                if vim.api.nvim_buf_line_count(bufnr) > 6 then
                    return
                end

                local path = tostring(note.path):lower() 

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
