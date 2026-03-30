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

local math_snippets = require("snippets.math")

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
-- ls.add_snippets("tex", latex_math)
ls.add_snippets("tex", math_snippets(tex_utils.in_mathzone))
ls.add_snippets("tex", latex_sections)
ls.add_snippets("tex", latex_envs)

ls.add_snippets("tex", latex_tikz)
