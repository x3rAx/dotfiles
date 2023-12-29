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

-- Save file with <C-s> in normal, visual and insert mode
M.save_file = {
    n = { ["<C-s>"] = { function() vim.cmd("update") end, "Save file" } },
    v = { ["<C-s>"] = { function() vim.cmd("update") end, "Save file" } },
    i = { ["<C-s>"] = { function() vim.cmd("update") end, "Save file" } },
}

return M
