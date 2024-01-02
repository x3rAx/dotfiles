local cmp = require "cmp"

local options = require "plugins.configs.cmp"

options.mapping['<Tab>'] = nil
options.mapping["<S-Tab>"] = nil
options.mapping["<CR>"] = nil

options = vim.tbl_deep_extend("force", options, {
    mappings = {
        -- Close completion window
        ["<S-Esc>"] = cmp.mapping.close(),

        -- Accept completion
        ["<Tab>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        },
    },

    sources = vim.list_extend(options.sources, {
        { name = "crates" } -- Enable auto-completion for crates
    }),
})


return options
