---@type MappingsTable
local M = {}

M.disabled = {
    n = {
        -- Disable default "cycle through buffers" mappings
        ['<tab>'] = "",
        ['<S-tab>'] = "",
    }
}

M.tabufline = {
    n = {
        -- Cycle through buffers
        ["<C-.>"] = {
            function()
                require("nvchad.tabufline").tabuflineNext()
            end,
            "Goto next buffer",
        },
        ["<C-,>"] = {
            function()
                require("nvchad.tabufline").tabuflinePrev()
            end,
            "Goto prev buffer",
        },
    }
}

return M
