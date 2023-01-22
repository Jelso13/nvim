local status_ok, ls = pcall(require, "luasnip")
if not status_ok then
    return
end

-- abbreviations used
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

-- ----------------------------------------------------------------------------
-- Include this `in_mathzone` function at the start of a snippets file...
local in_mathzone = function()
  -- The `in_mathzone` function requires the VimTeX plugin
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end
-- Then pass the table `{condition = in_mathzone}` to any snippet you want to
-- expand only in math contexts.

return {
    -- Another take on the fraction snippet without using a regex trigger
    -- s({trig = "ff"},
    --   fmta(
    --     "\\frac{<>}{<>}",
    --     {
    --       i(1),
    --       i(2),
    --     }
    --   ),
    --   {condition = true}  -- `condition` option passed in the snippet `opts` table 
    -- ),
    -- -- Code for environment snippet in the above GIF
    -- s({ trig = "env", snippetType = "autosnippet" },
    --     fmta(
    --         [[
    --             \begin{<>}
    --                 <>
    --             \end{<>}
    --         ]],
    --         {
    --             i(1),
    --             i(2),
    --             rep(1), -- this node repeats insert node i(1)
    --         }
    --     )
    -- ),
}
