-- clear language snippets
require("luasnip.session.snippet_collection").clear_snippets("lua")

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


--    s({trig = "^(.*)hashbox", 
--    dscr = "Hash box that accounts for comments",
--    docstring = [[
--          ######
--          # <> #
--          ######
--          ]],
--    wordTrig = false, regTrig = true},
--      fmta([[
--         <c>#<a>#
--         <c># <> #
--         <c>#<a>#
--        ]],
--        {
--          a = f(function(args)
--            local width = #args[1][1] -- Get the length of the content
--            return string.rep("#", width + 2) -- Generate a line of dashes with padding
--          end, {1}), -- Top border
--          c = f( function(_, snip) return snip.captures[1] end ),
--          d(1, helpers.get_visual),
--        }
--      )
--    ),
--
--
--     -- Snippet for section
--     s({ trig = "sec", descr = "LaTeX section" }, {
--         t("\\section{"), i(1), t("}"),
--     }),

local meta = {
    s({trig = "snip", dscr = "Create a box (can also visually wrap)",
        docstring = [[
          snippet
          ]]
    },
        fmta(
          [[
        s({trig="<>", dscr="<>", 
            docstring=<>,
            wordTrig=<>,
            regTrig=<>
            }, <>
        )
          ]],
          {
            -- can set repeats by assigning name
            i(1),
            i(2),
            c(3, {
                fmta('"<>"',i(1)),
                fmta("[[<>]]",i(1)),
            }),
            c(4, {t("false"),t("true")}),
            c(5, {t("false"),t("true")}),
            c(6, {
                fmta('{<>}',i(1)),
                fmta("fmta([[<>]])",i(1)),
            }),
          }
        )
      ),

}

ls.add_snippets("lua", meta)
