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
    },

    statusline = {
        overriden_modules = function(modules)
            -- Show current line and column number in the cursor_position
            -- module. This replaces the `vim.opt.ruler` option.
            modules[10] = (function ()
                -- Split the string at the first highlight group after the icon
                local icon, hl_txt, text = modules[10]:match("^(%S+%s+)(%%#.+#) (.*)")
                return icon .. hl_txt .. " %l,%c | " .. hl_txt .. text
            end)()
        end,
    },
}

M.plugins = 'custom.plugins'

M.mappings = require 'custom.mappings'

return M
