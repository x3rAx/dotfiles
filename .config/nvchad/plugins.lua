local plugins = {

    -- Copilot
    { "github/copilot.vim",
        lazy = false,
    },

    -- Syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                "c", "lua", "rust", "vim", "vimdoc",
            },
        },
    },

    -- Auto-installed binaries
    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {}, -- Overwrite the default list to prevent installing binaries already installed by home-manager
        },
    },

    -- Auto-completion
    {
        "hrsh7th/nvim-cmp",
        opts = function()
            return require "custom.configs.cmp"
        end,
    },

    -- Hex editor
    {
        "rootkiter/vim-hexedit",
        cmd = { "Hexedit" },
        lazy = false, -- TODO: Use `event = "VeryLazy"` or do only load when file is binary. Have a look at this commit to get an idea: https://github.com/RaafatTurki/hex.nvim/commit/944b9913d7fd39d51a2c2b5539ab138a9f22305a
    },

    -- File explorer
    {
        "nvim-tree/nvim-tree.lua",
        opts = function()
            return require "custom.configs.nvimtree"
        end,
    },

    -- Surround
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },

    -- Notifications
    {
        "rcarriga/nvim-notify",
        module = "notify",
        lazy = false,
        opts = function()
            return require "custom.configs.notify"
        end,
        init = function ()
            vim.notify = require('notify')
        end,
    },

}

return plugins
