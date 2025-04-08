-- clear language snippets
require("luasnip.session.snippet_collection").clear_snippets "python"


local status_ok, ls = pcall(require, "luasnip")
if not status_ok then
    return
end

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


local ts_utils = require("nvim-treesitter.ts_utils")

local py_utils = {}

-- Check if cursor is inside a function definition
py_utils.in_function = function()
    local node = ts_utils.get_node_at_cursor()
    while node do
        if node:type() == "function_definition" then
            return true
        end
        node = node:parent()
    end
    return false
end

-- Check if cursor is inside a class definition
py_utils.in_class = function()
    local node = ts_utils.get_node_at_cursor()
    while node do
        if node:type() == "class_definition" then
            return true
        end
        node = node:parent()
    end
    return false
end

py_utils.not_in_class = function()
    return not py_utils.in_class
end

-- Check if cursor is inside a comment
py_utils.in_comment = function()
    local node = ts_utils.get_node_at_cursor()
    while node do
        if node:type() == "comment" then
            return true
        end
        node = node:parent()
    end
    return false
end

-- Check if cursor is inside a docstring (string at function start)
py_utils.in_docstring = function()
    local node = ts_utils.get_node_at_cursor()
    while node do
        if node:type() == "string" then
            local parent = node:parent()
            if parent and parent:type() == "expression_statement" then
                return true
            end
        end
        node = node:parent()
    end
    return false
end

-- Check if cursor is at the beginning of a line (ignoring whitespace)
local line_begin = require("luasnip.extras.expand_conditions").line_begin


ls.add_snippets("python", {
    s("trig_python", t("loaded from python file!!")),
})

ls.add_snippets("python", {
    s("triggington", t("called triggington"))
})


ls.add_snippets("python", {
    s({ trig = "in_cls", wordTrig=false, regTrig=true, snippetType="autosnippet" }, t("in class"), { condition=py_utils.in_class }),
})



-- ls.add_snippets("python", {
--     s("go", t("goats are cool"))
-- })
-- 
-- 
--         s(
--             {
--                 trig = "([^%a])ee",
--                 dscr = "[EE]xponential",
--                 regTrig = true,
--                 wordTrig = false,
--                 snippetType = "autosnippet",
--             },
--             fmta("<>e^{<>}", {
--                 f(function(_, snip)
--                     return snip.captures[1]
--                 end),
--                 d(1, helpers.get_visual),
--             }),
--             { condition = tex_utils.in_mathzone }
--         ),
-- 



-- local latex_math = {
--     -- \frac
--     s(
--         {
--             trig = "([^%a])ff",
--             dscr = "[FF]raction",
--             regTrig = true,
--             wordTrig = false,
--             snippetType = "autosnippet",
--         },
--         fmta("<>\\frac{<>}{<>}", {
--             f(function(_, snip)
--                 return snip.captures[1]
--             end),
--             i(1, "x"),
--             i(2, "y"),
--         }),
--         { condition = tex_utils.in_mathzone } -- `condition` option passed in the snippet `opts` table
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

local structs = {
    s(
        { trig = "^def ", wordTrig = true, regTrig=true, snippetType = "autosnippet" },
        fmt([[
def {}({}) -> {}:
    {}
]], {
            i(1, "name"),
            i(2, "params"),
            i(3, "return_type"),
            i(4, "body"),
        }),
        { snippetType = "autosnippet" }
    ),
    s(
        { trig = "def ", wordTrig = true, snippetType="autosnippet" },
        fmt([[
    def {}(self,{}) -> {}:
        {}
]], {
            i(1, "<fn>"),
            i(2, "<params>"),
            i(3, "<return_type>"),
            i(4, "<body>"),
        }),
        { condition=py_utils.in_class() }
    ),
    s(
        { trig = "^class", wordTrig = true, regTrig=true, snippetType="autosnippet" },
        fmt([[
class {}:
    """{}"""
    {}
]], {
            i(1, "class_name"),
            i(2, "description"),
            i(3, "body"),
        }),
        { condition=py_utils.in_class() }
    )
}

ls.add_snippets("python", structs)


