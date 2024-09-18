-- clear language snippets
require("luasnip.session.snippet_collection").clear_snippets "all"

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

local helpers = require("snippets.helper_functions")


local section_heading = {
    s({trig = "^(.*)hashbox", wordTrig = false, regTrig = true},
      fmta([[
         <c>#<a>#
         <c># <> #
         <c>#<a>#
        ]],
        {
          a = f(function(args)
            local width = #args[1][1] -- Get the length of the content
            return string.rep("#", width + 2) -- Generate a line of dashes with padding
          end, {1}), -- Top border
          c = f( function(_, snip) return snip.captures[1] end ),
          d(1, helpers.get_visual),
        }
      )
    ),
}

local fun_snips = {
    s({trig = "box", dscr = "Create a box (can also visually wrap)"},
        fmta(
          [[
          ┌<a>┐
          │ <> │
          └<a>┘
          ]],
          {
            -- can set repeats by assigning name
            a = f(function(args)
              local width = #args[1][1] -- Get the length of the content
              return string.rep("─", width + 2) -- Generate a line of dashes with padding
            end, {1}), -- Top border
            d(1, helpers.get_visual) -- Dynamic content or visual selection
          }
        )
      ),
}




ls.add_snippets("all", section_heading)
ls.add_snippets("all", fun_snips)
