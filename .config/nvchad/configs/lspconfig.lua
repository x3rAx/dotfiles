local M = require("plugins.configs.lspconfig")

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
        on_attach = M.on_attach,
        capabilities = M.capabilities,
    }
end

return M
