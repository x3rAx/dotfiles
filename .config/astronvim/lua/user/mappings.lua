-- NOTE: Use `./which-key.lua` to configure the keymap popup

local merge = require('x3ro.merge-mappings')


local quickSave = {
    n = { ["<C-s>"] = { ":silent update<CR>", desc = "Save File" } },
    i = { ["<C-s>"] = { "<C-o>:silent update<CR>", desc = "Save File" } },
    v = { ["<C-s>"] = { "<Esc>:silent update<CR>gv", desc = "Save File" } },
}


local astroMenu = {
    n = {
        ["<leader>Ar"] = { "<cmd>AstroReload<cr>", desc = "Reload Configuration" },
        ["<leader>Ac"] = { "" ..
        "<cmd>tabe " .. os.getenv("HOME") .. "/.config/astronvim/lua<CR>" ..
        "<cmd>Neotree focus<CR>",
            desc = "Open user configuration"
        },
    }
}


local commentLines = (function()
        local m = {
            n = { ["<C-/>"] = { "<Esc><Cmd>lua require('Comment.api').toggle.linewise.current()<CR>", desc = "Comment line" }, },
            v = { ["<C-/>"] = { "<Esc><Cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
                desc = "Toggle comment line" }, },
        }
        -- Alias for when inside a terminal that does not support `<C-/>` but sends `^_` instead
        m.n[""] = m.n["<C-/>"]
        m.v[""] = m.v["<C-/>"]
        return m
    end)()


local recentTelescopePickers = {
    n = {
        -- Open recent Telescope picker(s)
        ["<leader>fr"] = { "<cmd>Telescope resume<cr>", desc = "Open recent Telescope picker" },
        ["<leader>fR"] = { "<cmd>Telescope pickers<cr>", desc = "Select recent Telescope pickers" },
    }
}


local pasteWithoutYankingSelection = {
    v = { ["p"] = { "\"_c<C-r>\"<Esc>", desc = "Paste without yanking" }, }
}


local systemClipboard = merge({
        -- Copy using <C-c>
        v = { ["<C-c>"] = { "\"+ygv", desc = "Copy selection to system clipboard" } },
    }, {
        -- Copy to clipboard
        v = { ["<leader><leader>y"] = { "\"+y", desc = "Copy selection" } },
        n = {
            ["<leader><leader>Y"] = { "\"+yg_", desc = "Copy from cursor to end of line" },
            ["<leader><leader>y"] = { "\"+y", desc = "Copy with motion" },
        },
    }, {
        -- Cut to clipboard
        v = { ["<leader><leader>d"] = { "\"+d", desc = "Cut selection" } },
        n = {
            ["<leader><leader>D"] = { "\"+dg_", desc = "Cut from cursor to end of line" },
            ["<leader><leader>d"] = { "\"+d", desc = "Cut with motion" },
        },
    }, {
        -- Copy to clipboard
        v = { ["<leader><leader>p"] = { "\"+p", desc = "Paste replacing selection" } },
        n = {
            ["<leader><leader>P"] = { "\"+P", desc = "Paste above" },
            ["<leader><leader>p"] = { "\"+p", desc = "Paste below" },
        },
    })


local general = {
    n = { -- Normal mode bindings
        --["<leader>bb"] = { "<cmd>tabnew<cr>", desc = "New tab" },
        --["<leader>bc"] = { "<cmd>BufferLinePickClose<cr>", desc = "Pick to close" },
        --["<leader>bj"] = { "<cmd>BufferLinePick<cr>", desc = "Pick to jump" },
        --["<leader>bt"] = { "<cmd>BufferLineSortByTabs<cr>", desc = "Sort by tabs" },

        ["q:"] = { ":" }, -- Prevent opening the command history. Requires `timeoutlen` to be set reasonably high (e.g. 1000)

        ["<leader>Nd"] = { require('notify').dismiss, desc = "Dismiss notifications" },

        ["<M-`>"] = { require('x3ro.terminal').toggle, desc = "Toggle bottom terminal" },
    },
    i = { -- Insert mode bindings
    },
    v = { -- Visual mode bindings
    },
    t = { -- Terminal bindings
        -- setting a mapping to false will disable it
        -- ["<esc>"] = false,
    },
}


return require('x3ro.merge-mappings')(
        quickSave,
        astroMenu,
        commentLines,
        recentTelescopePickers,
        pasteWithoutYankingSelection,
        systemClipboard,
        general
    )
