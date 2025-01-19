return {
    --  {
    --    "stevearc/conform.nvim",
    --    -- event = 'BufWritePre', -- uncomment for format on save
    --    opts = require "configs.conform",
    --  },

    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("configs.treesitter")
        end,
    },


    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        config = function()
            require("configs.conform")
        end,
    },

    -- These are some examples, uncomment them if you want to see them work!
    {
        "neovim/nvim-lspconfig",
        config = function()
            require "configs.lspconfig"
        end,
    },

    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
    }



}
