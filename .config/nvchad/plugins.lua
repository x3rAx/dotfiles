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
}

return plugins
