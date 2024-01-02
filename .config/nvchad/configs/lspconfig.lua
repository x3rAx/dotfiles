local M = require("plugins.configs.lspconfig")

local lspconfig = require("lspconfig")
local root_pattern = lspconfig.util.root_pattern

-- Extend the on_attach function
--M.on_attach = function(client, bufnr)
--    require("plugins.configs.lspconfig").on_attach(client, bufnr)
--
--    --if client.server_capabilities.documentSymbolProvider then
--    --    require('nvim-navic').attach(client, bufnr)
--    --end
--end

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

-- Manual server setup
--lspconfig.sumneko_lua.setup {
--    on_attach = on_attach,
--    capabilities = M.capabilities,
--    cmd = { "lua-language-server" },
--    settings = {
--        Lua = {
--            diagnostics = {
--                globals = { "vim" },
--            },
--        },
--    },
--}

return M
