local status_ok, ls = pcall(require, "luasnip")
if not status_ok then
    return
end

-- abbreviations used
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

-- This is the `get_visual` function I've been talking about.
-- ----------------------------------------------------------------------------
-- Summary: If `SELECT_RAW` is populated with a visual selection, the function
-- returns an insert node whose initial text is set to the visual selection.
-- If `SELECT_RAW` is empty, the function simply returns an empty insert node.
local get_visual = function(args, parent)
  if (#parent.snippet.env.SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
  else  -- If SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end
-- ----------------------------------------------------------------------------

return {
    -- Code for environment snippet in the above GIF
    s({ trig = "env", snippetType = "autosnippet" },
        fmta(
            [[
      \begin{<>}
          <>
      \end{<>}
    ]],
            {
                i(1),
                i(2),
                rep(1), -- this node repeats insert node i(1)
            }
        )
    ),
    -- Using a zero-index insert node to exit snippet in equation body
    s({ trig = "eq", dscr = "" },
        fmta(
            [[
      \begin{equation}
          <>
      \end{equation}
    ]],
            { i(0) }
        )
    ),
    -- Example: italic font implementing visual selection
    s({ trig = "tii", dscr = "Expands 'tii' into LaTeX's textit{} command." },
        fmta("\\textit{<>}",
            {
                d(1, get_visual),
            }
        )
    ),
}
