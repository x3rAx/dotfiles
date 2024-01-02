local cmp = require "cmp"

local options = require "plugins.configs.cmp"

options.mapping['<Tab>'] = nil
options.mapping["<S-Tab>"] = nil
options.mapping["<CR>"] = nil

options.mapping = vim.tbl_extend("force", options.mapping, {

    -- Close completion window
    ["<S-Esc>"] = cmp.mapping.close(),

    -- Accept completion
    ["<Tab>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },

})

-- Enable auto-completion for crates
table.insert(options.sources, {
    name = "crates",
})

return options
