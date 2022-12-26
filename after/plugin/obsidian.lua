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
    -- function thot determines how new notes are named
    note_id_func = function()
        -- determine if there is a '/' in the file name for if the file
        -- should be in a subdirectory
        -- name = vim.fn.input("File Name: ")
        return vim.fn.input("File Name: ")
    end,
--     note_id_func = function(title)
--         -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
--         local suffix = ""
--         if title ~= nil then
--             -- If title is given, transform it into valid file name.
--             suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
--         else
--             -- If title is nil, just add 4 random uppercase letters to the suffix.
--             for _ = 1, 4 do
--                 suffix = suffix .. string.char(math.random(65, 90))
--             end
--         end
--         return tostring(os.time()) .. "-" .. suffix
--     end,
    notes_subdir = ".",

}

-- render?
vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianOpen<cr>")
vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<cr>")
vim.keymap.set("v", "<leader>ol", "<cmd>ObsidianLink<cr>")
vim.keymap.set( "n", "gf", function()
    if require('obsidian').util.cursor_on_markdown_link() then
      return "<cmd>ObsidianFollowLink<CR>"
    else
      return "gf"
    end
  end,
  { noremap = false, expr = true}
)
vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>")

-- vim.keymap.set('n', '<leader>ps', function()
--     builtin.grep_string({ search = vim.fn.input("Grep > ") })
-- end,
--     { desc = "project search" }
-- )


obsidian.setup(setup)
