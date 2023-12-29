local options = require('plugins.configs.nvimtree')

options = vim.tbl_deep_extend('force', options, {
    renderer = {
        -- Show current directory above tree
        root_folder_label = true,
    },
})

return options
