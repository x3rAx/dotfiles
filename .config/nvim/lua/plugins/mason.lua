return {
  {
    "williamboman/mason.nvim",
    lazy = true,
    opts = function(_, opts)
      -- Add more tools to install
      local ensure_installed = {}

      -- Specify tools that should not be installed through Mason
      local prevent_install = {}

      -- Merge ensure_installed lists
      vim.list_extend(opts.ensure_installed, ensure_installed)

      -- Remove elements that should not be installed
      opts.ensure_installed = vim.tbl_filter(function(elem)
        return not vim.tbl_contains(prevent_install, elem)
      end, opts.ensure_installed)

      return opts
    end,
  },

  {
    "https://github.com/neovim/nvim-lspconfig",
    lazy = true,
    opts = {
      servers = {
        rust_analyzer = { mason = false }, -- Installed through home-manager; Does not play well with `cargo` installed through Nix
        clangd = { mason = false }, -- Installed through home-manager
      },
    },
  },
}
