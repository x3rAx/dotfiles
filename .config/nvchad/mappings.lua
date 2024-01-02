---@type MappingsTable
local M = {}

M.disabled = {
    n = {
        -- Disable default "cycle through buffers" mappings
        ['<tab>'] = "",
        ['<S-tab>'] = "",
        ['<C-n>'] = "",
    }
}

M.nvimtree = {
  n = {
    -- toggle
    ["<leader>e"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },
    -- focus
    -- TODO: Find a good mappings for this
    -- ["<leader>o"] = { "<cmd> NvimTreeFocus <CR>", "Focus nvimtree" },
  },
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
        -- Open recent Telescope picker(s)
        ["<leader>fr"] = { "<cmd>Telescope resume<cr>", "Open recent Telescope picker" },
        ["<leader>fR"] = { "<cmd>Telescope pickers<cr>", "Select recent Telescope pickers" },
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

M.undo_redo = {
    n = {
        ["<C-z>"] = { function() vim.cmd("undo") end, "Undo" },
        ["<C-S-z>"] = { function() vim.cmd("redo") end, "Redo" }
    },
    i = {
        ["<C-z>"] = { function() vim.cmd("undo") end, "Undo" },
        ["<C-S-z>"] = { function() vim.cmd("redo") end, "Redo" }
    },
}

M.copy = {
    v = { ["<C-c>"] = { '"+y', "Copy to system clipboard" } },
}

M.background = {
    n = { ["<A-z>"] = { function() vim.cmd("suspend") end, "Send vim to background (replaces ctrl+z)" } },
}

M.quit = {
    n = {
        ["<C-q>"] = { function() vim.cmd("qa!") end, "Force close vim" },
        ["<leader>q"] = { function() vim.cmd("q") end, "Close current window" },
    },
}

M.dap = {
    n = {
        ["<leader>db"] = { "<cmd> DapToggleBreakpoint <CR>", "Toggle breakpoint" },
        ["<leader>dus"] = {
            function()
                local widgets = require("dap.ui.widgets")
                local sidebar = widgets.sidebar(widgets.scopes)
                sidebar.open()
            end,
           "Open debugging sidebar"
        },
        ["<leader>dC"] = { function() require('dap').continue() end, "Continue" },
        ["<leader>ds"] = { function() require('dap').step_over() end, "Step over" },
        ["<leader>dr"] = { function() require('dap').repl.open() end, "Open REPL" },
    },
}

M.crates = {
    plugin = true,
    n = {
        -- Update crates
        ["<leader>rcu"] = { function() require('crates').update_all_crates() end, "Update all crates" },
        -- Show popups
        ["<leader>rcc"] = { function() require('crates').show_crate_popup() end, "Show crate popup" },
        ["<leader>rcv"] = { function() require('crates').show_versions_popup() end, "Show versions popup" },
        ["<leader>rcf"] = { function() require('crates').show_features_popup() end, "Show features popup" },
        ["<leader>rcd"] = { function() require('crates').show_dependencies_popup() end, "Show dependencies popup" },
    },
}

return M
