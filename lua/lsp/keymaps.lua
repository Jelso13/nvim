-- Brief aside: **What is LSP?**
--
-- LSP is an initialism you've probably heard, but might not understand what it is.
--
-- LSP stands for Language Server Protocol. It's a protocol that helps editors
-- and language tooling communicate in a standardized fashion.
--
-- In general, you have a "server" which is some tool built to understand a particular
-- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
-- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
-- processes that communicate with some "client" - in this case, Neovim!
--
-- LSP provides Neovim with features like:
--  - Go to definition
--  - Find references
--  - Autocompletion
--  - Symbol Search
--  - and more!
--
-- Thus, Language Servers are external tools that must be installed separately from
-- Neovim. This is where `mason` and related plugins come into play.
--
-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
-- and elegantly composed help section, `:help lsp-vs-treesitter`

--  This function gets run when an LSP attaches to a particular buffer.
--    That is to say, every time a new file is opened that is associated with
--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--    function will be executed to configure the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
    callback = function(event)
        -- NOTE: Remember that Lua is a real programming language, and as such it is possible
        -- to define small helper and utility functions so you don't have to repeat yourself.
        --
        -- In this case, we create a function that lets us more easily define mappings specific
        -- for LSP related items. It sets the mode, buffer and description for us each time.
        -- local map = function(keys, func, desc, mode)
        --     mode = mode or "n"
        --     vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        -- end

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-t>.
        vim.keymap.set("n","gd", require("telescope.builtin").lsp_definitions, { buffer = event.buf, desc = "[G]oto [D]efinition"})

        -- Find references for the word under your cursor.
        vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { buffer = event.buf, desc = "[G]oto [R]eferences"})

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        vim.keymap.set("n", "gI", require("telescope.builtin").lsp_implementations, { buffer = event.buf, desc = "[G]oto [I]mplementation"})

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        --  Use 'kind' instead of type to avoid conflict with gt for tabs
        vim.keymap.set("n", "gk", require("telescope.builtin").lsp_type_definitions, { buffer = event.buf, desc = "[G]oto [K]ind"})

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        -- vim.keymap.set(
        --     "n", 
        --     "<leader>pss",
        --     require("telescope.builtin").lsp_dynamic_workspace_symbols,
        --     {buffer = event.buf, desc="[P]roject [S]earch [S]ymbols"}
        -- )

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        vim.keymap.set("n", "<leader>pr", vim.lsp.buf.rename, {buffer=event.buf, desc="[P]roject [R]ename item"})

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        vim.keymap.set({ "n","x" }, "<leader>ca", vim.lsp.buf.code_action, {buffer=event.buf, desc="[C]ode [A]ction"})

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {buffer=event.buf, desc="[G]oto [D]eclaration"})

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup =
                vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
                group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
                callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
                end,
            })
        end
    end,
})
