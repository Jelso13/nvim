-- #######################################
-- ###### MAYBE REMOVE THIS ##############
-- #######################################


local status_ok, obsidian = pcall(require, "obsidian")
if not status_ok then
    return
end

local setup = {
    dir = "~/Vault/",
    completion = {
        nvim_cmp = true,
    },
    note_frontmatter_func = function(note)
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }
        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and util.table_length(note.metadata) > 0 then
            for k, v in pairs(note.metadata) do
                out[k] = v
            end
        end
        return out
    end,
    -- function that determines how new notes are named
    -- note_id_func = function(title)
    --     -- determine if there is a '/' in the file name for if the file
    --     -- should be in a subdirectory
    --     -- name = vim.fn.input("File Name: ")
    --     return vim.fn.input("File Name: ")
    -- end,
    note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        local suffix = ""
        if title ~= nil then
            -- If title is given, transform it into valid file name.
            suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
            -- If title is nil, just add 4 random uppercase letters to the suffix.
            suffix = vim.fn.input("File Name: ")
        end
        return suffix
    end,
    notes_subdir = ".",

}

-- render?
vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianOpen<cr>", {desc="Open note"})
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<cr>", {desc="Create new note"})
vim.keymap.set("v", "<leader>ol", "<cmd>ObsidianLinkNew<cr>", {desc="link new note"})
vim.keymap.set("v", "<leader>oc", "<cmd>ObsidianCheck<cr>", {desc="link note"})
-- vim.keymap.set( "n", "gf", function()
--     if require('obsidian').util.cursor_on_markdown_link() then
--       return "<cmd>ObsidianFollowLink<CR>"
--     else
--       return "gf"
--     end
--   end,
--   { noremap = false, expr = true}
-- )
vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>", {desc="get backlinks"})

obsidian.setup(setup)
