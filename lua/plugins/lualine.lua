return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()

        local mode_map = {
          n = "N",
          i = "I",
          v = "V",
          V = "VL",
          ["\22"] = "VB", -- visual block
          c = "C",
          R = "R",
          t = "T",
        }


        require("lualine").setup({
            options = {
                icons_enabled = vim.g.have_nerd_font,
                theme = "auto",

                -- important for modern neovim setups
                globalstatus = true,

                -- component_separators = { left = "", right = "" },
                -- section_separators = { left = "", right = "" },
                component_separators = { left = "|", right = "|" },
                section_separators = { left = "", right = "" },
            },


            sections = {
                lualine_a = {
                  {
                    "mode",
                    fmt = function(str)
                      local mode = vim.fn.mode()
                      return mode_map[mode] or mode
                    end,
                  },
                },
                lualine_b = { "branch",
                    {
                      "diff",
                      symbols = {
                        added = "+",
                        modified = "~",
                        removed = "-",
                      },
                    },
                    "diagnostics", -- "lsp_status" 
                    {
                      function()
                        local clients = vim.lsp.get_clients({ bufnr = 0 })
                        if #clients == 0 then
                          return ""
                        end
                        return "󰰎"
                      end,
                    },
                },
                -- lualine_c = { "filename"},
                lualine_c = {
                  {
                    "filename",
                    path = 1,            -- relative path (more useful than name alone)
                    symbols = {
                      modified = "●",
                      readonly = "",
                    },
                  },
                },
                lualine_x = { "filetype" },
                lualine_y = {  },
                lualine_z = {
                  function()
                    return "%p%%"
                  end,
                  function()
                    return "%l:%c"
                  end,
                }
            },

            inactive_sections = {
                lualine_c = { "filename" },
                lualine_x = { "location" },
            },

        })
    end,
}
