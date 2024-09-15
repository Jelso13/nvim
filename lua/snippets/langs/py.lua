local status_ok, ls = pcall(require, "luasnip")
if not status_ok then
    return
end

require("luasnip.session.snippet_collection").clear_snippets("python")

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
local ls = require("luasnip");


-- local x = {
    -- Paired back ticks
    -- s({trig="([^`])sd", snippetType="autosnippet", regTrig=true, wordTrig=false},
    -- s({ trig = "sd", snippetType = "autosnippet" },
    --     { f(function(_, snip) return snip.captures[1] end), t("`"), d(1, get_visual), t("`"), }),

    -- -- Paired double quotes
    -- s({ trig = '([ `=%{%(%[])"', regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    --     { f(function(_, snip) return snip.captures[1] end), t('"'), d(1, get_visual), t('"'), }),

    -- -- Paired single quotes
    -- s({ trig = "([ =%{%(%[])'", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    --     { f(function(_, snip) return snip.captures[1] end), t("'"), d(1, get_visual), t("'"), }),


    -- s({ trig = "test", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
    --     { f(function(_, snip) return snip.captures[1] end), t("'"), d(1, get_visual), t("'"), }),

s("trig_python", t("loaded from python file!!"))
-- }

-- print("HIT IN PYTHON SNIPPETS")
-- 
-- ls.add_snippets(x);

