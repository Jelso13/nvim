return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "williamboman/mason.nvim",
            -- languages
            "mfussenegger/nvim-dap-python",
        },
        config = function()
            require("dap.config")
        end,
    },
    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = { "mfussenegger/nvim-dap" },
        config = function(_, opts)
            require("dap-python").setup("python")
        end,
    },
}

