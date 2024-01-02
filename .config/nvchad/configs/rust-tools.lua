local on_attach = require("custom.configs.lspconfig").on_attach
local capabilities = require("custom.configs.lspconfig").capabilities

local options = {
    -- Configure LSP server (rust-analyzer)
    server = {
        on_attach = on_attach,
        capabilities = capabilities,
    },
}

return options
