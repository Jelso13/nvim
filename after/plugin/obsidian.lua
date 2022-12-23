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
    note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
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
        return tostring(os.time()) .. "-" .. suffix
    end,
    notes_subdir = ".",

}


obsidian.setup(setup)
