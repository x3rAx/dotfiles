return {
  { "kaarmu/typst.vim" },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        typst_lsp = {
          settings = {
            exportPdf = "onType", -- Choose onType, onSave or never.
            -- serverPath = "" -- Normally, there is no need to uncomment it.
          },
        },
      },
    },
  },
}
