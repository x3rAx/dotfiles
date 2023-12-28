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

    {
        "williamboman/mason.nvim",
        opts = {
            ensure_installed = {}, -- Overwrite the default list to prevent installing binaries already installed by home-manager
        },
    },
}

return plugins
