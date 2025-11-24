-- clear language snippets
-- require("luasnip.session.snippet_collection").clear_snippets("tex")

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

-- expand conditions
-- line begin is preferable as it accounts for whitespace as line begin
local line_begin = require("luasnip.extras.expand_conditions").line_begin

local helpers = require("snippets.helper_functions")

local tex_utils = {}
-- function for determining if in a maths zone
tex_utils.in_mathzone = function()
    local in_math = vim.fn["vimtex#syntax#in_mathzone"]() == 1
    return in_math
end
tex_utils.in_text = function()
    return not tex_utils.in_mathzone()
end
tex_utils.in_comment = function() -- comment detection
    return vim.fn["vimtex#syntax#tex_utils.in_comment"]() == 1
end
tex_utils.in_env = function(name) -- generic environment detection
    local is_inside = vim.fn["vimtex#env#is_inside"](name)
    return (is_inside[1] > 0 and is_inside[2] > 0)
end
-- A few concrete environments---adapt as needed
tex_utils.in_equation = function() -- equation environment detection
    return tex_utils.in_env("equation")
end
tex_utils.in_itemize = function() -- itemize environment detection
    return tex_utils.in_env("itemize")
end
tex_utils.in_tikz = function() -- TikZ picture environment detection
    return tex_utils.in_env("tikzpicture")
end


