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
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local get_visual = function(args, parent)
    if (#parent.snippet.env.SELECT_RAW > 0) then
        return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
    else
        return sn(nil, i(1, ''))
    end
end

local wrap_pair = function(ch1, ch2)
    -- return s({trig=ch1, wordTrig = false, snippetType="autosnippet"},
    -- { t(ch1), d(1, get_visual), t(ch2), })
    return s({ trig = "sd", snippetType = "autosnippet" },
        { f(function(_, snip) return snip.captures[1] end), t(ch1), d(1, get_visual), t(ch2), })
end

-- this is useful for using latex snippets in markdown
-- local x = require("snips/test")

return {
    -- format snippet
    s("snipf", fmt([[ 
    <>({ trig='<>', name='<>', dscr='<>'},
        fmt(<>,
            { <> },
        { delimiters='<>' }
    )<>)<>,]],
        { c(1, { t("s"), t("autosnippet") }), i(2, "trig"), i(3, "trig"), i(4, "dscr"), i(5, "fmt"), i(6, "inputs"),
            i(7, "<>"), i(8, "opts"), i(0) },
        { delimiters = '<>' }
    )),

}



