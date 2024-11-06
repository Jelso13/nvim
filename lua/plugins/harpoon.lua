return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
    settings = {
        -- any time the ui menu is closed then we will save the state back to the backing list, not to the fs
        save_on_toggle = false,              -- Keep this as false if you don't want to save on toggle
        -- any time the ui menu is closed then the state of the list will be sync'd back to the fs
        sync_on_ui_close = true,             -- Enable this to sync state back to the filesystem
        key = function()
            -- Return the Git worktree directory or a unique identifier for each worktree
            -- local git_worktree_path = vim.fn.system("git rev-parse --show-toplevel"):gsub("%s+", "")
            -- return git_worktree_path
            -- return vim.fn.system("git rev-parse --show-toplevel"):gsub("%s+", "")
            return vim.loop.cwd()
        end,
    },
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()
		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end, { desc = "Add a file to the harpoon list" })
		vim.keymap.set("n", "<C-e>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Toggle harpoon menu" })
		vim.keymap.set("n", "<C-h>", function()
			harpoon:list():select(1)
		end, { desc = "Go to the first harpoon entry" })
		vim.keymap.set("n", "<C-t>", function()
			harpoon:list():select(2)
		end, { desc = "Go to the second harpoon entry" })
		vim.keymap.set("n", "<C-n>", function()
			harpoon:list():select(3)
		end, { desc = "Go to the third harpoon entry" })
		vim.keymap.set("n", "<C-s>", function()
			harpoon:list():select(4)
		end, { desc = "Go to the fourth harpoon entry" })

		-- -- basic telescope configuration
		-- local conf = require("telescope.config").values
		-- local function toggle_telescope(harpoon_files)
		-- 	local file_paths = {}
		-- 	for _, item in ipairs(harpoon_files.items) do
		-- 		table.insert(file_paths, item.value)
		-- 	end

		-- 	require("telescope.pickers")
		-- 		.new({}, {
		-- 			prompt_title = "Harpoon",
		-- 			finder = require("telescope.finders").new_table({
		-- 				results = file_paths,
		-- 			}),
		-- 			previewer = conf.file_previewer({}),
		-- 			sorter = conf.generic_sorter({}),
		-- 		})
		-- 		:find()
		-- end

		-- vim.keymap.set("n", "<C-e>", function()
		-- 	toggle_telescope(harpoon:list())
		-- end, { desc = "Open harpoon window" })
	end,
}
