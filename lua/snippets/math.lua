-- Notice this returns a function that EXPECTS a condition to be passed to it
return function(math_condition)
    local status_ok, ls = pcall(require, "luasnip")
    if not status_ok then
        return
    end
    -- abbreviations used
    local s = ls.snippet
    local sn = ls.snippet_node
    local isn = ls.indent_snippet_node
    local t = ls.text_node
    local i = ls.insert_node
    local f = ls.function_node
    local c = ls.choice_node
    local d = ls.dynamic_node
    local r = ls.restore_node
    local events = require("luasnip.util.events")
    local ai = require("luasnip.nodes.absolute_indexer")
    local k = require("luasnip.nodes.key_indexer").new_key
    local extras = require("luasnip.extras")
    local l = extras.lambda
    local rep = extras.rep
    local p = extras.partial
    local m = extras.match
    local n = extras.nonempty
    local dl = extras.dynamic_lambda
    local fmt = require("luasnip.extras.fmt").fmt
    local fmta = require("luasnip.extras.fmt").fmta
    local conds = require("luasnip.extras.expand_conditions")
    local postfix = require("luasnip.extras.postfix").postfix
    local types = require("luasnip.util.types")
    local parse = require("luasnip.util.parser").parse_snippet
    local ms = ls.multi_snippet


    local helpers = require("snippets.helper_functions")

    return {
        s(
            {
                trig = "...",
                dscr = "dots",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\ldots") },
            { condition = math_condition } -- Uses whatever was passed in
        ),
        s(
            { trig = "->", dscr = "to", wordTrig = false, snippetType = "autosnippet" },
            { t("\\to") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "...",
                dscr = "dots",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\ldots") },
            { condition = math_condition }
        ),
        s(
            { trig = "->", dscr = "to", wordTrig = false, snippetType = "autosnippet" },
            { t("\\to") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "<->",
                dscr = "left right arrow",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\leftrightarrow") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "!>",
                dscr = "maps to",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\mapsto") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "\\\\\\",
                dscr = "set minus",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\setminus") },
            { condition = math_condition }
        ),
        s(
            { trig = "tt", dscr = "text", wordTrig = false, snippetType = "autosnippet" },
            fmta("\\text{<>}", { d(1, helpers.get_visual) }),
            { condition = math_condition }
        ),
        s(
            {
                trig = "iff",
                dscr = "if and only if",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\iff") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "=>",
                dscr = "implies",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\implies") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "=<",
                dscr = "implied by",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\impliedby") },
            { condition = math_condition }
        ),
        s(
            {
                trig = ">=",
                dscr = "greater than or equal to",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\ge") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "<=",
                dscr = "less than or equal to",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\le") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "!=",
                dscr = "not equal to",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\neq") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "==",
                dscr = "align equals",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            fmta("&= <> \\\\", i(1)),
            { condition = math_condition }
        ),
        s(
            {
                trig = "AA",
                dscr = "for all",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\forall") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "EE",
                dscr = "there exists",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\exists") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "OO",
                dscr = "empty set",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\emptyset") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "NN",
                dscr = "natural numbers",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\mathbb{N}") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "RR",
                dscr = "real numbers",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\mathbb{R}") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "QQ",
                dscr = "rationals",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\mathbb{Q}") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "ZZ",
                dscr = "integers",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\mathbb{Z}") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "CC",
                dscr = "complex numbers",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\mathbb{C}") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "HH",
                dscr = "hyperbolic space",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\mathbb{H}") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "mcal",
                dscr = "mathcal",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\mathcal{"), i(1), t("}") },
            { condition = math_condition }
        ),
        s(
            { trig = "lll", dscr = "ell", wordTrig = false, snippetType = "autosnippet" },
            { t("\\ell") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "nabla",
                dscr = "nabla",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\nabla") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "ooo",
                dscr = "infinity",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\infty") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "set",
                dscr = "start a set",
                wordTrig = true,
                snippetType = "autosnippet",
            },
            { t("\\{"), i(1), t("\\}") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "norm",
                dscr = "norm",
                wordTrig = true,
                snippetType = "autosnippet",
            },
            { t("\\|"), i(1), t("\\|") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "cc",
                dscr = "subset",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\subset") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "notin",
                dscr = "not in",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\not\\in") },
            { condition = math_condition }
        ),
        s(
            { trig = "inn", dscr = "in", wordTrig = false, snippetType = "autosnippet" },
            { t("\\in") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "ceil",
                dscr = "ceiling",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\left\\lceil "), i(1), t("\\right\\rceil") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "floor",
                dscr = "floor",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\left\\lfloor "), i(1), t("\\right\\rfloor") },
            { condition = math_condition }
        ),
        s(
            { trig = "hat", dscr = "hat", wordTrig = false, snippetType = "autosnippet" },
            fmta("\\widehat{<>}", { d(1, helpers.get_visual) }),
            { condition = math_condition }
        ),
        s(
            {
                trig = "([%a])hat",
                dscr = "hat postfix",
                regTrig = true,
                wordTrig = false,
                snippetType = "autosnippet",
                priority = 1001,
            },
            fmta(
                "\\hat{<>}",
                { f(function(_, snip)
                    return snip.captures[1]
                end) }
            ),
            { condition = math_condition }
        ),
        s(
            {
                trig = "bar",
                dscr = "overline bar",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            fmta("\\overline{<>}", { d(1, helpers.get_visual) }),
            { condition = math_condition }
        ),
        s(
            {
                trig = "([%a])bar",
                dscr = "bar postfix",
                regTrig = true,
                wordTrig = false,
                snippetType = "autosnippet",
                priority = 1001,
            },
            fmta(
                "\\overline{<>}",
                { f(function(_, snip)
                    return snip.captures[1]
                end) }
            ),
            { condition = math_condition }
        ),
        s(
            {
                trig = "vec",
                dscr = "vector",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            fmta("\\vec{<>}", { d(1, helpers.get_visual) }),
            { condition = math_condition }
        ),
        s(
            {
                trig = "bmat",
                dscr = "bracket matrix",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\begin{bmatrix}"), i(1), t("\\end{bmatrix}") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "pmat",
                dscr = "parenthesis matrix",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\begin{pmatrix}"), i(1), t("\\end{pmatrix}") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "case",
                dscr = "cases",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\begin{cases}"), i(1), t("\\end{cases}") },
            { condition = math_condition }
        ),
        s(
            { trig = "**", dscr = "cdot", wordTrig = false, snippetType = "autosnippet" },
            { t("\\cdot") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "xx",
                dscr = "times",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { t("\\times") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "dint",
                dscr = "definite integral",
                wordTrig = true,
                snippetType = "autosnippet",
            },
            fmta(
                "\\int_{<>}^{<>} <>",
                { i(1, "-\\infty"), i(2, "\\infty"), d(3, helpers.get_visual) }
            ),
            { condition = math_condition }
        ),
        s(
            {
                trig = "/",
                dscr = "fraction",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            fmta("\\frac{<>}{<>}", { d(1, helpers.get_visual), i(2, "y") }),
            {
                condition = function()
                    return math_condition and conds.has_selected_text()
                end,
            }
        ),
        s(
            {
                trig = "//",
                dscr = "fraction",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            fmta("\\frac{<>}{<>}", { i(1, "x"), i(2, "y") }),
            { condition = math_condition }
        ),
        s(
            {
                trig = "ubrace",
                dscr = "label under section",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            fmta(
                "\\underbrace{<>}_{\\text{<>}}",
                { d(1, helpers.get_visual), i(2) }
            ),
            {
                condition = function()
                    return math_condition and conds.has_selected_text()
                end,
            }
        ),
        s(
            {
                trig = "ubrace",
                dscr = "label under section",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            fmta("\\underbrace{<>}_{\\text{<>}}", { i(1), i(2) }),
            { condition = math_condition }
        ),
        s(
            {
                trig = "obrace",
                dscr = "label over section",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            fmta(
                "\\overbrace{<>}^{\\text{<>}}",
                { d(1, helpers.get_visual), i(2) }
            ),
            {
                condition = function()
                    return math_condition and conds.has_selected_text()
                end,
            }
        ),
        s(
            {
                trig = "obrace",
                dscr = "label over section",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            fmta("\\overbrace{<>}^{\\text{<>}}", { i(1), i(2) }),
            { condition = math_condition }
        ),
        s(
            {
                trig = "^^",
                dscr = "superscript",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            fmta("^{<>}", { i(1, "x") }),
            { condition = math_condition }
        ),
        s(
            {
                trig = "__",
                dscr = "subscript",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            fmta("_{<>}", { i(1, "x") }),
            { condition = math_condition }
        ),
        -- shorthand subscripts for letter-number combinations
        s(
            {
                trig = "([%a])(%d)",
                dscr = "letter-number subscript",
                wordTrig = false,
                regTrig = true,
                snippetType = "autosnippet",
            },
            f(function(_, snip)
                return string.format(
                    "%s_%s",
                    snip.captures[1],
                    snip.captures[2]
                )
            end, {}),
            { condition = math_condition }
        ),
        s(
            {
                trig = "([%a])(%d%d)",
                dscr = "letter-number subscript",
                wordTrig = false,
                regTrig = true,
                snippetType = "autosnippet",
            },
            f(function(_, snip)
                return string.format(
                    "%s_{%s}",
                    snip.captures[1],
                    snip.captures[2]
                )
            end, {}),
            { condition = math_condition }
        ),
        s(
            { trig = "hat", dscr = "hat", wordTrig = false, snippetType = "autosnippet" },
            fmta("\\hat{<>}", { d(1, helpers.get_visual) }), -- Visual selection or empty space
            { condition = math_condition }
        ),
        s(
            { trig = "bar", dscr = "bar", wordTrig = false, snippetType = "autosnippet" },
            fmta("\\bar{<>}", { d(1, helpers.get_visual) }), -- Visual selection or empty space
            { condition = math_condition }
        ),
        s(
            { trig = "cup", dscr = "cup", wordTrig = false, snippetType = "autosnippet" },
            { t("\\cup") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "Cup",
                dscr = "big cup",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            fmta("\\bigcup_{<>}", { i(1) }),
            { condition = math_condition }
        ),
        s(
            { trig = "cap", dscr = "cap", wordTrig = false, snippetType = "autosnippet" },
            { t("\\cap") },
            { condition = math_condition }
        ),
        s(
            {
                trig = "Cap",
                dscr = "big cap",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            fmta("\\bigcap_{<>}", { i(1) }),
            { condition = math_condition }
        ),
        s(
            {
                trig = "sum",
                dscr = "summation",
                wordTrig = true,
                snippetType = "autosnippet",
            },
            fmta("\\sum_{<>}^{<>} <>", { i(1, "n=1"), i(2, "\\infty"), i(3) }),
            { condition = math_condition }
        ),
        s(
            {
                trig = "prod",
                dscr = "product",
                wordTrig = true,
                snippetType = "autosnippet",
            },
            fmta("\\prod_{<>}^{<>} <>", { i(1, "n=1"), i(2, "\\infty"), i(3) }),
            { condition = math_condition }
        ),
        s(
            {
                trig = "part",
                dscr = "d/dx",
                wordTrig = true,
                snippetType = "autosnippet",
            },
            fmta("\\frac{\\partial <>}{\\partial <>}", { i(1, "f"), i(2, "x") }),
            { condition = math_condition }
        ),
        s(
            {
                trig = "sq",
                dscr = "square root",
                wordTrig = true,
                snippetType = "autosnippet",
            },
            fmta("\\sqrt{<>}", { i(1, "x") }),
            { condition = math_condition }
        ),
        s(
            {
                trig = "root",
                dscr = "square root",
                wordTrig = true,
                snippetType = "autosnippet",
            },
            fmta("\\sqrt[<>]{<>}", { i(1, ""), i(2, "x") }),
            { condition = math_condition }
        ),
        s(
            {
                trig = "lim",
                dscr = "limit",
                wordTrig = true,
                snippetType = "autosnippet",
            },
            fmta("\\lim_{<>\\to<>} <>", { i(1, "n"), i(2, "\\infty"), i(3) }),
            { condition = math_condition }
        ),
        s(
            {
                trig = "limsup",
                dscr = "limit supremum",
                wordTrig = true,
                snippetType = "autosnippet",
            },
            fmta("\\limsup_{<>\\to<>} <>", { i(1, "n"), i(2, "\\infty"), i(3) }),
            { condition = math_condition }
        ),
        s(
            {
                trig = "liminf",
                dscr = "limit infimum",
                wordTrig = true,
                snippetType = "autosnippet",
            },
            fmta("\\liminf_{<>\\to<>} <>", { i(1, "n"), i(2, "\\infty"), i(3) }),
            { condition = math_condition }
        ),
        s(
            {
                trig = "()",
                dscr = "left right parens",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            fmta([[ \left( <> \right) <> ]], { d(1, helpers.get_visual), i(0) }),
            {
                condition = math_condition,
                show_condition = math_condition,
            }
        ),
        s(
            {
                trig = "{}",
                dscr = "left right braces",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            fmta(
                [[ \left\{ <> \right\} <> ]],
                { d(1, helpers.get_visual), i(0) }
            ),
            {
                condition = math_condition,
                show_condition = math_condition,
            }
        ),
        s(
            {
                trig = "[]",
                dscr = "left right brackets",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            fmta([[ \left[ <> \right] <> ]], { d(1, helpers.get_visual), i(0) }),
            {
                condition = math_condition,
                show_condition = math_condition,
            }
        ),
        s(
            {
                trig = "<>",
                dscr = "left right angle",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            fmta(
                [[ \left\langle <> \right\rangle <> ]],
                { d(1, helpers.get_visual), i(0) }
            ),
            {
                condition = math_condition,
                show_condition = math_condition,
            }
        ),
        -- s({ trig="lr", dscr="left right misc", wordTrig=false, snippetType="autosnippet"},
        --     fmta( [[ \left<> <> \right<> <> ]], {i(1), d(2, helpers.get_visual), i(3), i(0), }),
        --     {condition=math_condition, show_condition=math_condition}
        -- ),
        s(
            {
                trig = "lr",
                dscr = "left-right misc",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            fmt([[\left{} {} \right{} {}]], {
                i(1),
                d(2, helpers.get_visual, {}),
                d(3, function(args, _)
                    local left = args[1][1]
                    local pairs = {
                        ["("] = ")",
                        ["["] = "]",
                        ["{"] = "}",
                        ["|"] = "|",
                        ["<"] = ">",
                        ["\\langle"] = "\\rangle",
                    }
                    return sn(nil, i(1, pairs[left] or left))
                end, { 1 }),
                i(4),
            }),
            {
                condition = math_condition,
                show_condition = math_condition,
            }
        ),
        -- sub super scripts
        s(
            {
                trig = "(%a)(%d)",
                snippetType = "autosnippet",
                regTrig = true,
                dscr = "hi",
            },
            fmt([[<>_<>]], {
                f(function(_, snip)
                    return snip.captures[1]
                end),
                f(function(_, snip)
                    return snip.captures[2]
                end),
            }, { delimiters = "<>" }),
            { condition = math_condition }
        ),
        s(
            {
                trig = "(%a)_(%d%d)",
                regTrig = true,
                snippetType = "autosnippet",
                dscr = "auto subscript for 2+ digits",
            },
            fmt([[<>_{<>}]], {
                f(function(_, snip)
                    return snip.captures[1]
                end),
                f(function(_, snip)
                    return snip.captures[2]
                end),
            }, { delimiters = "<>" }),
            { condition = math_condition }
        ),
        -- implicit multiplication
        -- s(
        --     {
        --         trig = "(%w+)%(",
        --         regTrig = true,
        --         snippetType = "autosnippet",
        --         name = "implicit multiplication next to parenthesis",
        --         dscr = "implicit multiplication next to parenthesis. a( becomes a\times(",
        --     },
        --     fmt([[<>\times(<>]], {
        --         f(function(_, snip)
        --             return snip.captures[1]
        --         end),
        --         i(1),
        --     }, { delimiters = "<>" }),
        --     { condition = math_condition }
        -- ),

        -- Examples of Greek letter snippets, autotriggered for efficiency
        s(
            {
                trig = ";a",
                dscr = "alpha",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\alpha"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";b",
                dscr = "beta",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\beta"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";g",
                dscr = "gamma",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\gamma"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";G",
                dscr = "Gamma",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\Gamma"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";d",
                dscr = "delta",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\delta"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";D",
                dscr = "Delta",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\Delta"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";ep",
                dscr = "epsilon",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\epsilon"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";z",
                dscr = "zeta",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\zeta"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";et",
                dscr = "eta",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\eta"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";h",
                dscr = "theta",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { -- h is the same as vim digraph
                t("\\theta"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";H",
                dscr = "Theta",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            { -- h is the same as vim digraph
                t("\\Theta"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";i",
                dscr = "iota",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\iota"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";k",
                dscr = "kappa",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\kappa"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";l",
                dscr = "lambda",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\lambda"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";L",
                dscr = "Lambda",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\Lambda"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";m",
                dscr = "mu",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\mu"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";n",
                dscr = "nu",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\nu"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";x",
                dscr = "xi",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\xi"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";X",
                dscr = "Xi",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\Xi"),
            },
            { condition = math_condition }
        ),
        -- do not need a snippet for pi as same characters -> ;pi and \pi
        s(
            {
                trig = ";r",
                dscr = "rho",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\rho"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";s",
                dscr = "sigma",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\sigma"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";S",
                dscr = "Sigma",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\Sigma"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";t",
                dscr = "tau",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\tau"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";u",
                dscr = "upsilon",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\upsilon"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";U",
                dscr = "Upsilon",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\Upsilon"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";f",
                dscr = "phi",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\phi"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";F",
                dscr = "Phi",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\Phi"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";c",
                dscr = "chi",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\chi"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";p",
                dscr = "psi",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\psi"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";P",
                dscr = "Psi",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\Psi"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";o",
                dscr = "omega",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\omega"),
            },
            { condition = math_condition }
        ),
        s(
            {
                trig = ";O",
                dscr = "Omega",
                wordTrig = false,
                snippetType = "autosnippet",
            },
            {
                t("\\Omega"),
            },
            { condition = math_condition }
        ),
        -- implicit multiplication
        -- euler power regex prevents inclusion of ee in words
        -- s(
        --     {
        --         trig = "([^%a])ee",
        --         dscr = "[EE]xponential",
        --         regTrig = true,
        --         wordTrig = false,
        --         snippetType = "autosnippet",
        --     },
        --     fmta("<>e^{<>}", {
        --         f(function(_, snip)
        --             return snip.captures[1]
        --         end),
        --         d(1, helpers.get_visual),
        --     }),
        --     { condition = math_condition }
        -- ),
        -- s({
        --     trig = "^",
        --     dscr = "exponent",
        --     docstring = "^{|}",
        --     wordTrig = false,
        --     snippetType = "autosnippet",
        -- }, { t("^{"), i(1), t("}") }, {
        --     condition = math_condition,
        -- }),
        -- s(
        --     {
        --         trig = "lrv",
        --         name = "left right",
        --         dscr = "left right",
        --         snippetType = "autosnippet",
        --     },
        --     fmta([[\left(<>\right)<>]], {
        --         d(1, helpers.get_visual), -- capture the visual selection
        --         i(2),
        --     }),
        --     {
        --         condition = math_condition,
        --         show_condition = math_condition,
        --     }
        -- ),
    }
end
