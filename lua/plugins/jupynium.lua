return {
    "kiyoon/jupynium.nvim",
    
    -- 1. ISOLATION: Only load Jupynium when opening a file that matches *.ju.*
    event = { "BufReadPre *.ju.*", "BufNewFile *.ju.*" },

    build = "pip3 install --user .",
    dependencies = {
        "rcarriga/nvim-notify", 
        "stevearc/dressing.nvim", 
    },

    opts = {
        default_notebook_URL = "localhost:8888/nbclassic",
        jupynium_file_pattern = { "*.ju.*" },
        
        -- Jupynium's internal default keymaps are already smart enough to be buffer-local
        use_default_keybindings = false,
        textobjects = {
            use_default_keybindings = true,
        },
        syntax_highlight = { enable = true },
        shortsighted = true,
        autoscroll = {
            enable = true,
            mode = "always",
            focus = "input",
        },
        auto_download_ipynb = true,
        auto_start_server = {
          enable = true,
          file_pattern = { "*.ju.*" },
        },
        auto_start_sync = {
          enable = false,
          file_pattern = { "*.ju.*", "*.md" },
        },
    },

    -- 2. BUFFER-LOCAL KEYMAP: We use the config function to inject our custom logic
    config = function(_, opts)
        -- Call the setup function with our opts table
        require("jupynium").setup(opts)

        -- Create an Auto-Command that triggers when entering a *.ju.* buffer
        vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
            pattern = { "*.ju.*" },
            callback = function(event)
                local buf = event.buf
                -- Create a localized shortcut for setting keys to keep code clean
                local set = function(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
                end
                vim.keymap.set("n", "<localleader>o", function()
                    -- 1. Get the target filename AND its full absolute path
                    local filename = vim.fn.expand("%:t:r:r") .. ".ipynb"
                    local filepath = vim.fn.expand("%:p:h") .. "/" .. filename
                
                    -- 2. THE NUCLEAR OPTION: If the file exists, delete it.
                    if vim.fn.filereadable(filepath) == 1 then
                        vim.fn.delete(filepath)
                        vim.notify("Deleted existing " .. filename .. " (Outputs lost).", vim.log.levels.WARN)
                    end
                
                    -- 3. Now Jupynium's safety wall is bypassed. Start sync.
                    vim.cmd("JupyniumStartSync " .. filename)
                    vim.notify("Starting fresh Jupynium sync for " .. filename, vim.log.levels.INFO)
                end, { 
                    buffer = event.buf, 
                    desc = "Jupynium: Force sync (DELETES EXISTING IPYNB)" 
                })
                -- Execute / Clear (Mapped in Normal and Visual modes so you can highlight multiple cells)
                set({ "n", "x" }, "<enter>", "<cmd>JupyniumExecuteSelectedCells<CR>", "Jupynium: Execute selected cells")

                set({ "n", "x" }, "<localleader>x", "<cmd>JupyniumExecuteSelectedCells<CR>", "Jupynium: Execute selected cells")
                set({ "n", "x" }, "<localleader>c", "<cmd>JupyniumClearSelectedCellsOutputs<CR>", "Jupynium: Clear selected cells")


                
                -- Bonus Kernel Management (Highly recommended)
                set("n", "<localleader>kr", "<cmd>JupyniumKernelRestart<CR>", "Jupynium: Restart Kernel")
                set("n", "<localleader>ki", "<cmd>JupyniumKernelInterrupt<CR>", "Jupynium: Interrupt Kernel")
            end,
        })
        -- Visually distinguish Jupyter cells by highlighting the separator lines
        vim.cmd [[
          hi! link JupyniumCodeCellSeparator CursorLine
          hi! link JupyniumMarkdownCellSeparator CursorLine
          hi! link JupyniumMarkdownCellContent CursorLine
          hi! link JupyniumMagicCommand Keyword
        ]]
    end
}
