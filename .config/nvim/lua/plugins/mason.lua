return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      -- Add more tools to install
      local ensure_installed = {
      }

      -- Specify tools that should not be installed through Mason
      local prevent_install = {
        "stylua", -- Installed through home-manager
      }

      -- Merge ensure_installed lists
      vim.list_extend(opts.ensure_installed, ensure_installed)

      -- Remove elements that should not be installed
      opts.ensure_installed = vim.tbl_filter(function(elem)
        return not vim.tbl_contains(prevent_install, elem)
      end, opts.ensure_installed)
    end,
  },
}
