local colors = require 'custom.lib.colors'

---@type ChadrcConfig
local M = {}

M.ui = {
    theme = 'catppuccin',
    theme_toggle = { "catppuccin", "one_light" },

    hl_override = {
        DiagnosticError = { fg = colors.dimmed('#f38ba8', 0.5) },
        DiagnosticWarn = { fg = colors.dimmed('#fae3b0', 0.5) },
        DiagnosticInfo = { fg = colors.dimmed('LightBlue', 0.5) },
        DiagnosticHint = { fg = colors.dimmed('#d0a9e5', 0.5) },
        DiagnosticOk = { fg = colors.dimmed('LightGreen', 0.5) },
    },
    hl_add = {
        -- Add custom highlighting to fix `vim-visual-multi` statusline
        TabLine = {
            fg = "white",
            bg = "statusline_bg"
        },
        NvimTreeGitStaged   = { fg = colors.color2hex('LightGreen') },
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
