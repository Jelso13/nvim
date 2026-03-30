-- clear language snippets
require("luasnip.session.snippet_collection").clear_snippets("markdown")

local status_ok, ls = pcall(require, "luasnip")
if not status_ok then
    return
end

-- abbreviations used
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

-- 1. Require your math generator 
-- (Assuming your math file is at ~/.config/nvim/lua/snippets/math.lua)
local math_generator = require("snippets.math")

-- 2. Define Tree-sitter math zone detection (Expanded)
local function treesitter_mathzone()
    local has_ts, ts = pcall(require, "vim.treesitter")
    if has_ts and ts.get_node then
        local node = ts.get_node({ ignore_injections = false })
        while node do
            -- Catch-all list of node types for math zones in Markdown and LaTeX
            if vim.tbl_contains({
                "inline_formula",
                "displayed_equation",
                "math_environment",
                "math_display",
                "math_block",
                "latex_block",
                "equation",
            }, node:type()) then
                return true
            end
            node = node:parent()
        end
    end
    return false
end

-- 3. Define text zone condition (opposite of mathzone)
local function treesitter_in_text()
    return not treesitter_mathzone()
end

-- 4. Define Markdown-specific snippets (using $ and $$)
local markdown_specific = {
    s(
        { trig="mk", snippetType="autosnippet", dscr="Inline Math" },
        fmta("$<>$", { i(1) }),
        { condition = treesitter_in_text }
    ),
    s(
        { trig="dm", snippetType="autosnippet", dscr="Display Math" },
        fmta([[
$$
    <>
$$
<>
        ]], { i(1), i(0) }),
        { condition = treesitter_in_text }
    )
}

-- 5. Add them to LuaSnip using your standard method!
ls.add_snippets("markdown", markdown_specific)
ls.add_snippets("markdown", math_generator(treesitter_mathzone))
