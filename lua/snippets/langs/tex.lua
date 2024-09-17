-- clear language snippets
-- require("luasnip.session.snippet_collection").clear_snippets("tex")

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
local isn = ls.indent_snippet_node

-- expand conditions
local line_begin = require("luasnip.extras.expand_conditions").line_begin

local helpers = require("snippets.helper_functions")

local tex_utils = {}
-- function for determining if in a maths zone
tex_utils.in_mathzone = function()
  local in_math = vim.fn['vimtex#syntax#in_mathzone']() == 1
  print("In math zone: ", in_math)
  return in_math
end

-- local tex_utils.in_mathzone = function()  -- math context detection
--   return vim.fn['vimtex#syntax#tex_utils.in_mathzone']() == 1
-- end
tex_utils.in_text = function()
  return not tex_utils.in_mathzone()
end
tex_utils.in_comment = function()  -- comment detection
  return vim.fn['vimtex#syntax#tex_utils.in_comment']() == 1
end
tex_utils.in_env = function(name)  -- generic environment detection
    local is_inside = vim.fn['vimtex#env#is_inside'](name)
    return (is_inside[1] > 0 and is_inside[2] > 0)
end
-- A few concrete environments---adapt as needed
tex_utils.in_equation = function()  -- equation environment detection
    return tex_utils.in_env('equation')
end
tex_utils.in_itemize = function()  -- itemize environment detection
    return tex_utils.in_env('itemize')
end
tex_utils.in_tikz = function()  -- TikZ picture environment detection
    return tex_utils.in_env('tikzpicture')
end

ls.add_snippets("tex", {
    -- Examples of Greek letter snippets, autotriggered for efficiency
    s({ trig = ";a", snippetType = "autosnippet" }, {
        t("\\alpha"),
    }, {condition = tex_utils.in_mathzone}),
    s({ trig = ";b", snippetType = "autosnippet" }, {
        t("\\beta"),
    }, {condition = tex_utils.in_mathzone}),
    s({ trig = ";g", snippetType = "autosnippet" }, {
        t("\\gamma"),
    }, {condition = tex_utils.in_mathzone}),

    s(
{ trig = "eq", dscr = "A LaTeX equation environment" },
        fmt( -- The snippet code actually looks like the equation environment it produces.
            [[
          \begin{equation}
              <>
          \end{equation}
        ]],
            -- The insert node is placed in the <> angle brackets
            { i(1) },
            -- This is where I specify that angle brackets are used as node positions.
            { delimiters = "<>" }
        ),
        {condition = tex_utils.in_text}
    ),


    -- Prevents expansion if 'foo' is typed after letters
    s({trig = "([^%a])mm", wordTrig = false, regTrig = true,snippetType="autosnippet"},
      fmta(
        "<>$<>$",
        {
          f( function(_, snip) return snip.captures[1] end ),
          d(1, helpers.get_visual),
        }
      ),
      {condition = tex_utils.in_text}
        -- {condition = line_begin}
    ),

    -- euler power regex prevents inclusion of ee in words
    s({trig = "([^%a])ee", regTrig = true, wordTrig = false, snippetType="autosnippet" },
      fmta(
        "<>e^{<>}",
        {
          f( function(_, snip) return snip.captures[1] end ),
          d(1, helpers.get_visual),
        }
      ),
      {condition = tex_utils.in_mathzone}
    ),
    -- \frac
    s({trig = "ff"},
      fmta(
        "\\frac{<>}{<>}",
        {
          i(1, "x"),
          i(2, "y"),
        }
      ),
      {condition = tex_utils.in_mathzone}  -- `condition` option passed in the snippet `opts` table 
    ),

    -- TikZ
    -- Expand 'dd' into \draw, but only in TikZ environments
    s({trig = "dd"},
      fmta(
        "\\draw [<>] ",
        {
          i(1, "params"),
        }
      ),
      { condition = tex_utils.in_tikz }
    ),
})


-- Group snippets into specific categories for readability
local latex_text = {
    s({ trig = "ti", dscr = "[T]ext [I]talics block" },
        fmta("\\textit{<>}", {
            d(1, helpers.get_visual),
        }),
        {condition = tex_utils.in_text}
    ),
    s({ trig = "tu", dscr = "[T]ext [U]nderline" },
        fmta("\\underline{<>}", {
            d(1, helpers.get_visual),
        }),
        {condition = tex_utils.in_text}
    ),
    s({ trig = "tb", dscr = "[T]ext [B]old font" },
        fmta("\\textbf{<>}", {
            d(1, helpers.get_visual),
        }),
        {condition = tex_utils.in_text}
    ),
    s({ trig = "ttw", dscr = "[T]ext [T]ype[W]riter block" },
        fmta("\\texttt{<>}", {
            d(1, helpers.get_visual),
        }),
        {condition = tex_utils.in_text}
    ),
}

local latex_sections = {
    -- Snippet for section
    s({ trig = "sec", descr = "LaTeX section" }, {
        t("\\section{"), i(1), t("}"),
    }),
}

-- Add all snippet groups under 'tex' filetype
ls.add_snippets("tex", latex_text)
ls.add_snippets("tex", latex_sections)