local latex_templates = {
    s(
        { trig = "template", dscr = "LaTeX template" },
        fmta(
            [[
            \documentclass[a4paper]{article}
            \usepackage[utf8]{inputenc}
            \usepackage{amsmath, amssymb, amsfonts}
            % figure support
            \usepackage{import}
            \usepackage{pdfpages}
            \usepackage{transparent}
            \usepackage{xcolor}
            
            \newcommand{\incfig}[2][1]{%
                \def\svgwidth{#1\columnwidth}
                \import{./figures/}{#2.pdf_tex}
            }

            \begin{document}
                <>
            \end{document}
        ]],
            { i(0) }
        )
    ),
}

-- Group snippets into specific categories for readability
local latex_text = {
    s(
        {
            trig = "ti",
            dscr = "[T]ext [I]talics block",
            docstring = "\\textit{|}",
        },
        fmta("\\textit{<>}", {
            d(1, helpers.get_visual),
        }),
        { condition = tex_utils.in_text }
    ),
    s(
        {
            trig = "tu",
            dscr = "[T]ext [U]nderline",
            docstring = "\\underline{|}",
        },
        fmta("\\underline{<>}", {
            d(1, helpers.get_visual),
        }),
        { condition = tex_utils.in_text }
    ),
    s(
        { trig = "tb", dscr = "[T]ext [B]old font", docstring = "\\textbf{<>}" },
        fmta("\\textbf{<>}", {
            d(1, helpers.get_visual),
        }),
        { condition = tex_utils.in_text }
    ),
    s(
        {
            trig = "ttw",
            dscr = "[T]ext [T]ype[W]riter block",
            docstring = "\\texttt{<>}",
        },
        fmta("\\texttt{<>}", {
            d(1, helpers.get_visual),
        }),
        { condition = tex_utils.in_text }
    ),
    s(
        { trig="mk", snippetType="autosnippet", dscr="Inline Math" },
        fmta("\\(<>\\)",{i(1)})
    ),
    s(
        { trig="dm", snippetType="autosnippet", dscr="Display Math" },
        fmta([[
        \[
            <>
        \]
        <>
        ]],{i(1), i(0)})
    )
}

local latex_sections = {
    -- Snippet for section
    s({ trig = "sec", descr = "LaTeX section", docstring = "\\section{|}" }, {
        fmta("\\section{<>}", { d(1, helpers.get_visual) }),
    }),
}

-- determines the number of separators '&' to include from num columns
local function create_row_nodes(args)
    local cols = args[1][1]
    local nodes = {}
    local ins_idx = 1
    for _ in cols:gmatch("[clrpmb]") do
        if ins_idx > 1 then
            table.insert(nodes, t(" & "))
        end
        table.insert(nodes, i(ins_idx))
        ins_idx = ins_idx + 1
    end
    table.insert(nodes, t(" \\\\"))

    -- if #nodes == 0 then
    --     return sn(nil, t(""))
    -- end
    table.insert(nodes, c(ins_idx, {
        t(""),
        sn(nil, {
            t({"", "\t\t"}),
            d(1, create_row_nodes, {k("cols")})
        })
    }))

    return sn(nil, nodes)
end


local latex_envs = {
    s({trig="table", dscr="Table Environment"},
        fmta(
            [[
                \begin{table}[<>]
                    \centering
                    \caption{<>}
                    \label{tab:<>}
                    \begin{tabular}{<>}
                        <>
                    \end{tabular}
                \end{table}
                <>
            ]],
            {
                i(1, "htpb"),
                i(2, "caption"),
                i(3, "label"),
                i(4, "c", {key = "cols"}), -- column definition
                d(5, create_row_nodes, {k("cols")}), -- generate separators from node 4)
                i(0)
            }
        ),
        { condition = line_begin }
    ),
    s({trig="fig", dscr="Figure Environment"},
        fmta(
            [[
                \begin{figure}[<>]
                    \centering
                    \includegraphics[width=0.8\textwidth]{<>}
                    \caption{<>}
                    \label{fig:<>}
                \end{figure}
                <>
            ]],
            {
                i(1, "htpb"),
                i(2),
                i(3),
                i(4),
                i(0)
            }
        ),
        { condition = line_begin }
    ),
    s({trig="plot", dscr="TikZ plot"},
        fmta(
            [[
                \begin{figure}[<>]
                    \centering
                    \begin{tikzpicture}
                        \begin{axis}[
                            xmin= <>, xmax= <>,
                            ymin= <>, ymax= <>,
                            axis lines= middle,
                            xlabel={<>},
                            ylabel={<>},
                            xlabel style={right},
                            ylabel style={above},
                        ]
                            \addplot[domain=<>:<>, samples=<>]{<>};
                        \end{axis}
                    \end{tikzpicture}
                    \caption{<>}
                    \label{<>}
                \end{figure}
                <>
            ]],
            {
                i(1),
                i(2, "-10"),
                i(3, "10"),
                i(4, "-10"),
                i(5, "10"),
                i(6, "\\(x\\)"),
                i(7, "\\(y\\)"),

                rep(2),
                rep(3),

                i(8, "100"),
                i(9),
                i(10),
                d(11, function (args)
                        return sn(nil, i(1, args[1][1]))
                    end, {10}),
                i(0)
            }
        ),
        { condition = line_begin }
    ),
    s({trig="tikz", dscr="TikZ plot"},
        fmta(
            [[
                \begin{tikzpicture}[<>]
                    <>
                \end{tikzpicture}
                <>
            ]],
            {
                i(1),
                i(2),
                i(0),
            }
        ),
        { condition = line_begin }
    ),

    -- s(
    --     {
    --         trig = "fig", -- only at start of line
    --         snippetType = "autosnippet",
    --         dscr = "figure environment",
    --     },
    --     fmta(
    --         [[
    --         \begin{figure}[]
    --             \centering
    --             <>
    --             \caption
    --         \end{figure}
    --         <>
    --     ]],
    --         {
    --             i(1),
    --             d(2, helpers.get_visual),
    --             rep(1),
    --             i(0),
    --         }
    --     ),
    --     { condition = tex_utils.in_text * line_begin } -- in text and at start of line
    -- ),
    s(
        {
            trig = "beg", -- only at start of line
            snippetType = "autosnippet",
            dscr = "create new env",
        },
        fmta(
            [[
            \begin{<>}
                <>
            \end{<>}
            <>
        ]],
            {
                i(1),
                d(2, helpers.get_visual),
                rep(1),
                i(0),
            }
        ),
        { condition = tex_utils.in_text * line_begin } -- in text and at start of line
    ),
    s(
        {
            trig = "ali", -- only at start of line
            snippetType = "autosnippet",
            dscr = "align environment",
        },
        fmta(
            [[
            \begin{align*}
                <>
            \end{align*}
            <>
        ]],
            {
                i(1),
                i(0),
            }
        ),
        { condition = tex_utils.in_text * line_begin } -- in text and at start of line
    ),
    s(
        {trig = "eq", snippetType = "autosnippet", dscr = "[EQ]uation" },
        fmta(
            [[
            \begin{equation}
                <>
            \end{equation}
            <>
        ]],
            {
                i(1),
                i(0),
            }
        ),
        { condition = tex_utils.in_text * line_begin } -- in text and at start of line
    ),
    s(
        {
            trig = "item", -- only at start of line
            snippetType = "autosnippet",
            dscr = "itemize",
        },
        fmta(
            [[
            \begin{itemize}
                \item <>
            \end{itemize}
            <>
        ]],
            {
                i(1),
                i(0),
            }
        ),
        { condition = tex_utils.in_text * line_begin } -- in text and at start of line
    ),
    s(
        {
            trig = "enum", -- only at start of line
            snippetType = "autosnippet",
            dscr = "enumerate",
        },
        fmta(
            [[
            \begin{enumerate}
                \item <>
            \end{enumerate}
            <>
        ]],
            {
                i(1),
                i(0),
            }
        ),
        { condition = tex_utils.in_text * line_begin } -- in text and at start of line
    ),

    s(
        {
            trig = "desc", -- only at start of line
            snippetType = "autosnippet",
            dscr = "Description",
        },
        fmta(
            [[
            \begin{description}
                \item[<>] <>
            \end{description}
            <>
        ]],
            {
                i(1),
                i(2),
                i(0),
            }
        ),
        { condition = tex_utils.in_text * line_begin } -- in text and at start of line
    ),

    s(
        {
            trig = "mb", -- only at start of line
            snippetType = "autosnippet",
            dscr = "[M]ath [B]lock unnumbered",
        },
        fmta(
            [[ 
            \[
                <>
            .\] 
        ]],
            { i(0) }
        ),
        { condition = tex_utils.in_text * line_begin } -- in text and at start of line
    ),
}

local latex_math = {
    s(
        {trig="...", dscr="dots", wordTrig=false, snippetType="autosnippet"},
        { t("\\ldots") },
        { condition = tex_utils.in_mathzone }
    ),
    s(
        {trig="->", dscr="to", wordTrig=false, snippetType="autosnippet"},
        { t("\\to") },
        { condition = tex_utils.in_mathzone }
    ),
    s(
        {trig="<->", dscr="left right arrow", wordTrig=false, snippetType="autosnippet"},
        { t("\\leftrightarrow") },
        { condition = tex_utils.in_mathzone }
    ),
    s(
        {trig="!>", dscr="maps to", wordTrig=false, snippetType="autosnippet"},
        { t("\\mapsto") },
        { condition = tex_utils.in_mathzone }
    ),
    s(
        {trig="\\\\\\", dscr="set minus", wordTrig=false, snippetType="autosnippet"},
        { t("\\setminus") },
        { condition = tex_utils.in_mathzone }
    ),
    s({trig="tt", dscr="text", wordTrig=false, snippetType="autosnippet"},
        fmta("\\text{<>}", {d(1,helpers.get_visual)}),
        { condition = tex_utils.in_mathzone }
    ),
    s(
        {trig="iff", dscr="if and only if", wordTrig=false, snippetType="autosnippet"},
        { t("\\iff") },
        { condition = tex_utils.in_mathzone }
    ),
    s(
        {trig="=>", dscr="implies", wordTrig=false, snippetType="autosnippet"},
        { t("\\implies") },
        { condition = tex_utils.in_mathzone }
    ),
    s(
        {trig="=<", dscr="implied by", wordTrig=false, snippetType="autosnippet"},
        { t("\\impliedby") },
        { condition = tex_utils.in_mathzone }
    ),
    s(
        {trig=">=", dscr="greater than or equal to", wordTrig=false, snippetType="autosnippet"},
        { t("\\ge") },
        { condition = tex_utils.in_mathzone }
    ),
    s(
        {trig="<=", dscr="less than or equal to", wordTrig=false, snippetType="autosnippet"},
        { t("\\le") },
        { condition = tex_utils.in_mathzone }
    ),
    s(
        {trig="!=", dscr="not equal to", wordTrig=false, snippetType="autosnippet"},
        { t("\\neq") },
        { condition = tex_utils.in_mathzone }
    ),
    s(
        {trig="==", dscr="align equals", wordTrig=false, snippetType="autosnippet"},
        fmta("&= <> \\\\", i(1)),
        { condition = tex_utils.in_mathzone }
    ),
    s(
        {trig="AA", dscr="for all", wordTrig=false, snippetType="autosnippet"},
        { t("\\forall") },
        { condition = tex_utils.in_mathzone }
    ),
    s(
        {trig="EE", dscr="there exists", wordTrig=false, snippetType="autosnippet"},
        { t("\\exists") },
        { condition = tex_utils.in_mathzone }
    ),
    s( {trig="OO", dscr="empty set", wordTrig=false, snippetType="autosnippet"},
        { t("\\emptyset")},
        { condition = tex_utils.in_mathzone }
    ),
    s( {trig="NN", dscr="natural numbers", wordTrig=false, snippetType="autosnippet"},
        { t("\\mathbb{N}")},
        { condition = tex_utils.in_mathzone }
    ),
    s( {trig="RR", dscr="real numbers", wordTrig=false, snippetType="autosnippet"},
        { t("\\mathbb{R}")},
        { condition = tex_utils.in_mathzone }
    ),
    s( {trig="QQ", dscr="rationals", wordTrig=false, snippetType="autosnippet"},
        { t("\\mathbb{Q}")},
        { condition = tex_utils.in_mathzone }
    ),
    s( {trig="ZZ", dscr="integers", wordTrig=false, snippetType="autosnippet"},
        { t("\\mathbb{Z}")},
        { condition = tex_utils.in_mathzone }
    ),
    s( {trig="CC", dscr="complex numbers", wordTrig=false, snippetType="autosnippet"},
        { t("\\mathbb{C}")},
        { condition = tex_utils.in_mathzone }
    ),
    s( {trig="mcal", dscr="mathcal", wordTrig=false, snippetType="autosnippet"},
        { t("\\mathcal{"), i(1), t("}")},
        { condition = tex_utils.in_mathzone }
    ),
    s( {trig="lll", dscr="ell", wordTrig=false, snippetType="autosnippet"},
        { t("\\ell")},
        { condition = tex_utils.in_mathzone }
    ),
    s( {trig="nabla", dscr="nabla", wordTrig=false, snippetType="autosnippet"},
        { t("\\nabla")},
        { condition = tex_utils.in_mathzone }
    ),
    s( {trig="ooo", dscr="infinity", wordTrig=false, snippetType="autosnippet"},
        { t("\\infty")},
        { condition = tex_utils.in_mathzone }
    ),
    s( {trig="set", dscr="start a set", wordTrig=true, snippetType="autosnippet"},
        { t("\\{"), i(1), t("\\}")},
        { condition = tex_utils.in_mathzone }
    ),
    s( {trig="norm", dscr="norm", wordTrig=true, snippetType="autosnippet"},
        { t("\\|"), i(1), t("\\|")},
        { condition = tex_utils.in_mathzone }
    ),
    s( {trig="cc", dscr="subset", wordTrig=false, snippetType="autosnippet"},
        { t("\\subset")},
        { condition = tex_utils.in_mathzone }
    ),
    s( {trig="notin", dscr="not in", wordTrig=false, snippetType="autosnippet"},
        { t("\\not\\in")},
        { condition = tex_utils.in_mathzone }
    ),
    s( {trig="inn", dscr="in", wordTrig=false, snippetType="autosnippet"},
        { t("\\in")},
        { condition = tex_utils.in_mathzone }
    ),
    s( {trig="ceil", dscr="ceiling", wordTrig=false, snippetType="autosnippet"},
        { t("\\left\\lceil "), i(1), t("\\right\\rceil")},
        { condition = tex_utils.in_mathzone }
    ),
    s( {trig="floor", dscr="floor", wordTrig=false, snippetType="autosnippet"},
        { t("\\left\\lfloor "), i(1), t("\\right\\rfloor")},
        { condition = tex_utils.in_mathzone }
    ),
    s({trig="hat", dscr="hat", wordTrig=false, snippetType="autosnippet"},
        fmta("\\hat{<>}", {d(1,helpers.get_visual)}),
        { condition = tex_utils.in_mathzone }
    ),
    s({trig="bar", dscr="overline bar", wordTrig=false, snippetType="autosnippet"},
        fmta("\\overline{<>}", {d(1,helpers.get_visual)}),
        { condition = tex_utils.in_mathzone }
    ),
    s( {trig="bmat", dscr="bracket matrix", wordTrig=false, snippetType="autosnippet"},
        { t("\\begin{bmatrix}"), i(1), t("\\end{bmatrix}")},
        { condition = tex_utils.in_mathzone }
    ),
    s( {trig="pmat", dscr="parenthesis matrix", wordTrig=false, snippetType="autosnippet"},
        { t("\\begin{pmatrix}"), i(1), t("\\end{pmatrix}")},
        { condition = tex_utils.in_mathzone }
    ),
    s( {trig="case", dscr="cases", wordTrig=false, snippetType="autosnippet"},
        { t("\\begin{cases}"), i(1), t("\\end{cases}")},
        { condition = tex_utils.in_mathzone }
    ),
    s({trig="**", dscr="cdot", wordTrig=false, snippetType="autosnippet"},
        { t("\\cdot") },
        { condition = tex_utils.in_mathzone }
    ),
    s({trig="xx", dscr="times", wordTrig=false, snippetType="autosnippet"},
        { t("\\times") },
        { condition = tex_utils.in_mathzone }
    ),
    s({trig="dint", dscr="definite integral", wordTrig=true, snippetType="autosnippet"},
        fmta("\\int_{<>}^{<>} <>", {i(1,"-\\infty"),i(2,"\\infty"), d(3,helpers.get_visual)}),
        { condition = tex_utils.in_mathzone }
    ),
    s({trig="/", dscr="fraction", wordTrig=false, snippetType="autosnippet"},
        fmta("\\frac{<>}{<>}", {d(1,helpers.get_visual), i(2,"y")}),
        { condition = function() return tex_utils.in_mathzone and conds.has_selected_text() end }
    ),
    s({trig="//", dscr="fraction", wordTrig=false, snippetType="autosnippet"},
        fmta("\\frac{<>}{<>}", {i(1,"x"), i(2,"y")}),
        { condition = tex_utils.in_mathzone }
    ),
    s({trig="^^", dscr="superscript", wordTrig=false, snippetType="autosnippet"},
        fmta("^{<>}", {i(1,"x")}),
        { condition = tex_utils.in_mathzone }
    ),
    s({trig="__", dscr="subscript", wordTrig=false, snippetType="autosnippet"},
        fmta("_{<>}", {i(1,"x")}),
        { condition = tex_utils.in_mathzone }
    ),
    -- shorthand subscripts for letter-number combinations
    s({trig="([%a])(%d)", dscr="letter-number subscript", wordTrig=false, regTrig=true, snippetType="autosnippet"},
        f(function(_, snip) return string.format("%s_%s", snip.captures[1], snip.captures[2]) end, {}),
        { condition = tex_utils.in_mathzone }
    ),
    s({trig="([%a])(%d%d)", dscr="letter-number subscript", wordTrig=false, regTrig=true, snippetType="autosnippet"},
        f(function(_, snip) return string.format("%s_{%s}", snip.captures[1], snip.captures[2]) end, {}),
        { condition = tex_utils.in_mathzone }
    ),
    s({trig="hat", dscr="hat", wordTrig=false, snippetType="autosnippet"},
        fmta("\\hat{<>}", {d(1, helpers.get_visual)}),  -- Visual selection or empty space
        { condition = tex_utils.in_mathzone }
    ),
    s({trig="bar", dscr="bar", wordTrig=false, snippetType="autosnippet"},
        fmta("\\bar{<>}", {d(1, helpers.get_visual)}),  -- Visual selection or empty space
        { condition = tex_utils.in_mathzone }
    ),
    s( {trig="cup", dscr="cup", wordTrig=false, snippetType="autosnippet"},
        { t("\\cup")},
        { condition = tex_utils.in_mathzone }
    ),
    s({trig="Cup", dscr="big cup", wordTrig=false, snippetType="autosnippet"},
        fmta("\\bigcup_{<>}", {i(1)}),
        { condition = tex_utils.in_mathzone }
    ),
    s( {trig="cap", dscr="cap", wordTrig=false, snippetType="autosnippet"},
        { t("\\cap")},
        { condition = tex_utils.in_mathzone }
    ),
    s({trig="Cap", dscr="big cap", wordTrig=false, snippetType="autosnippet"},
        fmta("\\bigcap_{<>}", {i(1)}),
        { condition = tex_utils.in_mathzone }
    ),
    s({trig="sum", dscr="summation", wordTrig=true, snippetType="autosnippet"},
        fmta("\\sum_{<>}^{<>} <>", {i(1,"n=1"), i(2, "\\infty"), i(3)}),
        { condition = tex_utils.in_mathzone }
    ),
    s({trig="prod", dscr="product", wordTrig=true, snippetType="autosnippet"},
        fmta("\\prod_{<>}^{<>} <>", {i(1,"n=1"), i(2, "\\infty"), i(3)}),
        { condition = tex_utils.in_mathzone }
    ),
    s({trig="part", dscr="d/dx", wordTrig=true, snippetType="autosnippet"},
        fmta("\\frac{\\partial <>}{\\partial <>}", {i(1,"f"), i(2, "x")}),
        { condition = tex_utils.in_mathzone }
    ),
    s({trig="sq", dscr="square root", wordTrig=true, snippetType="autosnippet"},
        fmta("\\sqrt{<>}", {i(1,"x")}),
        { condition = tex_utils.in_mathzone }
    ),
    s({trig="root", dscr="square root", wordTrig=true, snippetType="autosnippet"},
        fmta("\\sqrt[<>]{<>}", {i(1,""), i(2,"x")}),
        { condition = tex_utils.in_mathzone }
    ),
    s({trig="lim", dscr="limit", wordTrig=true, snippetType="autosnippet"},
        fmta("\\lim_{<>\\to<>} <>", {i(1,"n"), i(2, "\\infty"), i(3)}),
        { condition = tex_utils.in_mathzone }
    ),
    s({trig="limsup", dscr="limit supremum", wordTrig=true, snippetType="autosnippet"},
        fmta("\\limsup_{<>\\to<>} <>", {i(1,"n"), i(2, "\\infty"), i(3)}),
        { condition = tex_utils.in_mathzone }
    ),
    s({trig="liminf", dscr="limit infimum", wordTrig=true, snippetType="autosnippet"},
        fmta("\\liminf_{<>\\to<>} <>", {i(1,"n"), i(2, "\\infty"), i(3)}),
        { condition = tex_utils.in_mathzone }
    ),
    s({ trig="()", dscr="left right parens", wordTrig=false, snippetType="autosnippet"},
        fmta( [[ \left( <> \right) <> ]], { d(1, helpers.get_visual), i(0), }),
        {condition=tex_utils.in_mathzone, show_condition=tex_utils.in_mathzone}
    ),
    s({ trig="{}", dscr="left right braces", wordTrig=false, snippetType="autosnippet"},
        fmta( [[ \left\{ <> \right\} <> ]], { d(1, helpers.get_visual), i(0), }),
        {condition=tex_utils.in_mathzone, show_condition=tex_utils.in_mathzone}
    ),
    s({ trig="[]", dscr="left right brackets", wordTrig=false, snippetType="autosnippet"},
        fmta( [[ \left[ <> \right] <> ]], { d(1, helpers.get_visual), i(0), }),
        {condition=tex_utils.in_mathzone, show_condition=tex_utils.in_mathzone}
    ),
    s({ trig="<>", dscr="left right angle", wordTrig=false, snippetType="autosnippet"},
        fmta( [[ \left\langle <> \right\rangle <> ]], { d(1, helpers.get_visual), i(0), }),
        {condition=tex_utils.in_mathzone, show_condition=tex_utils.in_mathzone}
    ),
    -- s({ trig="lr", dscr="left right misc", wordTrig=false, snippetType="autosnippet"},
    --     fmta( [[ \left<> <> \right<> <> ]], {i(1), d(2, helpers.get_visual), i(3), i(0), }),
    --     {condition=tex_utils.in_mathzone, show_condition=tex_utils.in_mathzone}
    -- ),
    s({trig="lr", dscr="left-right misc", wordTrig=false, snippetType="autosnippet"},
        fmt([[\left{} {} \right{} {}]],{
            i(1), d(2, helpers.get_visual, {}),
            d(3, function (args, _)
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
            end, {1}), i(4)
        })
    ),
    -- sub super scripts
    s(
        {
            trig = "(%a)(%d)",
            snippetType = "autosnippet",
            regTrig = true,
            name = "auto subscript",
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
        { condition = tex_utils.in_mathzone }
    ),
    s(
        {
            trig = "(%a)_(%d%d)",
            regTrig = true,
            snippetType = "autosnippet",
            name = "auto subscript 2",
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
        { condition = tex_utils.in_mathzone }
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
    --     { condition = tex_utils.in_mathzone }
    -- ),

    -- Examples of Greek letter snippets, autotriggered for efficiency
    s({ trig = ";a", dscr = "alpha", snippetType = "autosnippet" }, {
        t("\\alpha"),
    }, { condition = tex_utils.in_mathzone }),
    s({ trig = ";b", dscr = "beta", snippetType = "autosnippet" }, {
        t("\\beta"),
    }, { condition = tex_utils.in_mathzone }),
    s({ trig = ";g", dscr = "gamma", snippetType = "autosnippet" }, {
        t("\\gamma"),
    }, { condition = tex_utils.in_mathzone }),
    s({ trig = ";G", dscr = "Gamma", snippetType = "autosnippet" }, {
        t("\\Gamma"),
    }, { condition = tex_utils.in_mathzone }),
    s({ trig = ";d", dscr = "delta", snippetType = "autosnippet" }, {
        t("\\delta"),
    }, { condition = tex_utils.in_mathzone }),
    s({ trig = ";D", dscr = "Delta", snippetType = "autosnippet" }, {
        t("\\Delta"),
    }, { condition = tex_utils.in_mathzone }),
    s({ trig = ";ep", dscr = "epsilon", snippetType = "autosnippet" }, {
        t("\\epsilon"),
    }, { condition = tex_utils.in_mathzone }),
    s({ trig = ";z", dscr = "zeta", snippetType = "autosnippet" }, {
        t("\\zeta"),
    }, { condition = tex_utils.in_mathzone }),
    s({ trig = ";et", dscr = "eta", snippetType = "autosnippet" }, {
        t("\\eta"),
    }, { condition = tex_utils.in_mathzone }),
    s(
        { trig = ";h", dscr = "theta", snippetType = "autosnippet" },
        { -- h is the same as vim digraph
            t("\\theta"),
        },
        { condition = tex_utils.in_mathzone }
    ),
    s(
        { trig = ";H", dscr = "Theta", snippetType = "autosnippet" },
        { -- h is the same as vim digraph
            t("\\Theta"),
        },
        { condition = tex_utils.in_mathzone }
    ),
    s({ trig = ";i", dscr = "iota", snippetType = "autosnippet" }, {
        t("\\iota"),
    }, { condition = tex_utils.in_mathzone }),
    s({ trig = ";k", dscr = "kappa", snippetType = "autosnippet" }, {
        t("\\kappa"),
    }, { condition = tex_utils.in_mathzone }),
    s({ trig = ";l", dscr = "lambda", snippetType = "autosnippet" }, {
        t("\\lambda"),
    }, { condition = tex_utils.in_mathzone }),
    s({ trig = ";L", dscr = "Lambda", snippetType = "autosnippet" }, {
        t("\\Lambda"),
    }, { condition = tex_utils.in_mathzone }),
    s({ trig = ";m", dscr = "mu", snippetType = "autosnippet" }, {
        t("\\mu"),
    }, { condition = tex_utils.in_mathzone }),
    s({ trig = ";n", dscr = "nu", snippetType = "autosnippet" }, {
        t("\\nu"),
    }, { condition = tex_utils.in_mathzone }),
    s({ trig = ";x", dscr = "xi", snippetType = "autosnippet" }, {
        t("\\xi"),
    }, { condition = tex_utils.in_mathzone }),
    s({ trig = ";X", dscr = "Xi", snippetType = "autosnippet" }, {
        t("\\Xi"),
    }, { condition = tex_utils.in_mathzone }),
    -- do not need a snippet for pi as same characters -> ;pi and \pi
    s({ trig = ";r", dscr = "rho", snippetType = "autosnippet" }, {
        t("\\rho"),
    }, { condition = tex_utils.in_mathzone }),
    s({ trig = ";s", dscr = "sigma", snippetType = "autosnippet" }, {
        t("\\sigma"),
    }, { condition = tex_utils.in_mathzone }),
    s({ trig = ";S", dscr = "Sigma", snippetType = "autosnippet" }, {
        t("\\Sigma"),
    }, { condition = tex_utils.in_mathzone }),
    s({ trig = ";t", dscr = "tau", snippetType = "autosnippet" }, {
        t("\\tau"),
    }, { condition = tex_utils.in_mathzone }),
    s({ trig = ";u", dscr = "upsilon", snippetType = "autosnippet" }, {
        t("\\upsilon"),
    }, { condition = tex_utils.in_mathzone }),
    s({ trig = ";U", dscr = "Upsilon", snippetType = "autosnippet" }, {
        t("\\Upsilon"),
    }, { condition = tex_utils.in_mathzone }),
    s({ trig = ";f", dscr = "phi", snippetType = "autosnippet" }, {
        t("\\phi"),
    }, { condition = tex_utils.in_mathzone }),
    s({ trig = ";F", dscr = "Phi", snippetType = "autosnippet" }, {
        t("\\Phi"),
    }, { condition = tex_utils.in_mathzone }),
    s({ trig = ";c", dscr = "chi", snippetType = "autosnippet" }, {
        t("\\chi"),
    }, { condition = tex_utils.in_mathzone }),
    s({ trig = ";p", dscr = "psi", snippetType = "autosnippet" }, {
        t("\\psi"),
    }, { condition = tex_utils.in_mathzone }),
    s({ trig = ";P", dscr = "Psi", snippetType = "autosnippet" }, {
        t("\\Psi"),
    }, { condition = tex_utils.in_mathzone }),
    s({ trig = ";o", dscr = "omega", snippetType = "autosnippet" }, {
        t("\\omega"),
    }, { condition = tex_utils.in_mathzone }),
    s({ trig = ";O", dscr = "Omega", snippetType = "autosnippet" }, {
        t("\\Omega"),
    }, { condition = tex_utils.in_mathzone }),
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
    --     { condition = tex_utils.in_mathzone }
    -- ),
    -- s({
    --     trig = "^",
    --     dscr = "exponent",
    --     docstring = "^{|}",
    --     wordTrig = false,
    --     snippetType = "autosnippet",
    -- }, { t("^{"), i(1), t("}") }, {
    --     condition = tex_utils.in_mathzone,
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
    --         condition = tex_utils.in_mathzone,
    --         show_condition = tex_utils.in_mathzone,
    --     }
    -- ),
}

local latex_tikz = {
    s(
        { trig = "dd", dscr="TikZ Draw", wordTrig=true, snippetType="autosnippet" },
        fmta([[
            \draw[<>] (<>) <> (<>);
            <>
            ]], {
            i(1, "->"),
            i(2, "x"),
            i(3, "--"),
            i(4, "y"),
            i(0),
        }),
        { condition = line_begin * tex_utils.in_tikz }
    ),
    s({trig="nn", dscr="TikZ node", wordTrig=true, snippetType="autosnippet"},
        fmta( [[
            \node[<>] (<>) <> {\(<>\)};
            <>
            ]],
            { i(1), i(2), i(3, "at (0,0) "), d(4, function (args) return sn(nil, i(1, args[1][1])) end, {2}), i(0), }),
        { condition = line_begin * tex_utils.in_tikz }
    ),
}

-- Add all snippet groups under 'tex' filetype
ls.add_snippets("tex", latex_templates)
ls.add_snippets("tex", latex_text)
ls.add_snippets("tex", latex_math)
ls.add_snippets("tex", latex_sections)
ls.add_snippets("tex", latex_envs)

ls.add_snippets("tex", latex_tikz)
