-- clear language snippets
require("luasnip.session.snippet_collection").clear_snippets("sh")

local status_ok, ls = pcall(require, "luasnip")
if not status_ok then
    return
end
-- abbreviations used
local s = ls.snippet
local c = ls.choice_node
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local ls = require("luasnip")


-- FIX: This is broken because the ]] is closed early
local conditionals = {
  s(
    {trig = "if [[", snippetType="autosnippet", dscr = "complete conditional",
    docstring = [[
      if [[<>]\]; then
          <>
      fi
    ]]},
    fmta( "if [[<>; then\n <> \nfi ",
      {
        i(1),  -- first placeholder
        i(2),  -- second placeholder
      }
    )
  ),
}

ls.add_snippets("sh", conditionals)

