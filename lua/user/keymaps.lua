local M = {}

local function bind(op, outer_opts)
    outer_opts = outer_opts or {noremap = true}
    return function(lhs, rhs, opts)
        opts = vim.tbl_extend("force",
            outer_opts,
            opts or {}
        )
        vim.keymap.set(op, lhs, rhs, opts)
    end
end


M.nmap = bind("n", {noremap = false})
M.nnoremap = bind("n")
M.vnoremap = bind("v")
M.xnoremap = bind("x")
M.inoremap = bind("i")
M.tnoremap = bind("t")

-- only applies to current buffer
M.local_nnoremap = bind("n", {buffer = 0})
M.local_vnoremap = bind("v", {buffer = 0})
M.local_xnoremap = bind("x", {buffer = 0})
M.local_inoremap = bind("i", {buffer = 0})
M.local_tnoremap = bind("t", {buffer = 0})

return M

