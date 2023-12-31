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

M.telescope = {
    n = {
        -- Show TODOs
        ["<leader>ft"] = { "<cmd>TodoTelescope<cr>", "Show TODOs" },
    }
}

-- Save file with <C-s> in normal, visual and insert mode
M.save_file = {
    n = { ["<C-s>"] = { function() vim.cmd("update") end, "Save file" } },
    v = { ["<C-s>"] = { function() vim.cmd("update") end, "Save file" } },
    i = { ["<C-s>"] = { function() vim.cmd("update") end, "Save file" } },
}

M.undo = {
    n = { ["<C-z>"] = { function() vim.cmd("undo") end, "Undo" } },
    i = { ["<C-z>"] = { function() vim.cmd("undo") end, "Undo" } },
}

M.redo = {
    n = { ["<C-S-z>"] = { function() vim.cmd("redo") end, "Redo" } },
    i = { ["<C-S-z>"] = { function() vim.cmd("redo") end, "Redo" } },
}

M.copy = {
    v = { ["<C-c>"] = { '"+y', "Copy to system clipboard" } },
}

M.background = {
    n = { ["<A-z>"] = { function() vim.cmd("suspend") end, "Send vim to background (replaces ctrl+z)" } },
}

M.quit = {
    n = { ["<C-q>"] = { function() vim.cmd("qa!") end, "Force close vim" } },
}

return M
