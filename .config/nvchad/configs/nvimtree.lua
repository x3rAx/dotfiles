local options = require('plugins.configs.nvimtree')

options = vim.tbl_deep_extend('force', options, {
    renderer = {
        -- Show current directory above tree
        root_folder_label = true,
        -- highlight_git = true,
        icons = {
            show = {
                git = true,
            }
        }
    },
    diagnostics = {
        enable = true, -- Show warning/error/etc. icon next to files
    },
    git = {
        enable = true, -- Show git status
    },
})

return options
