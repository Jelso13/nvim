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
-- line begin is preferable as it accounts for whitespace as line begin
local line_begin = require("luasnip.extras.expand_conditions").line_begin

local helpers = require("snippets.helper_functions")

local tex_utils = {}
-- function for determining if in a maths zone
tex_utils.in_mathzone = function()
  local in_math = vim.fn['vimtex#syntax#in_mathzone']() == 1
  print("In math zone: ", in_math)
  return in_math
end
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

local latex_envs = {
    s({
        trig = "beg", -- only at start of line
        snippetType="autosnippet",
        dscr="create new env",
    },
        fmta([[
            \begin{<>}
                <>
            \end{<>}
            <>
        ]],
        {
            i(1),
            d(2, helpers.get_visual),
            rep(1),
            i(0)
        }
        ),{condition = tex_utils.in_text * line_begin} -- in text and at start of line
    ),

    s({
        trig = "eq", -- only at start of line
        snippetType="autosnippet",
        dscr="[EQ]uation",
    },
        fmta([[
            \begin{equation}
                <>
            \end{equation}
            <>
        ]],
        {
            i(1),
            i(0)
        }
        ),{condition = tex_utils.in_text * line_begin} -- in text and at start of line
    ),

    s({
        trig = "mb", -- only at start of line
        snippetType="autosnippet",
        dscr="[M]ath [B]lock unnumbered",
    },
        fmta([[ 
            \[
                <>
            .\] 
        ]],
        {i(0)}
        ),{condition = tex_utils.in_text * line_begin} -- in text and at start of line
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
}

local latex_math = {
    -- euler power regex prevents inclusion of ee in words
    s({trig = "([^%a])ee", dscr="[EE]xponential", regTrig = true,
        wordTrig = false, snippetType="autosnippet" },
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
    s({trig = "([^%a])ff", dscr="[FF]raction", regTrig=true, wordTrig=false,
        snippetType="autosnippet" },
      fmta(
        "<>\\frac{<>}{<>}",
        {
          f( function(_, snip) return snip.captures[1] end ),
          i(1, "x"),
          i(2, "y"),
        }
      ),
      {condition = tex_utils.in_mathzone}  -- `condition` option passed in the snippet `opts` table 
    ),
    s({ trig = '([A-Za-z])(%d)', dscr="subscript single digit",
              regTrig = true, wordTrig = false, snippetType="autosnippet"},
        {
          f(function(_, snip) return snip.captures[1] end),
          t('_'),
          f(function(_, snip) return snip.captures[2] end)
        },
      {condition = tex_utils.in_mathzone}
    ),
    s({ trig = '([A-Za-z])_(%d%d)', dscr="subscript multiple digit",
              regTrig = true, wordTrig = false, snippetType="autosnippet"},
        fmta("<>_{<><>}",
        {
          f(function(_, snip) return snip.captures[1] end),
          f(function(_, snip) return snip.captures[2] end),
          i(0)
        }
      ),
      {condition = tex_utils.in_mathzone}
    ),
}

local latex_greek_letters = {
    -- Examples of Greek letter snippets, autotriggered for efficiency
   s({trig=";a", dscr="alpha", snippetType="autosnippet" }, {
		t("\\alpha")
	}, {condition = tex_utils.in_mathzone}),
    s({trig=";b", dscr="beta", snippetType="autosnippet" }, {
        t("\\beta")
    }, {condition = tex_utils.in_mathzone}),
   s({trig=";g", dscr="gamma", snippetType="autosnippet" }, {
		t("\\gamma")
	}, {condition = tex_utils.in_mathzone}),
   s({trig=";G", dscr="Gamma", snippetType="autosnippet" }, {
		t("\\Gamma")
    }, {condition = tex_utils.in_mathzone}),
    s({trig=";d", dscr="delta", snippetType="autosnippet" }, {
        t("\\delta")
    }, {condition = tex_utils.in_mathzone}),
    s({trig=";D", dscr="Delta", snippetType="autosnippet" }, {
        t("\\Delta")
    }, {condition = tex_utils.in_mathzone}),
   s({trig=";ep", dscr="epsilon", snippetType="autosnippet" }, {
		t("\\epsilon")
	}, {condition = tex_utils.in_mathzone}),
    s({trig=";z", dscr="zeta", snippetType="autosnippet" }, {
        t("\\zeta")
    }, {condition = tex_utils.in_mathzone}),
    s({trig=";et", dscr="eta", snippetType="autosnippet" }, {
        t("\\eta")
    }, {condition = tex_utils.in_mathzone}),
   s({trig=";h", dscr="theta", snippetType="autosnippet" }, { -- h is the same as vim digraph
		t("\\theta")
	}, {condition = tex_utils.in_mathzone}),
   s({trig=";H", dscr="Theta", snippetType="autosnippet" }, { -- h is the same as vim digraph
		t("\\Theta")
	}, {condition = tex_utils.in_mathzone}),
    s({trig=";i", dscr="iota", snippetType="autosnippet" }, {
        t("\\iota")
    }, {condition = tex_utils.in_mathzone}),
   s({trig=";k", dscr="kappa", snippetType="autosnippet" }, {
		t("\\kappa")
	}, {condition = tex_utils.in_mathzone}),
    s({trig=";l", dscr="lambda", snippetType="autosnippet" }, {
        t("\\lambda")
    }, {condition = tex_utils.in_mathzone}),
    s({trig=";L", dscr="Lambda", snippetType="autosnippet" }, {
        t("\\Lambda")
    }, {condition = tex_utils.in_mathzone}),
   s({trig=";m", dscr="mu", snippetType="autosnippet" }, {
		t("\\mu")
	}, {condition = tex_utils.in_mathzone}),
    s({trig=";n", dscr="nu", snippetType="autosnippet" }, {
        t("\\nu")
    }, {condition = tex_utils.in_mathzone}),
    s({trig=";x", dscr="xi", snippetType="autosnippet" }, {
        t("\\xi")
    }, {condition = tex_utils.in_mathzone}),
    s({trig=";X", dscr="Xi", snippetType="autosnippet" }, {
        t("\\Xi")
    }, {condition = tex_utils.in_mathzone}),
    -- do not need a snippet for pi as same characters -> ;pi and \pi
    s({trig=";r", dscr="rho", snippetType="autosnippet" }, {
        t("\\rho")
    }, {condition = tex_utils.in_mathzone}),
    s({trig=";s", dscr="sigma", snippetType="autosnippet" }, {
        t("\\sigma")
    }, {condition = tex_utils.in_mathzone}),
    s({trig=";S", dscr="Sigma", snippetType="autosnippet" }, {
        t("\\Sigma")
    }, {condition = tex_utils.in_mathzone}),
    s({trig=";t", dscr="tau", snippetType="autosnippet" }, {
        t("\\tau")
    }, {condition = tex_utils.in_mathzone}),
    s({trig=";u", dscr="upsilon", snippetType="autosnippet" }, {
        t("\\upsilon")
    }, {condition = tex_utils.in_mathzone}),
    s({trig=";U", dscr="Upsilon", snippetType="autosnippet" }, {
        t("\\Upsilon")
    }, {condition = tex_utils.in_mathzone}),
    s({trig=";f", dscr="phi", snippetType="autosnippet" }, {
        t("\\phi")
    }, {condition = tex_utils.in_mathzone}),
    s({trig=";F", dscr="Phi", snippetType="autosnippet" }, {
        t("\\Phi")
    }, {condition = tex_utils.in_mathzone}),
    s({trig=";c", dscr="chi", snippetType="autosnippet" }, {
        t("\\chi")
    }, {condition = tex_utils.in_mathzone}),
    s({trig=";p", dscr="psi", snippetType="autosnippet" }, {
        t("\\psi")
    }, {condition = tex_utils.in_mathzone}),
    s({trig=";P", dscr="Psi", snippetType="autosnippet" }, {
        t("\\Psi")
    }, {condition = tex_utils.in_mathzone}),
   s({trig=";o", dscr="omega", snippetType="autosnippet" }, {
		t("\\omega")
	}, {condition = tex_utils.in_mathzone}),
   s({trig=";O", dscr="Omega", snippetType="autosnippet" }, {
		t("\\Omega")
	}, {condition = tex_utils.in_mathzone}),
}

local latex_tikz = {
    s({trig = "dd"},
      fmta(
        "\\draw [<>] ",
        {
          i(1, "params"),
        }
      ),
      { condition = tex_utils.in_tikz }
    ),
}

-- Add all snippet groups under 'tex' filetype
ls.add_snippets("tex", latex_text)
ls.add_snippets("tex", latex_math)
ls.add_snippets("tex", latex_sections)
ls.add_snippets("tex", latex_envs)
ls.add_snippets("tex", latex_greek_letters)

ls.add_snippets("tex", latex_tikz)
