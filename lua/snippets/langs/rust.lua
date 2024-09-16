local ls = require("luasnip")

local s, i, t = ls.s, ls.insert_node, ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local c = ls.choice_node


ls.add_snippets("rust", {
    s( "modtest", fmt(
            [[
                #[cfg(test)]
                mod test {{
                {}
    
                    {}
                }}
            ]],
            { c(1, { t "  use super::*;", t ""}), i(0), }
        )
    ),

})

