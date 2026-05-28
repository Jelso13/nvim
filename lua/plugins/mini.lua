return {
    { -- Collection of various small independent plugins/modules
        "nvim-mini/mini.nvim",
        config = function()
            -- Better Around/Inside textobjects
            --
            -- Examples:
            --  - va)  - [V]isually select [A]round [)]paren
            --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
            --  - ci'  - [C]hange [I]nside [']quote
            require("mini.ai").setup({ n_lines = 500 })

            -- ... and there is more!
            --  Check out: https://github.com/echasnovski/mini.nvim
            -- colors
            local hipatterns = require("mini.hipatterns")
            hipatterns.setup({
                highlighters = {
                    -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
                    critical = {
                        pattern = "%f[%w]()CRITICAL()%f[%W]",
                        group = "MiniHipatternsFixme",
                    },
                    error = {
                        pattern = "%f[%w]()ERROR()%f[%W]",
                        group = "MiniHipatternsFixme",
                    },
                    delete = {
                        pattern = "%f[%w]()DELETE()%f[%W]",
                        group = "MiniHipatternsFixme",
                    },
                    remove = {
                        pattern = "%f[%w]()REMOVE()%f[%W]",
                        group = "MiniHipatternsFixme",
                    },
                    fixme = {
                        pattern = "%f[%w]()FIXME()%f[%W]",
                        group = "MiniHipatternsFixme",
                    },
                    important = {
                        pattern = "%f[%w]()IMPORTANT()%f[%W]",
                        group = "MiniHipatternsFixme",
                    },
                    hack = {
                        pattern = "%f[%w]()HACK()%f[%W]",
                        group = "MiniHipatternsHack",
                    },
                    todo = {
                        pattern = "%f[%w]()TODO()%f[%W]",
                        group = "MiniHipatternsTodo",
                    },
                    note = {
                        pattern = "%f[%w]()NOTE()%f[%W]",
                        group = "MiniHipatternsNote",
                    },
                    -- info  = { pattern = '%f[%w]()INFO()%f[%W]',  group = 'MiniHipatternsInfo'  },

                    -- Highlight hex color strings (`#rrggbb`) using that color
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            })
        end,
    },
}
