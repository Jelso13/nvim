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

-- ----------------------------------------------------------------------------
local line_begin = require("luasnip.extras.expand_conditions").line_begin



return {
    s({trig = "nb", regTrig = true, snippetType="autosnippet", dscr="Top-level section"},
      fmta([[
        START
        Basic
        Front: <>
        Back: <>
        Tags: <>
        END
        ]],
        { i(1, "Card Front"), i(2, "Card Back"), i(3, "Tags") }
      ),
      {condition = line_begin}  -- set condition in the `opts` table
    ),
    s({trig = "nr", snippetType="autosnippet", dscr="Top-level section"},
      fmta([[
        START
        Basic_Reversable
        Front: <>
        Back: <>
        Tags: <>
        END
        ]],
        { i(1, "Card Front"), i(2, "Card Back"), i(3, "Tags") }
      ),
      {condition = line_begin}  -- set condition in the `opts` table
    ),
    s({trig = "nt", snippetType="autosnippet", dscr="Top-level section"},
      fmta([[
        START
        Basic_Typing
        Front: <>
        Back: <>
        Tags: <>
        END
        ]],
        { i(1, "Card Front"), i(2, "Card Back"), i(3, "Tags") }
      ),
      {condition = line_begin}  -- set condition in the `opts` table
    ),
    s({trig = "basic", regTrig = true, snippetType="autosnippet", dscr="Top-level section"},
      fmta([[
        START
        Basic
        Front: <>
        Back: <>
        Tags: <>
        END
        ]],
        { i(1, "Card Front"), i(2, "Card Back"), i(3, "Tags") }
      ),
      {condition = line_begin}  -- set condition in the `opts` table
    ),
    s({trig = "reverse", snippetType="autosnippet", dscr="Top-level section"},
      fmta([[
        START
        Basic_Reversable
        Front: <>
        Back: <>
        Tags: <>
        END
        ]],
        { i(1, "Card Front"), i(2, "Card Back"), i(3, "Tags") }
      ),
      {condition = line_begin}  -- set condition in the `opts` table
    ),
    s({trig = "typing", snippetType="autosnippet", dscr="Top-level section"},
      fmta([[
        START
        Basic_Typing
        Front: <>
        Back: <>
        Tags: <>
        END
        ]],
        { i(1, "Card Front"), i(2, "Card Back"), i(3, "Tags") }
      ),
      {condition = line_begin}  -- set condition in the `opts` table
    ),
    -- INLINE
    s({trig = "nb", dscr="Top-level section"},
      fmta([[
        STARTI [Basic] Front: <> Back: <> Tags: <> ENDI
        ]],
        { i(1, "Card Front"), i(2, "Card Back"), i(3, "Tags") }
      )
    ),
    s({trig = "nr", dscr="Top-level section"},
      fmta([[
        STARTI [Basic_Reversable] Front: <> Back: <> Tags: <> ENDI
        ]],
        { i(1, "Card Front"), i(2, "Card Back"), i(3, "Tags") }
      )
    ),
    s({trig = "nt", dscr="Top-level section"},
      fmta([[
        STARTI [Basic_Typing] Front: <> Back: <> Tags: <> ENDI
        ]],
        { i(1, "Card Front"), i(2, "Card Back"), i(3, "Tags") }
      )
    ),
    s({trig = "basic", dscr="Top-level section"},
      fmta([[
        STARTI [Basic] Front: <> Back: <> Tags: <> ENDI
        ]],
        { i(1, "Card Front"), i(2, "Card Back"), i(3, "Tags") }
      )
    ),
    s({trig = "reverse", dscr="Top-level section"},
      fmta([[
        STARTI [Basic_Reversable] Front: <> Back: <> Tags: <> ENDI
        ]],
        { i(1, "Card Front"), i(2, "Card Back"), i(3, "Tags") }
      )
    ),
    s({trig = "typing", dscr="Top-level section"},
      fmta([[
        STARTI [Basic_Typing] Front: <> Back: <> Tags: <> ENDI
        ]],
        { i(1, "Card Front"), i(2, "Card Back"), i(3, "Tags") }
      )
    ),
}


