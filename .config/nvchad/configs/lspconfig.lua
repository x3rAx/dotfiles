local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")
local root_pattern = lspconfig.util.root_pattern

-- Servers to auto-setup
local servers = {
    "nil_ls", -- Nix
    "vimls", -- Vimscript
}

-- Auto-setup servers
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end


