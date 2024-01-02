local options = require('plugins.configs.nvimtree')

options = vim.tbl_deep_extend('force', options, {
    renderer = {
        -- Show current directory above tree
        root_folder_label = true,
    },
    diagnostics = {
        enable = true, -- Show warning/error/etc. icon next to files
    },
})

return options
