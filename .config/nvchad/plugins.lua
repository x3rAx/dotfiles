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
        end,
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

    -- Multi-cursor
    {
        "mg979/vim-visual-multi",
        branch = 'master',
        event = 'VeryLazy',
        init = function()
            -- vim.g.VM_theme = 'nord' -- See: https://l.x3ro.net/Ftobnk4inu (selecting a theme)
            -- vim.g.VM_set_statusline = 0 -- Do not set statusline
            vim.g.VM_silent_exit = 1 -- Do not print "Exited Visual-Multi."

            -- Set statusline colors -- TODO: This also changes colors of the cursor and region selection. How to fix?
            vim.g.VM_Insert_hl = "Pmenu"
            vim.g.VM_Extend_hl = "St_NormalMode"
            vim.g.VM_Cursor_hl = "St_InsertMode"
            vim.g.VM_Mono_hl = "St_ReplaceMode"

            -- TODO: Move this into mappings.lua
            vim.g.VM_maps = {
                ['Find Under'] = '<M-C-L>',
                ['Find Subword Under'] = '<M-C-L>',
                ['Add Cursor Up'] = '<M-C-K>',
                ['Add Cursor Down'] = '<M-C-J>',
            }
        end,
    },

    -- Lorem Ipsum generator
    {
        "vim-scripts/loremipsum",
        event = 'VeryLazy',
    },

    -- Todo comment highlighting
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = 'VeryLazy',
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
    },

    -- BROKEN: Does not work with NvChad base64 theme plugin. Statusline is broken when activated.
    -- { "catppuccin/nvim", name = "catppuccin", priority = 1000, lazy = false },

    ---- TODO: Use this?
    --{
    --    "mrjones2014/smart-splits.nvim",
    --    event = 'VeryLazy',
    --    opts = {
    --        ignored_filetypes = { "nofile", "quickfix", "qf", "prompt" },
    --        ignored_buftypes = { "nofile" },
    --    }
    --},

    ---- TODO: Use this?
    ---- Toggleterm
    --{
    --    "akinsho/toggleterm.nvim",
    --    event = 'VeryLazy',
    --    config = function()
    --        require("toggleterm").setup {
    --            size = 20,
    --            open_mapping = [[<c-\>]],
    --            shade_filetypes = {},
    --            shade_terminals = true,
    --            shading_factor = 1,
    --            start_in_insert = true,
    --            insert_mappings = true,
    --            persist_size = true,
    --            direction = 'horizontal',
    --        }
    --    end,
    --},

    -- Modern folding
    -- BUG: It always folds functions when pressing ESC.
    --{
    --    "kevinhwang91/nvim-ufo",
    --    lazy = false,
    --    dependencies = {
    --        "kevinhwang91/promise-async",
    --    },
    --    opts = {
    --        preview = {
    --            mappings = {
    --                scrollB = "<C-b>",
    --                scrollF = "<C-f>",
    --                scrollU = "<C-u>",
    --                scrollD = "<C-d>",
    --            },
    --        },
    --        provider_selector = function(_, filetype, buftype)
    --            return (filetype == "" or buftype == "nofile") and "indent" -- only use indent until a file is opened
    --                or { "treesitter", "indent" } -- if file opened, try to use treesitter if available
    --        end,
    --    },
    --    init = function()
    --        vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
    --        vim.o.foldcolumn = '1'
    --    end,

    --}

    -- Language Server Config
    {
        "neovim/nvim-lspconfig",
        config = function()
            require "custom.configs.lspconfig"
        end,
    },

    -- Rust support (e.g. auto-foramtting)
    {
        "rust-lang/rust.vim",
        ft = { "rust" },
        init = function()
            vim.g.rustfmt_autosave = 1
        end,
    },

    -- Rust tools - a lot of useful tools for Rust development (including debugging)
    {
        "simrat39/rust-tools.nvim",
        dependencies = { "neovim/nvim-lspconfig" },
        ft = { "rust" },
        opts = function()
            return require "custom.configs.rust-tools"
        end,
    },

    -- DAP - Debugging adapter protocol
    {
        "mfussenegger/nvim-dap",
    },

    -- Cargo Crates support
    {
        "saecki/crates.nvim",
        tag = 'stable',
        dependencies = { 'nvim-lua/plenary.nvim' },
        event = { "BufRead Cargo.toml" },
        init = function()
            require("core.utils").load_mappings "crates"
        end,
        opts = function()
            return require "custom.configs.crates"
        end,
        config = function(_, opts)
            local crates = require("crates")
            crates.setup(opts)
            crates.show() -- Show crates versions when opening a Cargo.toml file
        end,
    },

    {
        "SmiteshP/nvim-navic",
        dependencies = {
            "neovim/nvim-lspconfig",
            "SmiteshP/nvim-navbuddy",
        },
        init = function()
            vim.o.winbar = "%{%v:lua.require'custom.lib.navic'.get_location()%}"
        end,
        opts = function()
            return require "custom.configs.navic"
        end,
    },

    {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
            "neovim/nvim-lspconfig",
            "SmiteshP/nvim-navic",
            "MunifTanjim/nui.nvim",
            "numToStr/Comment.nvim",        -- Optional
            "nvim-telescope/telescope.nvim" -- Optional
        },
        lazy = false,
        opts = { lsp = { auto_attach = true } }
    },

}

return plugins
