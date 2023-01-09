-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- ORGANISE THE MATH BY PACKAGE
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
local get_visual = function(args, parent)
  if (#parent.snippet.env.SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
  else
    return sn(nil, i(1, ''))
  end
end


-- Include this `in_mathzone` function at the start of a snippets file...
local in_mathzone = function()
    -- The `in_mathzone` function requires the VimTeX plugin
    -- return vim.fn['vimtex#syntax#in_mathzone']() == 1
    return vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1
end
-- Then pass the table `{condition = in_mathzone}` to any snippet you want to
-- expand only in math contexts.

-- Math context detection 
local tex = {}
-- tex.in_mathzone = function() return vim.fn['vimtex#syntax#in_mathzone']() == 1 end
tex.in_text = function() return not tex.in_mathzone() end

return {
    -- SUPERSCRIPT
    s({ trig = "([%w%)%]%}])^", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta( "<>^{<>}", { f(function(_, snip) return snip.captures[1] end), d(1, get_visual), }),
        { condition = in_mathzone }
    ),
    -- SUBSCRIPT
    s({ trig = "([%w%)%]%}])_", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta(
            "<>_{<>}",
            {
                f(function(_, snip) return snip.captures[1] end),
                d(1, get_visual),
            }
        ),
        { condition = in_mathzone }
    ),
    -- REGULAR TEXT i.e. \text (in math environments)
    s({trig = "([^%a])tt", regTrig = true, wordTrig = false, snippetType="autosnippet"},
      fmta( "<>\\text{<>}", { f( function(_, snip) return snip.captures[1] end ), d(1, get_visual), }),
      { condition = tex.in_mathzone }
    ),
    -- EULER'S NUMBER SUPERSCRIPT SHORTCUT
    s({ trig = '([^%a])ee', regTrig = true, wordTrig = false, snippetType = "autosnippet" },
        fmta(
            "<>e^{<>}",
            {
                f(function(_, snip) return snip.captures[1] end),
                d(1, get_visual)
            }
        ),
        { condition = in_mathzone }
    ),
    -- PLUS SUPERSCRIPT SHORTCUT
    s({ trig = '([%a%)%]%}])%+%+', regTrig = true, wordTrig = false, snippetType = "autosnippet" },
        fmta(
            "<>^{<>}",
            {
                f(function(_, snip) return snip.captures[1] end),
                t("+")
            }
        ),
        { condition = in_mathzone }
    ),
    -- COMPLEMENT SUPERSCRIPT
    s({ trig = '([%a%)%]%}])CC', regTrig = true, wordTrig = false, snippetType = "autosnippet" },
        fmta(
            "<>^{<>}",
            {
                f(function(_, snip) return snip.captures[1] end),
                t("\\complement")
            }
        ),
        { condition = in_mathzone }
    ),
    -- CONJUGATE (STAR) SUPERSCRIPT SHORTCUT
    s({ trig = '([%a%)%]%}])%*%*', regTrig = true, wordTrig = false, snippetType = "autosnippet" },
        fmta(
            "<>^{<>}",
            {
                f(function(_, snip) return snip.captures[1] end),
                t("*")
            }
        ),
        { condition = in_mathzone }
    ),
    -- VECTOR, i.e. \vec
    s({ trig = "([^%a])vv", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta(
            "<>\\vec{<>}",
            {
                f(function(_, snip) return snip.captures[1] end),
                d(1, get_visual),
            }
        ),
        { condition = in_mathzone }
    ),
    -- UNIT VECTOR WITH HAT, i.e. \uvec{}
    s({ trig = "([^%a])uv", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta(
            "<>\\boldsymbol{\\hat{\\textbf{<>}}}",
            {
                f(function(_, snip) return snip.captures[1] end),
                d(1, get_visual),
            }
        ),
        { condition = in_mathzone }
    ),
    -- FRACTION
    s({ trig = "([^%a])ff", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta(
            "<>\\frac{<>}{<>}",
            {
                f(function(_, snip) return snip.captures[1] end),
                d(1, get_visual),
                i(2),
            }
        ),
        { condition = in_mathzone }
    ),
    -- ANGLE
    s({ trig = '([%a%)%]%}])ang', regTrig = true, wordTrig = false, snippetType = "autosnippet" },
        fmta(
            "<>^{<>}",
            {
                f(function(_, snip) return snip.captures[1] end),
                t("\\circ")
            }
        ),
        { condition = in_mathzone }
    ),
    -- SQUARE ROOT
    s({ trig = "([^%\\])sq", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta(
            "<>\\sqrt{<>}",
            {
                f(function(_, snip) return snip.captures[1] end),
                d(1, get_visual),
            }
        ),
        { condition = in_mathzone }
    ),
    -- BINOMIAL SYMBOL
    s({ trig = "([^%\\])bnn", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta(
            "<>\\binom{<>}{<>}",
            {
                f(function(_, snip) return snip.captures[1] end),
                i(1),
                i(2),
            }
        ),
        { condition = in_mathzone }
    ),
    -- LOGARITHM WITH BASE SUBSCRIPT
    s({ trig = "([^%a%\\])ll", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta(
            "<>\\log_{<>}",
            {
                f(function(_, snip) return snip.captures[1] end),
                i(1),
            }
        ),
        { condition = in_mathzone }
    ),
    -- DERIVATIVE with denominator only
    s({ trig = "([^%a])dV", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta(
            "<>\\frac{\\mathrm{d}}{\\mathrm{d} <>}",
            {
                f(function(_, snip) return snip.captures[1] end),
                d(1, get_visual),
            }
        ),
        { condition = in_mathzone }
    ),
    -- DERIVATIVE with numerator and denominator
    s({ trig = "([^%a])dvv", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta(
            "<>\\frac{\\mathrm{d} <>}{\\mathrm{d} <>}",
            {
                f(function(_, snip) return snip.captures[1] end),
                i(1),
                i(2)
            }
        ),
        { condition = in_mathzone }
    ),
    -- DERIVATIVE with numerator, denominator, and higher-order argument
    s({ trig = "([^%a])ddv", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta(
            "<>\\frac{\\mathrm{d}^{<>} <>}{\\mathrm{d} <>^{<>}}",
            {
                f(function(_, snip) return snip.captures[1] end),
                i(1),
                i(2),
                i(3),
                rep(1),
            }
        ),
        { condition = in_mathzone }
    ),
    -- PARTIAL DERIVATIVE with denominator only
    s({ trig = "([^%a])pV", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta(
            "<>\\frac{\\partial}{\\partial <>}",
            {
                f(function(_, snip) return snip.captures[1] end),
                d(1, get_visual),
            }
        ),
        { condition = in_mathzone }
    ),
    -- PARTIAL DERIVATIVE with numerator and denominator
    s({ trig = "([^%a])pvv", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta(
            "<>\\frac{\\partial <>}{\\partial <>}",
            {
                f(function(_, snip) return snip.captures[1] end),
                i(1),
                i(2)
            }
        ),
        { condition = in_mathzone }
    ),
    -- PARTIAL DERIVATIVE with numerator, denominator, and higher-order argument
    s({ trig = "([^%a])ppv", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta(
            "<>\\frac{\\partial^{<>} <>}{\\partial <>^{<>}}",
            {
                f(function(_, snip) return snip.captures[1] end),
                i(1),
                i(2),
                i(3),
                rep(1),
            }
        ),
        { condition = in_mathzone }
    ),
    -- SUM with lower limit
    s({ trig = "([^%a])sM", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta(
            "<>\\sum_{<>}",
            {
                f(function(_, snip) return snip.captures[1] end),
                i(1),
            }
        ),
        { condition = in_mathzone }
    ),
    -- SUM with upper and lower limit
    s({ trig = "([^%a])smm", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta(
            "<>\\sum_{<>}^{<>}",
            {
                f(function(_, snip) return snip.captures[1] end),
                i(1),
                i(2),
            }
        ),
        { condition = in_mathzone }
    ),
    -- INTEGRAL with upper and lower limit
    s({ trig = "([^%a])intt", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta(
            "<>\\int_{<>}^{<>}",
            {
                f(function(_, snip) return snip.captures[1] end),
                i(1),
                i(2),
            }
        ),
        { condition = in_mathzone }
    ),
    -- BOXED command
    s({ trig = "([^%a])bb", wordTrig = false, regTrig = true, snippetType = "autosnippet" },
        fmta(
            "<>\\boxed{<>}",
            {
                f(function(_, snip) return snip.captures[1] end),
                d(1, get_visual)
            }
        ),
        { condition = in_mathzone }
    ),
    --
    -- BEGIN STATIC SNIPPETS
    --

    -- DIFFERENTIAL, i.e. \diff
    -- s({ trig = "df", snippetType = "autosnippet", snippetType = "autosnippet" },
    --     {
    --         -- t("\\diff"),
    --         t("\\ensuremath{\\operatorname{d}!}"),
    --     },
    --     { condition = in_mathzone }
    -- ),
    -- BASIC INTEGRAL SYMBOL, i.e. \int
    s({ trig = "int", snippetType = "autosnippet" },
        {
            t("\\int"),
        },
        { condition = in_mathzone }
    ),
    -- CLOSED SINGLE INTEGRAL, i.e. \oint
    s({ trig = "oi1", snippetType = "autosnippet" },
        {
            t("\\oint"),
        },
        { condition = in_mathzone }
    ),
    -- GRADIENT OPERATOR, i.e. \grad
    s({ trig = "gdd", snippetType = "autosnippet" },
        {
            t("\\nabla "),
        },
        { condition = in_mathzone }
    ),
    -- CURL OPERATOR, i.e. \curl
    s({ trig = "cll", snippetType = "autosnippet" },
        {
            t("\\nabla \\times "),
        },
        { condition = in_mathzone }
    ),
    -- DIVERGENCE OPERATOR, i.e. \divergence
    s({ trig = "DI", snippetType = "autosnippet" },
        {
            t("\\nabla \\cdot "),
        },
        { condition = in_mathzone }
    ),
    -- LAPLACIAN OPERATOR, i.e. \laplacian
    s({ trig = "laa", snippetType = "autosnippet" },
        {
            t("\\nabla^{2} "),
        },
        { condition = in_mathzone }
    ),
    -- PARALLEL SYMBOL, i.e. \parallel
    s({ trig = "||", snippetType = "autosnippet" },
        {
            t("\\parallel"),
        }
    ),
    -- CDOTS, i.e. \cdots
    s({ trig = "cdd", snippetType = "autosnippet" },
        {
            t("\\cdots"),
        }
    ),
    -- LDOTS, i.e. \ldots
    s({ trig = "ldd", snippetType = "autosnippet" },
        {
            t("\\ldots"),
        }
    ),
    -- EQUIV, i.e. \equiv
    s({ trig = "eqq", snippetType = "autosnippet" },
        {
            t("\\equiv "),
        }
    ),
    -- SETMINUS, i.e. \setminus
    s({ trig = "stm", snippetType = "autosnippet" },
        {
            t("\\setminus "),
        }
    ),
    -- SUBSET, i.e. \subset
    s({ trig = "sbb", snippetType = "autosnippet" },
        {
            t("\\subset "),
        }
    ),
    -- APPROX, i.e. \approx
    s({ trig = "px", snippetType = "autosnippet" },
        {
            t("\\approx "),
        },
        { condition = in_mathzone }
    ),
    -- PROPTO, i.e. \propto
    s({ trig = "pt", snippetType = "autosnippet" },
        {
            t("\\propto "),
        },
        { condition = in_mathzone }
    ),
    -- COLON, i.e. \colon
    s({ trig = "::", snippetType = "autosnippet" },
        {
            t("\\colon "),
        }
    ),
    -- IMPLIES, i.e. \implies
    s({ trig = ">>", snippetType = "autosnippet" },
        {
            t("\\implies "),
        }
    ),
    -- DOT PRODUCT, i.e. \cdot
    s({ trig = ",.", snippetType = "autosnippet" },
        {
            t("\\cdot "),
        }
    ),
    -- CROSS PRODUCT, i.e. \times
    s({ trig = "xx", snippetType = "autosnippet" },
        {
            t("\\times "),
        }
    ),
}
