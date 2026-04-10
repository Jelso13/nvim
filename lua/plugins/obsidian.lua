-- 1. Custom Note ID Function
local function custom_note_id_func(title)
    if title ~= nil then
        title = title:gsub("%.md$", "")
        return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-/]", ""):lower()
    else
        return tostring(os.time())
    end
end

-- 2. Custom Note Path Function
local function custom_note_path_func(spec)
    local path
    local id_str = tostring(spec.id)
    if id_str:match("/") then
        local vault_root = require("obsidian").get_client().dir
        path = vault_root / id_str
    else
        path = spec.dir / id_str
    end
    return path:with_suffix(".md", true)
end

return {
    "obsidian-nvim/obsidian.nvim",
    version = "*", 
    -- THE FIX: Load on startup to synchronize with blink.cmp
    lazy = false, 
    dependencies = {
        "nvim-lua/plenary.nvim",
        "saghen/blink.cmp", 
    },
    
    config = function(_, opts)
        require("obsidian").setup(opts)

        vim.api.nvim_create_autocmd({"BufEnter"}, {
            pattern = vim.fn.expand("~") .. "/Vault/**/*.md",
            callback = function(ev)
                local bufnr = ev.buf
                local function map(mode, key, cmd, desc)
                    vim.keymap.set(mode, key, cmd, { noremap = true, silent = true, buffer = bufnr, desc = desc })
                end

                -- Bindings 
                map("n", "<leader>sf", "<cmd>Obsidian quick_switch<CR>", "Search Obsidian vault")
                map("n", "<leader>oo", "<cmd>Obsidian open<CR>", "Open in Obsidian App")
                map("n", "<localleader>o", "<cmd>Obsidian open<CR>", "Open in Obsidian App")
                map("n", "<leader>on", "<cmd>Obsidian new<CR>", "Create new note")
                map("n", "<leader>ot", "<cmd>Obsidian template<CR>", "Insert template")
                map("n", "<leader>oT", "<cmd>Obsidian new_from_template<CR>", "New note from template")
                map("n", "<leader>od", "<cmd>Obsidian today<CR>", "Today's daily note")
                map("n", "<localleader>d", "<cmd>Obsidian today<CR>", "Today's daily note")
                map("n", "<leader>oy", "<cmd>Obsidian yesterday<CR>", "Yesterday's daily note")
                map("n", "<leader>om", "<cmd>Obsidian tomorrow<CR>", "Tomorrow's daily note")
                map("n", "<leader>oD", "<cmd>Obsidian dailies<CR>", "List daily notes")
                map("n", "<localleader>D", "<cmd>Obsidian dailies<CR>", "List daily notes")
                map("n", "<leader>ob", "<cmd>Obsidian backlinks<CR>", "Show note backlinks")
                map("n", "<leader>oL", "<cmd>Obsidian links<CR>", "Show links in note")
                map("n", "<leader>og", "<cmd>Obsidian tags<CR>", "Search tags")
                map("n", "<leader>oc", "<cmd>Obsidian toc<CR>", "Table of contents")
                map("n", "<leader>or", "<cmd>Obsidian rename<CR>", "Rename note")
                map("n", "<leader>ox", "<cmd>Obsidian toggle_checkbox<CR>", "Toggle checkbox")
                map("n", "<leader>op", "<cmd>Obsidian paste_img<CR>", "Paste image")
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
        
        disable_frontmatter = true, 
        completion = { nvim_cmp = false, blink = true }, 
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
        daily_notes = {
            folder = "Scratchpad",
            date_format = "%Y-%m-%d",
            alias_format = "%Y-%m-%d",
            default_tags = { "daily" },
        },
        
        note_id_func = custom_note_id_func,
        note_path_func = custom_note_path_func,

        callbacks = {
            enter_note = function(note)
                local bufnr = vim.api.nvim_get_current_buf()
                if vim.api.nvim_buf_line_count(bufnr) > 1 then
                    return
                end

                local path = tostring(note.path):lower() 

                vim.schedule(function()
                    if path:match("knowledge/") then
                        vim.cmd("Obsidian template knowledge.md")
                    elseif path:match("scratchpad/") then
                        vim.cmd("Obsidian template scratchpad.md")
                    elseif path:match("sources/") then
                        vim.cmd("Obsidian template source.md")
                    end
                end)
            end,
        },
    },
}
