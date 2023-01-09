
 local get_visual = function(args, parent)
  if (#parent.snippet.env.SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
  else
    return sn(nil, i(1, ''))
  end
end

-- Math context detection
local tex = {}
tex.in_mathzone = function() return vim.fn['vimtex#syntax#in_mathzone']() == 1 end
tex.in_text = function() return not tex.in_mathzone() end

local line_begin = require("luasnip.extras.expand_conditions").line_begin

-- Return snippet tables
return {
    -- TYPEWRITER i.e. \texttt
    s({trig = "([^%a])sd", regTrig = true, wordTrig = false, snippetType="autosnippet", priority=2000},
      fmta( "<>\\texttt{<>}", { f( function(_, snip) return snip.captures[1] end ), d(1, get_visual), }), {condition = tex.in_text}
    ),
    -- ITALIC i.e. \textit
    s({trig = "([^%a])tii", regTrig = true, wordTrig = false, snippetType="autosnippet"},
      fmta( "<>\\textit{<>}", { f( function(_, snip) return snip.captures[1] end ), d(1, get_visual), })
    ),
    -- BOLD i.e. \textbf
    s({trig = "tbb", snippetType="autosnippet"},
      fmta( "\\textbf{<>}", { d(1, get_visual), })
    ),
    -- MATH ROMAN i.e. \mathrm
    s({trig = "([^%a])rmm", regTrig = true, wordTrig = false, snippetType="autosnippet"},
      fmta( "<>\\mathrm{<>}", { f( function(_, snip) return snip.captures[1] end ), d(1, get_visual), })
    ),
    -- MATH CALIGRAPHY i.e. \mathcal
    s({trig = "([^%a])mcc", regTrig = true, wordTrig = false, snippetType="autosnippet"},
      fmta( "<>\\mathcal{<>}", { f( function(_, snip) return snip.captures[1] end ), d(1, get_visual), })
    ),
    -- MATH BOLDFACE i.e. \mathbf
    s({trig = "([^%a])mbf", regTrig = true, wordTrig = false, snippetType="autosnippet"},
      fmta( "<>\\mathbf{<>}", { f( function(_, snip) return snip.captures[1] end ), d(1, get_visual), })
    ),
    -- MATH BLACKBOARD i.e. \mathbb
    s({trig = "([^%a])mbb", regTrig = true, wordTrig = false, snippetType="autosnippet"},
      fmta( "<>\\mathbb{<>}", { f( function(_, snip) return snip.captures[1] end ), d(1, get_visual), })
    ),
}

