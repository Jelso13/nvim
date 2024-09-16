-- clear language snippets
require("luasnip.session.snippet_collection").clear_snippets("lua")

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
local ls = require("luasnip")

ls.add_snippets("lua", {
    s("trig_lua", t("loaded from lua file!!")),
    -- s("req", fmt([[local {} = require "{}"]],
    --     {f(function(import_name)
    --         return import_name[1]
    --     end, { 1 }), i(1) })),

    -- fill in require statement and assign local to last .x part
    s(
        "req",
        fmt([[local {} = require "{}"]], {
            f(function(import_name)
                local parts = vim.split(import_name[1][1], ".", true)
                return parts[#parts] or ""
            end, { 1 }),
            i(1),
        })
    ),

    -- s({
    --     trig = "snippet",
    --     desc = "snippet for creating snippets",
    -- }, {
    --     fmt([[
    -- s({
    --     trig = "{}",
    --     desc = "{}",
    -- }, {
    --     {}
    -- }
    --     ]], {
    --         f(function(trig)
    --             local parts = vim.split(import_name[1][1], ".", true)
    --             return parts[#parts] or ""
    --         end, { 1 }),
    --         i(1),
    --     }),
    -- }),
})
local builtin = require("telescope.builtin")
