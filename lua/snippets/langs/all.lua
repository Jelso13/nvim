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

local get_visual = function(args, parent)
  if (#parent.snippet.env.SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
  else
    return sn(nil, i(1, ''))
  end
end

local wrap_pair = function (ch1, ch2)
  -- return s({trig=ch1, wordTrig = false, snippetType="autosnippet"},
    -- { t(ch1), d(1, get_visual), t(ch2), })
    return s({ trig = "sd", snippetType = "autosnippet" },
        { f(function(_, snip) return snip.captures[1] end), t(ch1), d(1, get_visual), t(ch2), })
end

-- this is useful for using latex snippets in markdown
-- local x = require("snips/test")
print("HIT IN all.lua")

return
{
    Paired back ticks
    s({trig="([^`])sd", snippetType="autosnippet", regTrig=true, wordTrig=false},
    s({ trig = "sd", snippetType = "autosnippet" },
        { f(function(_, snip) return snip.captures[1] end), t("`"), d(1, get_visual), t("`"), }),

    Paired double quotes
    s({ trig = '([ `=%{%(%[])"', regTrig = true, wordTrig = false, snippetType = "autosnippet" },
        { f(function(_, snip) return snip.captures[1] end), t('"'), d(1, get_visual), t('"'), }),

    -- Paired single quotes
    s({ trig = "([ =%{%(%[])'", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
        { f(function(_, snip) return snip.captures[1] end), t("'"), d(1, get_visual), t("'"), }),


    s({ trig = "test", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
        { f(function(_, snip) return snip.captures[1] end), t("'"), d(1, get_visual), t("'"), }),

    s("trig", t("loaded!!"))
}

