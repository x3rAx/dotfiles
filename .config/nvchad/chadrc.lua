---@type ChadrcConfig
local M = {}

M.ui = {
    theme = 'catppuccin',
    theme_toggle = { "catppuccin", "one_light" },
    hl_add = {
        -- Add custom highlighting to fix `vim-visual-multi` statusline
        TabLine = {
            fg = "white",
            bg = "statusline_bg"
        },
    }
}

M.plugins = 'custom.plugins'

M.mappings = require 'custom.mappings'

return M
