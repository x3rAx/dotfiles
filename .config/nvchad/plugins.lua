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


    {
        "rootkiter/vim-hexedit",
        cmd = { "Hexedit" },
        lazy = false, -- TODO: Only load when file is binary. Have a look at this commit to get an idea: https://github.com/RaafatTurki/hex.nvim/commit/944b9913d7fd39d51a2c2b5539ab138a9f22305a
    },

}

return plugins
