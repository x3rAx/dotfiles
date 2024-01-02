local options = require 'plugins.configs.telescope'

options = vim.tbl_deep_extend('force', options, {
    pickers = {
        find_files = {
            -- Custom find command that also follows symlinks
            find_command = { "rg", "--files", "--hidden", "--iglob", "!**/.git/*", "-L" },
        },
    },
})

return options
