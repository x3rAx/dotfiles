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

-- Rust
lspconfig.rust_analyzer.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    -- filetypes = { "rust" },
    -- root_dir = root_pattern("Cargo.toml"),
    settings = {
        ["rust-analyzer"] = {
            -- checkOnSave = {
            --     command = "clippy",
            -- },
            cargo = {
                allFeatures = true, -- Help with auto-completion on cargo crates
            },
        },
    },
}

