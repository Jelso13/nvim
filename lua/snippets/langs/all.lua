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

    s({trig = "^(.*)hashbox", 
    dscr = "Hash box that accounts for comments",
    docstring = [[
          ######
          # <> #
          ######
          ]],
    wordTrig = false, regTrig = true},
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
    )
}

local fun_snips = {
    s({trig = "box", dscr = "Create a box (can also visually wrap)",
        docstring = [[
          ┌────┐
          │ <> │
          └────┘
          ]]
    },
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

-- 
-- --DELETE: temp test 
-- local ls = require("luasnip")
-- local s = ls.snippet
-- local t = ls.text_node
-- local i = ls.insert_node
-- local c = ls.choice_node
-- 
-- ls.add_snippets("all", {
--   s("greet", c(1, {
--     t("Hello"),
--     t("Hi"),
--     t("Hey"),
--   })),
-- })

-- a "time" snippet that calls os.date() each time you expand it
local time_snippet = s("time", {
  f(
    -- the function: return a list of lines to insert
    function(_, _snip, _user_args)
      return { os.date("%H:%M:%S") }
    end,
    -- no arguments needed, so an empty table
    {}
  ),
})
-- a "time" snippet that calls os.date() each time you expand it
local date_snippet = s("date", {
  f(
    -- the function: return a list of lines to insert
    function(_, _snip, _user_args)
      return { os.date("%Y-%m-%d") }
    end,
    {}
  ),
})

local tst = s({trig = "info:(%w+)", regTrig = true, snippetType="autosnippet"},
  f(function(_, snip)
    local filename = snip.env.TM_FILENAME
    local full_trigger = snip.trigger
    local captured_word = snip.captures[1]

    return {
      "--- Snippet Info ---",
      "File: " .. filename,
      "Triggered by: '" .. full_trigger .. "'",
      "Captured word: '" .. captured_word .. "'",
    }
  end, {})
)

-- register it for all filetypes (or switch "all" → "tex" if you only want it in .tex)
ls.add_snippets("all", { time_snippet, date_snippet, tst})

